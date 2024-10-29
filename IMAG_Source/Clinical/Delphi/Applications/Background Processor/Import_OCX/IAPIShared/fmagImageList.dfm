object frmImageList: TfrmImageList
  Left = 547
  Top = 121
  HelpContext = 10097
  Caption = 'Image List:'
  ClientHeight = 895
  ClientWidth = 928
  Color = 14737359
  Constraints.MinHeight = 250
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  ShowHint = True
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object splpnlAbs: TSplitter
    Left = 129
    Top = 87
    Width = 5
    Height = 761
    Visible = False
    ExplicitHeight = 747
  end
  object splpnlTree: TSplitter
    Left = 281
    Top = 87
    Width = 5
    Height = 761
    Visible = False
    ExplicitHeight = 747
  end
  object stbarImagelist: TStatusBar
    Left = 0
    Top = 874
    Width = 928
    Height = 21
    Constraints.MaxHeight = 21
    Constraints.MinHeight = 21
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
    ParentFont = True
    UseSystemFont = False
  end
  object pnlAbs: TPanel
    Left = 0
    Top = 87
    Width = 129
    Height = 761
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnlAbs'
    ParentColor = True
    TabOrder = 1
    Visible = False
    object ListWinAbsViewer: TMag4Viewer
      Left = 20
      Top = 40
      Width = 73
      Height = 333
      DragKind = dkDock
      Color = 14737359
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      PopupMenu = popupAbstracts
      ShowHint = True
      TabOrder = 0
      OnDragDrop = ListWinAbsViewerDragDrop
      OnDragOver = ListWinAbsViewerDragOver
      AbsWindow = False
      DisplayStyle = MagdsLine
      ViewerStyle = MagvsVirtual
      OnViewerImageClick = ListWinAbsViewerViewerImageClick
      PopupMenuImage = popupAbstracts
      ViewStyle = MagViewerViewAbs
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
      AutoRedraw = False
      ClearBeforeAddDrop = False
      RowCount = 1
      RowSpacing = 5
      ColumnSpacing = 5
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
        73
        333)
    end
  end
  object pnlMain: TPanel
    Left = 300
    Top = 116
    Width = 705
    Height = 512
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    Visible = False
    object splpnlFullRes: TSplitter
      Left = 0
      Top = 249
      Width = 705
      Height = 5
      Cursor = crVSplit
      Align = alTop
      Visible = False
      ExplicitTop = 289
    end
    object pnlMagListView: TPanel
      Left = 0
      Top = 0
      Width = 705
      Height = 249
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object slppnlAbsPreview: TSplitter
        Left = 193
        Top = 0
        Width = 5
        Height = 249
        Visible = False
        ExplicitLeft = 225
        ExplicitHeight = 289
      end
      object pnlAbsPreview: TPanel
        Left = 0
        Top = 0
        Width = 193
        Height = 249
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        Visible = False
        object splMemInfo: TSplitter
          Left = 0
          Top = 77
          Width = 193
          Height = 5
          Cursor = crVSplit
          Align = alTop
          ExplicitWidth = 225
        end
        object lvImageInfo: TListView
          Left = 4
          Top = 128
          Width = 101
          Height = 141
          Color = clInfoBk
          Columns = <
            item
              Caption = 'Property'
              Width = 75
            end
            item
              AutoSize = True
              Caption = 'Value'
            end>
          DragMode = dmAutomatic
          ReadOnly = True
          TabOrder = 0
          ViewStyle = vsReport
        end
        object Mag4Vgear1: TMag4VGear
          Left = 0
          Top = 0
          Width = 193
          Height = 77
          Align = alTop
          TabOrder = 1
          OnClick = Mag4VGear1Click
          SelectionWidth = 4
          ShowImageOnly = False
          AbstractImage = False
          ZoomWindow = False
          PanWindow = False
          IsDragAble = False
          IsSizeAble = False
          AutoRedraw = True
          Selected = False
          OnImageClick = Mag4VGear1ImageClick
          OnImageMouseDown = Mag4VGear1ImageMouseDown
          OnImageMouseUp = Mag4VGear1ImageMouseUp
          ListIndex = -1
          PageCount = 0
          Page = 0
          ImageDescription = '<image description>'
          FontSize = 0
          ViewStyle = MagGearViewFull
          ImageViewState = MagGearImageViewFull
          ImageLoaded = False
          ShowPixelValues = False
          HistogramWindowLevel = True
          ShowLabels = True
          ImageNumber = 0
          DesignSize = (
            193
            77)
        end
      end
      object pnlMagListView1: TPanel
        Left = 208
        Top = 11
        Width = 415
        Height = 192
        BevelOuter = bvNone
        Caption = 'pnlMagListView1'
        ParentColor = True
        TabOrder = 1
        object splmemReport: TSplitter
          Left = 0
          Top = 150
          Width = 415
          Height = 5
          Cursor = crVSplit
          Align = alBottom
          Visible = False
          ExplicitWidth = 369
        end
        object MagListView1: TMagListView
          Left = 25
          Top = 54
          Width = 125
          Height = 50
          Checkboxes = True
          Color = 16382455
          Columns = <>
          Constraints.MinHeight = 50
          GridLines = True
          HotTrackStyles = [htUnderlineHot]
          PopupMenu = menuMagListView
          SmallImages = DMod.ImageListStatusIcons
          StateImages = DMod.ImageListStateIcons
          TabOrder = 1
          OnClick = MagListView1Click
          OnDblClick = MagListView1DblClick
          OnGetSubItemImage = MagListView1GetSubItemImage
          OnKeyDown = MagListView1KeyDown
          OnKeyUp = MagListView1KeyUp
          OnSelectItem = MagListView1SelectItem
        end
        object memReport: TMemo
          Left = 0
          Top = 155
          Width = 415
          Height = 37
          TabStop = False
          Align = alBottom
          Anchors = []
          Color = clInfoBk
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          PopupMenu = fontDlgReport
          ReadOnly = True
          ScrollBars = ssBoth
          TabOrder = 2
          Visible = False
          WordWrap = False
        end
        object pnlROIoptions: TPanel
          Left = 0
          Top = 0
          Width = 415
          Height = 55
          Align = alTop
          ParentColor = True
          TabOrder = 0
          Visible = False
          object Shape1: TShape
            Left = 1
            Top = 1
            Width = 410
            Height = 52
            Brush.Style = bsClear
          end
          object lbCheckedImageCount: TLabel
            Left = 262
            Top = 7
            Width = 125
            Height = 13
            Caption = '<number selected to print>'
          end
          object lbCheckAll: TLabel
            Left = 257
            Top = 31
            Width = 45
            Height = 13
            Cursor = crHandPoint
            Caption = 'Check All'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Visible = False
            OnClick = lbCheckAllClick
            OnMouseEnter = lbCheckAllMouseEnter
            OnMouseLeave = lbCheckAllMouseLeave
          end
          object lbCheckNone: TLabel
            Left = 336
            Top = 31
            Width = 60
            Height = 13
            Cursor = crHandPoint
            Caption = 'Check None'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            Visible = False
            OnClick = lbCheckNoneClick
            OnMouseEnter = lbCheckNoneMouseEnter
            OnMouseLeave = lbCheckNoneMouseLeave
          end
          object Label3: TLabel
            Left = 70
            Top = 4
            Width = 100
            Height = 13
            Caption = 'ROI Multi Image Print'
          end
          object lbCheckButtons: TLabel
            Left = 262
            Top = 30
            Width = 31
            Height = 13
            Caption = 'Check'
          end
          object btnContinueToROIPrintWindow: TBitBtn
            Left = 23
            Top = 23
            Width = 75
            Height = 25
            Hint = 'Contine to ROI Print window'
            Caption = 'Continue...'
            TabOrder = 0
            OnClick = btnContinueToROIPrintWindowClick
            NumGlyphs = 2
          end
          object btnCancelCheckBoxSelection: TBitBtn
            Left = 132
            Top = 23
            Width = 75
            Height = 25
            Hint = 'Cancel checking Images for ROI Print.'
            Cancel = True
            Caption = 'Cancel'
            TabOrder = 1
            OnClick = btnCancelCheckBoxSelectionClick
            NumGlyphs = 2
          end
          object btnCheckAll: TBitBtn
            Left = 349
            Top = 26
            Width = 33
            Height = 20
            Caption = '&All'
            TabOrder = 3
            TabStop = False
            OnClick = btnCheckAllClick
          end
          object btnCheckNone: TBitBtn
            Left = 308
            Top = 26
            Width = 33
            Height = 20
            Caption = '&None'
            TabOrder = 2
            TabStop = False
            OnClick = btnCheckNoneClick
          end
        end
      end
    end
    object pnlfullres: TPanel
      Left = 32
      Top = 308
      Width = 649
      Height = 269
      BevelOuter = bvNone
      Caption = 'pnlfullres'
      ParentColor = True
      TabOrder = 1
      Visible = False
      OnDockOver = pnlfullresDockOver
      object ListWinFullViewer: TMag4Viewer
        Left = -22
        Top = 47
        Width = 479
        Height = 110
        DragKind = dkDock
        Color = 14737359
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        PopupMenu = popupImage
        ShowHint = True
        TabOrder = 0
        AbsWindow = False
        DisplayStyle = MagdsLine
        ViewerStyle = MagvsDynamic
        OnViewerImageClick = ListWinFullViewerViewerImageClick
        PopupMenuImage = popupImage
        ViewStyle = MagViewerViewFull
        UseAutoReAlign = True
        ImageFontSize = 8
        ShowToolbar = False
        LockSize = False
        ZoomWindow = False
        PanWindow = False
        Scrollable = False
        ScrollVertical = False
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
        MaxCount = 12
        LockWidth = 0
        LockHeight = 0
        ShowDescription = True
        ImagePageCount = 0
        ImagePage = 0
        MaxAutoLoad = -1
        WindowLevelSettings = MagWinLevImageSettings
        DesignSize = (
          479
          110)
      end
      object magViewerTB81: TMagViewerTB8
        Left = 0
        Top = 0
        Width = 649
        Height = 94
        Align = alTop
        AutoSize = True
        ParentShowHint = False
        ShowHint = False
        TabOrder = 1
        MagViewer = ListWinFullViewer
        OnPrintClick = magViewerTB81PrintClick
        OnCopyClick = magViewerTB81CopyClick
      end
    end
  end
  object fMagRemoteToolbar1: TfMagRemoteToolbar
    Left = 0
    Top = 848
    Width = 928
    Height = 26
    Align = alBottom
    AutoSize = True
    TabOrder = 3
  end
  object pnlTree: TPanel
    Left = 134
    Top = 87
    Width = 147
    Height = 761
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnlTree'
    ParentColor = True
    TabOrder = 4
    Visible = False
    object splpnlabstree: TSplitter
      Left = 0
      Top = 756
      Width = 147
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitTop = 742
    end
    object MagTreeView1: TMagTreeView
      Left = 16
      Top = 84
      Width = 85
      Height = 297
      AutoExpand = True
      Color = 16382455
      HideSelection = False
      Images = DMod.ImageListStatusIcons
      Indent = 19
      ReadOnly = True
      RowSelect = True
      StateImages = DMod.ImageListStateIcons
      TabOrder = 0
      OnChange = MagTreeView1Change
      OnClick = MagTreeView1Click
      OnCollapsed = MagTreeView1Collapsed
      OnDblClick = MagTreeView1DblClick
      OnExpanded = MagTreeView1Expanded
      OnGetSelectedIndex = MagTreeView1GetSelectedIndex
      OnKeyDown = MagTreeView1KeyDown
      OnMouseDown = MagTreeView1MouseDown
      OnMouseMove = MagTreeView1MouseMove
    end
    object pgctrlTreeView: TPageControl
      Left = 0
      Top = 0
      Width = 147
      Height = 26
      ActivePage = tabshSpec2
      Align = alTop
      HotTrack = True
      Style = tsButtons
      TabOrder = 1
      OnChange = pgctrlTreeViewChange
      object tabshPkg2: TTabSheet
        Caption = 'Pkg'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
      end
      object tabshSpec2: TTabSheet
        Caption = 'Spec'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
      end
      object tabshType2: TTabSheet
        Caption = 'Type'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
      end
      object tabshClass2: TTabSheet
        Caption = 'Class'
        ImageIndex = 3
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
      end
    end
  end
  object pnlMainToolbar: TPanel
    Left = 0
    Top = 0
    Width = 928
    Height = 56
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnlMainToolbar'
    ParentColor = True
    TabOrder = 5
    object Panel2: TPanel
      Left = 56
      Top = 0
      Width = 872
      Height = 56
      Align = alClient
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 0
      object magObserverLabel1: TMagObserverLabel
        Left = 29
        Top = 32
        Width = 44
        Height = 24
        Align = alLeft
        Caption = '<patient>'
        Color = clMoneyGreen
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object Label2: TLabel
        Left = 73
        Top = 32
        Width = 18
        Height = 24
        Align = alLeft
        AutoSize = False
        Color = clMoneyGreen
        ParentColor = False
        Transparent = True
      end
      object pnlFilterDesc: TLabel
        Left = 91
        Top = 32
        Width = 57
        Height = 24
        Align = alLeft
        Caption = 'Filter : None'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
        ExplicitHeight = 13
      end
      object Label1: TLabel
        Left = 148
        Top = 32
        Width = 8
        Height = 24
        Align = alLeft
        AutoSize = False
        Color = clMoneyGreen
        ParentColor = False
        Transparent = True
      end
      object lbSpacer: TLabel
        Left = 26
        Top = 32
        Width = 3
        Height = 24
        Align = alLeft
        ExplicitHeight = 13
      end
      object pnlContext: TPanel
        Left = 0
        Top = 32
        Width = 26
        Height = 24
        Align = alLeft
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object imgCCOWbroken1: TImage
          Left = 0
          Top = 0
          Width = 26
          Height = 24
          Hint = 'Not linked in Context'
          Center = True
          Picture.Data = {
            07544269746D6170B6070000424DB60700000000000036000000280000001A00
            0000180000000100180000000000800700000000000000000000000000000000
            0000C0C0C0B2B2B2969696999966999966999966999966999966A4A0A0C0C0C0
            C0C0C0C0C0C0C0C0C0B2B2B2666699666699666699666699666699969696C0C0
            C0868686808080808080808080C0C0C00000C0C0C0A4A0A09933006633006633
            00663300663300800000996666B2B2B2B2B2B2B2B2B2C0C0C066669900006600
            0066000066000066000066000080C0C0C0111111040404040404040404040404
            0000C0C0C0C0C0C0993333993300993300993300993300993300999966C0C0C0
            C0C0C0C0C0C0C0C0C0969696000080000080000080000080000080000080C0C0
            C02222220404040404040404040C0C0C0000C0C0C0C0C0C09933339933009933
            00663300663300663300996666B2B2B2B2B2B2C0C0C0C0C0C096969600008000
            0080000080000080000080000080C0C0C02222220404040404040404040C0C0C
            0000C0C0C0C0C0C0993333993300663300333333424242393939424242666666
            C0C0C0C0C0C0C0C0C0666699000066000066000066000080000080000080C0C0
            C02222220404040404040404040C0C0C0000C0C0C0C0C0C09933339933006633
            33CBCBCBCCCCCCCCCCCCB2B2B2868686C0C0C0C0C0C06666664D4D4D33333333
            3333000033000066000080333399C0C0C02222220404040404040404040C0C0C
            0000C0C0C0C0C0C09933336633008686869696963939396633334D4D4DB2B2B2
            C0C0C0B2B2B2868686C0C0C0CBCBCBD7D7D786868600003300006600008090A9
            AD2222220404040404040404040C0C0C0000C0C0C0B2B2B2993333663300C0C0
            C04D4D4D330000330000333333969696C0C0C0C0C0C055555539393933336655
            5555C0C0C04242420000660000803333660808080404040404040404040C0C0C
            0000999966993333993300663300777777C0C0C07777777777775F5F5F663333
            B2B2B2C0C0C0333366000033000033080808A4A0A07777770000660000330808
            080404040404040404040404040C0C0C00009966669933009933009933006633
            00969696B2B2B2B2B2B2969696663333B2B2B2B2B2B23333665F5F5F5F5F5F80
            8080C0C0C03333660000800000330404040404040404040404040404040C0C0C
            0000996666993300993300993300993300663300663300663300663300663333
            B2B2B2B2B2B2777777C0C0C0C0C0C0C0C0C06666660000660000800000330404
            040404040404040404040404040C0C0C00009966669933009933009933009933
            00993300993300993300993300993333B2B2B2C0C0C033336600006600006600
            00660000660000800000800000330404040404040404040404040404040C0C0C
            0000996666993300993300993300993300993300993300993300993300993333
            B2B2B2C0C0C03333990000800000800000800000800000800000800000330404
            0404040404040404040404040411111100009966669933009933009933009933
            00993300993300993300993300993333B2B2B2C0C0C033339900008000008000
            00800000800000800000800000330404040404040404040404040404040C0C0C
            0000996666993300993300993300993300993300993300993300993300993300
            B2B2B2C0C0C06666993333990000800000800000800000800000800000330404
            040404040404040404040404040C0C0C00009696969966339933009933009933
            00993300993300993300993333996666B2B2B2C0C0C0CCCCCC96969600008000
            00800000800000800000800000663939390C0C0C0404040404040404040C0C0C
            0000C0C0C0C0C0C0993333993300993300993300993300993300999966CBCBCB
            C0C0C0C0C0C0C0C0C0B2B2B290A9AD333399000080000080666699C0C0C0C0C0
            C01C1C1C0404040404040404040C0C0C0000C0C0C0C0C0C0A4A0A09966669933
            00993300993333A4A0A0B2B2B2C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0B2B2B233
            3399000080000080666699C0C0C0C0C0C09999995F5F5F0404040404040C0C0C
            0000C0C0C0C0C0C0CBCBCB999966993300993300996633B2B2B2CBCBCBC0C0C0
            C0C0C0C0C0C0C0C0C090A9AD000080000080000080000080000080333399C0C0
            C0C0C0C07777770404040404040C0C0C0000C0C0C0C0C0C09966339933009933
            00993300993300993300A4A0A0C0C0C0C0C0C0C0C0C0CBCBCB66669900008000
            0080000080000080000080000080C0C0C04D4D4D040404040404040404111111
            0000C0C0C0B2B2B2993333993300993300993300993300993300999966CBCBCB
            C0C0C0C0C0C0CBCBCB969696000080000080000080000080000080000080A4A0
            A01C1C1C0404040404040404041111110000C0C0C0B2B2B29933339933009933
            00993300993300993300999966CBCBCBC0C0C0C0C0C0C0C0C090A9AD33339900
            0080000080000080000080333399B2B2B21C1C1C0404040404040404040C0C0C
            0000C0C0C0C0C0C0996633993300993300993300993300993300A4A0A0CBCBCB
            C0C0C0C0C0C0C0C0C0C0C0C0B2B2B29999CCB2B2B2B2B2B29999CCC0C0C0C0C0
            C0C0C0C00404040808080808081616160000C0C0C0C0C0C0C0C0C0999999A4A0
            A0A4A0A0999999A4A0A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000}
          Stretch = True
          Transparent = True
        end
        object imgCCOWchanging1: TImage
          Left = 0
          Top = 0
          Width = 26
          Height = 24
          Hint = 'Context is Changing...'
          Center = True
          Picture.Data = {
            07544269746D6170B6070000424DB60700000000000036000000280000001A00
            0000180000000100180000000000800700000000000000000000000000000000
            0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C0A4A0A09999669999
            66999966999966999966A4A0A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0B2B2B2996633993300993300993300993300993300996666CBCBCB
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0B2B2B29966339933009933
            00993300993300993300996666C0C0C0B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0B2B2B2996633993300993300663300660000330000663333868686
            868686777777777777777777969696B2B2B2B2B2B2C0C0C0C0C0C0CBCBCBCBCB
            CBCBCBCBC0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0B2B2B29966339933006633
            004D4D4D7777777777776666663333334D4D4D80808080808077777766666696
            9696B2B2B2C0C0C0C0C0C0999999969696A4A0A0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0B2B2B2996633993300663333CCCCCCC0C0C0B2B2B2B2B2B2B2B2B2
            B2B2B2B2B2B2B2B2B2CCCCCC999999666666A4A0A0C0C0C0B2B2B29933009933
            00993300B2B2B2C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C09966336633009696
            96808080330000330000663333F1F1F1B2B2B2555555666666424242B2B2B266
            6666B2B2B2C0C0C0B2B2B2993300993300993300B2B2B2C0C0C0C0C0C0C0C0C0
            0000B2B2B2A4A0A0996633663300999999808080330000330000393939F1F1F1
            B2B2B24D4D4D666666393939B2B2B2777777C0C0C0C0C0C0B2B2B29966339966
            33996633B2B2B2C0C0C0C0C0C0C0C0C000009999669933009933009933006633
            33D7D7D7B2B2B2B2B2B2B2B2B2C0C0C0B2B2B2A4A0A0999999C0C0C099999986
            8686C0C0C0C0C0C0C0C0C0CBCBCBCBCBCBCBCBCBC0C0C0C0C0C0C0C0C0C0C0C0
            0000999966993300993300993300663300666633777777777777666666292929
            555555868686868686868686868686C0C0C0C0C0C0C0C0C0C0C0C09999669966
            66999966C0C0C0C0C0C0C0C0C0C0C0C000009999669933009933009933009933
            00663300663300663300663300993300A4A0A0B2B2B2A4A0A0A4A0A0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0996633993300993300B2B2B2CBCBCBC0C0C0C0C0C0
            0000999966993300993300993300993300993300993300993300993300993300
            B2B2B2CBCBCBC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0A4A0A09933
            00993300996666C0C0C0C0C0C0C0C0C000009999669933009933009933009933
            00993300993300993300993300993300B2B2B2C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0996666993300993300999966C0C0C0C0C0C0
            0000999966993300993300993300993300993300993300993300993300993300
            B2B2B2C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0996633993300993300969696C0C0C000009999669933009933009933009933
            00993300993300993300993300993300B2B2B2C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0CBCBCBCBCBCBCBCBCBC0C0C0996633993300993300996633C0C0C0
            0000B2B2B2969696993333993300993300993300993300993300996633A4A0A0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0999966996666A4A0A0A4A0A09999
            66993300993300993300996633C0C0C00000C0C0C0C0C0C09966669933339933
            00993300993300996633969696CCCCCCC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0996633993300993300993300993300993300993300993300999966C0C0C0
            0000C0C0C0C0C0C0CCCCCCA4A0A0993300993300993333C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C09966669933009933009933009933
            00993300993333999966C0C0C0C0C0C00000C0C0C0C0C0C0A4A0A09966339933
            00993300993300996666B2B2B2C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0A4A0A0A4A0A0969696969696A4A0A0B2B2B2CBCBCBC0C0C0C0C0C0
            0000C0C0C0B2B2B2996633993300993300993300993300993300996666CBCBCB
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0CBCBCBCBCBCBCBCBCBCBCB
            CBCBCBCBC0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0B2B2B29966339933009933
            00993300993300993300996666CBCBCBC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0C0C0C0996633993300993300993300993300993300999966CBCBCB
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C0C0C0C09966339966
            33996633996633996633C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000}
          Stretch = True
          Transparent = True
        end
        object imgCCOWLink1: TImage
          Left = 0
          Top = 0
          Width = 26
          Height = 24
          Hint = 'Patient is Linked in Context'
          Center = True
          Picture.Data = {
            07544269746D6170B6070000424DB60700000000000036000000280000001A00
            0000180000000100180000000000800700000000000000000000000000000000
            0000C0C0C0C0C0C0A4A0A0999966999966999966999966999966A4A0A0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C09966338000006633
            00663300663300800000996633C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0CBCBCB996633993300993300993300993300993300996633C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C09966339933009933
            00663300663300663300663333999999999999969696868686868686999999B2
            B2B2C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0C0C0C0996633993300993300663300393939393939424242424242
            4242425555555F5F5F5555555F5F5F969696B2B2B2C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C09966339933006633
            00B2B2B2D7D7D7CBCBCBC0C0C0868686969696C0C0C0C0C0C0CCCCCCA4A0A05F
            5F5FA4A0A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0CBCBCB996633663300666666B2B2B2424242663333663333DDDDDD
            D7D7D75555556666665F5F5FB2B2B2666666868686C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C09966336633009999
            998080800C0C0C330000333300D7D7D7C0C0C055555580808033333386868686
            8686868686C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000999999996633993300993300663333CBCBCB808080666666777777DDDDDD
            D7D7D7777777777777868686C0C0C0666666B2B2B2C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000009696969933009933009933006633
            00808080B2B2B2B2B2B2B2B2B25F5F5F5F5F5FB2B2B2B2B2B2B2B2B286868699
            9999C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000969696993300993300993300993300663300663300663300663300663300
            996666868686868686868686A4A0A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000009696969933009933009933009933
            00993300993300993300993300993300CC9999CCCCCCCCCCCCCCCCCCC0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000969696993300993300993300993300993300993300993300993300993300
            A4A0A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000009696969933009933009933009933
            00993300993300993300993300993300A4A0A0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000969696993300993300993300993300993300993300993300993300993300
            A4A0A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000A4A0A09966339933009933009933
            00993300993300993300993333996633A4A0A0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0CBCBCB996633993300993300993300993300993300996633CBCBCB
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C0A4A0A09999669933
            00993300993300999966B2B2B2C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0C0C0C0CBCBCBA4A0A0993300993300993300A4A0A0CBCBCBC0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C09966669933009933
            00993300993300993300999966C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0C0C0C0996633993300993300993300993300993300996633C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C09966339933009933
            00993300993300993300996633C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000C0C0C0CBCBCB996666993300993300993300993300993300999966CBCBCB
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C0C0C0C09999999999
            99999999999999A4A0A0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            0000}
          Stretch = True
          Transparent = True
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 872
        Height = 32
        Align = alTop
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 1
        object PageScroller1: TPageScroller
          Left = 0
          Top = 0
          Width = 872
          Height = 30
          Align = alTop
          Control = tlbrImageListMain
          TabOrder = 0
          object tlbrImageListMain: TToolBar
            Left = 0
            Top = 0
            Width = 1864
            Height = 30
            Align = alNone
            ButtonHeight = 30
            ButtonWidth = 35
            Caption = 'tlbrImageListMain'
            DisabledImages = ilMain24u
            EdgeInner = esNone
            EdgeOuter = esNone
            Images = ilMain24n
            TabOrder = 0
            Transparent = True
            Wrapable = False
            object tbtnPatient: TToolButton
              Left = 0
              Top = 0
              Hint = 'Select a Patient'
              Caption = 'tbtnPatient'
              ImageIndex = 0
              OnClick = tbtnPatientClick
            end
            object tbtnRefresh: TToolButton
              Left = 35
              Top = 0
              Hint = 'Refresh Patient Images'
              Caption = 'tbtnRefresh'
              ImageIndex = 1
              OnClick = tbtnRefreshClick
            end
            object tbtnFilter: TToolButton
              Left = 70
              Top = 0
              Hint = 'Select/Create an Image Filter <Ctrl + L>'
              Caption = 'tbtnFilter'
              ImageIndex = 2
              OnClick = tbtnFilterClick
            end
            object tbtnUserPref: TToolButton
              Left = 105
              Top = 0
              Hint = 'configure User Preferences'
              Caption = 'tbtnUserPref'
              ImageIndex = 4
              OnClick = tbtnUserPrefClick
            end
            object tbtnAbstracts: TToolButton
              Left = 140
              Top = 0
              Hint = 'Show/Hide Abstracts'
              Caption = 'tbtnAbstracts'
              ImageIndex = 3
              Style = tbsCheck
              OnClick = tbtnAbstractsClick
            end
            object ToolButton2: TToolButton
              Left = 175
              Top = 0
              Width = 8
              Caption = 'ToolButton2'
              ImageIndex = 13
              Style = tbsSeparator
            end
            object tbtnImage: TToolButton
              Left = 183
              Top = 0
              Hint = 'Open the Image.'
              Caption = 'tbtnImage'
              ImageIndex = 5
              OnClick = tbtnImageClick
            end
            object tbtnReport: TToolButton
              Left = 218
              Top = 0
              Hint = 'Open the Report'
              Caption = 'tbtnReport'
              ImageIndex = 6
              OnClick = tbtnReportClick
            end
            object tbtnPrevAbs: TToolButton
              Left = 253
              Top = 0
              Hint = 'Preview Abstract of selected list item.'
              Caption = 'tbtnPrevAbs'
              ImageIndex = 7
              Style = tbsCheck
              OnClick = tbtnPrevAbsClick
            end
            object tbtnPrevReport: TToolButton
              Left = 288
              Top = 0
              Hint = 'Preview Report of selected list item.'
              Caption = 'tbtnPrevReport'
              ImageIndex = 8
              Style = tbsCheck
              OnClick = tbtnPrevReportClick
            end
            object tbtnFitCol: TToolButton
              Left = 323
              Top = 0
              Hint = 'Fit Columns to Text'
              Caption = 'tbtnFitCol'
              ImageIndex = 9
              OnClick = tbtnFitColClick
            end
            object tbtnFitColWin: TToolButton
              Left = 358
              Top = 0
              Hint = 'Fit Columns in Window'
              Caption = 'tbtnFitColWin'
              ImageIndex = 10
              OnClick = tbtnFitColWinClick
            end
            object tbtnSelectColumn: TToolButton
              Left = 393
              Top = 0
              Hint = 'Select Columns'
              Caption = 'tbtnSelectColumn'
              ImageIndex = 11
              OnClick = tbtnSelectColumnClick
            end
          end
        end
      end
    end
    object pnlPatPhoto: TPanel
      Left = 0
      Top = 0
      Width = 56
      Height = 56
      Align = alLeft
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 1
      DesignSize = (
        56
        56)
      object MagPatPhoto1: TMagPatPhoto
        Left = 0
        Top = 0
        Width = 56
        Height = 56
        Anchors = [akLeft, akTop, akRight, akBottom]
        TabOrder = 0
        OnClick = MagPatPhoto1Click
        MagHideWhenNull = False
      end
    end
  end
  object pnlFilterTabs: TPanel
    Left = 0
    Top = 56
    Width = 928
    Height = 31
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 6
    object tabctrlFilters: TTabControl
      Left = 0
      Top = 5
      Width = 928
      Height = 26
      Align = alBottom
      HotTrack = True
      ParentShowHint = False
      PopupMenu = FilterTabPopup
      ShowHint = False
      Style = tsButtons
      TabHeight = 19
      TabOrder = 0
      Tabs.Strings = (
        'Test Filter B')
      TabIndex = 0
      OnChange = tabctrlFiltersChange
      OnChanging = tabctrlFiltersChanging
    end
  end
  object pnlfocus: TPanel
    Left = 792
    Top = 63
    Width = 5
    Height = 41
    Color = clYellow
    Enabled = False
    TabOrder = 7
    Visible = False
  end
  object menuMagListView: TPopupMenu
    HelpContext = 999
    OnPopup = menuMagListViewPopup
    Left = 654
    Top = 192
    object mnuOpenImage2: TMenuItem
      Caption = 'Open Image'
      ImageIndex = 10
      OnClick = mnuOpenImage2Click
    end
    object mnuOpenImagein2ndRadiologyWindow2: TMenuItem
      Caption = 'Open Image in 2nd Radiology Window'
      Visible = False
      OnClick = mnuOpenImagein2ndRadiologyWindow1Click
    end
    object mmuImageReport2: TMenuItem
      Caption = 'Image Report'
      ImageIndex = 11
      OnClick = mmuImageReport2Click
    end
    object mnuImageSaveAs2: TMenuItem
      Caption = 'Image Save As...'
      ImageIndex = 12
      Visible = False
    end
    object mnuImageDelete2: TMenuItem
      Caption = 'Image Delete...'
      ImageIndex = 18
      Visible = False
      OnClick = mnuImageDelete2Click
    end
    object mnuIndexEdit2: TMenuItem
      Caption = 'Image Index Edit...'
      Visible = False
      OnClick = mnuIndexEdit2Click
    end
    object mnuImageInformation2: TMenuItem
      Caption = 'Image Information...'
      ImageIndex = 17
      OnClick = mnuImageInformation2Click
    end
    object mnuImageInfoAdv2: TMenuItem
      Caption = 'Image Information Advanced...'
      OnClick = mnuImageInfoAdv2Click
    end
    object mnuCacheGroup2: TMenuItem
      Caption = 'Cache Images'
      OnClick = mnuCacheGroup2Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object SelectColumns2: TMenuItem
      Caption = 'Select Columns...'
      ImageIndex = 14
      OnClick = SelectColumns2Click
    end
    object mnuFitColToText2: TMenuItem
      Caption = 'Fit Columns to Text'
      ImageIndex = 15
      OnClick = mnuFitColToText2Click
    end
    object mnuFitColToWin2: TMenuItem
      Caption = 'Fit Columns to Window'
      ImageIndex = 12
      OnClick = mnuFitColToWin2Click
    end
  end
  object imglstToolbar: TImageList
    Height = 22
    Width = 22
    Left = 624
    Top = 18
    Bitmap = {
      494C010111001300040016001600FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000580000006E00000001002000000000004097
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
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00000000008484840000000000FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
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
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000
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
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00000000007B7B7B007B7B7B0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD0000000000BDBDBD00BDBDBD0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BDBDBD00BDBDBD00BDBDBD00BDBDBD0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000FF000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF00000000000000FF000000FF000000FF00000000000000
      00000000000084848400000000000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF0000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000BDBDBD000000
      0000FF000000FF000000FF0000000000FF00FF000000FF000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000FF000000FF000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000FF000000FF000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000BDBDBD00FFFFFF0000000000FFFFFF00000000000000
      0000000000007B7B7B000000FF000000FF000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484008484
      84008484840084848400FFFFFF0084848400848484008484840084848400FFFF
      FF0084848400848484008484840084848400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000FF000000FF000000FF000000FF0000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
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
      00000000000000000000000000000000000000000000C0C0C000800000008000
      00008080000080800000808000008080000080000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF000000000000000000000000000000FF000000
      84000000FF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF0000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C0008000
      000080000000800000008000000080800000C0C0C00000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000FFFFFF00FFFFFF00000000000000000000000000000000000000FF000000
      84000000FF000000000000848400000000000000000084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000084848400848484008484
      8400000000000000000000000000FFFFFF00FFFFFF0000000000848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000800000008000000080000000808080000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000000000000000FF000000
      84000000FF000084840000848400000000008484840000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      0000800000008000000080000000808080000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF000000000000000000FFFF
      FF00FFFFFF0000000000000000000000000000000000000000000000FF000000
      84000000FF00008484000084840084848400FFFFFF0084848400848484000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      0000800000008000000080000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000000000000000000000000000000000000000FF000000
      84000000FF000084840000000000848484008484840000000000000000008484
      8400FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF000000000084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000800000008000000080000000808080000000000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000FFFFFF00000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF0000000000848484000000000000000000000000008484
      8400000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000800000008000000080000000808080000000000000000000000000000000
      000000000000000000000000000000000000000000008484840000000000FFFF
      FF00000000008484840000000000000000000000000000008400000084000000
      840000008400000084000000000000000000000000000000000084848400FFFF
      FF00848484000000000000000000FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000800000008000000080000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000084840000848400008484000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400000000000000000000000000FFFFFF00FFFFFF008484840084848400FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF008484840084848400FFFFFF00FFFFFF000000
      0000000000000000000000000000FFFFFF000000000084848400848484008484
      8400848484000000000000000000848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000800000008000000080000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008484000084840000848400000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000FFFFFF00848484008484840084848400FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00848484008484840084848400FFFFFF000000
      0000000000000000000000000000FFFFFF0000000000FF000000FF000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      0000800000008000000080000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000848400008484000084840000000000000000000000
      000000000000000000000000000000000000000000008484840084848400FFFF
      FF00FFFFFF000000000000000000848484008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400848484008484840084848400848484000000
      0000000000000000000000000000FFFFFF0000000000FF000000FF000000FF00
      0000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000800000008000
      0000800000008000000080000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000848400008484000000000000000000000000000000
      000000000000000000000000000000000000848484000000000084848400FFFF
      FF00848484000000000000000000FFFFFF00848484008484840084848400FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00848484008484840084848400FFFFFF000000
      0000000000000000000000000000FFFFFF000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000800000008080
      0000808000008000000080000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008484000084840000848400000000000000000000000000000000000000
      000000000000000000000000000084848400FFFFFF0084848400848484008484
      8400FFFFFF000000000000000000FFFFFF00FFFFFF008484840084848400FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF008484840084848400FFFFFF00FFFFFF000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000084840000000000000000000000000000000000848484000000
      0000848484000000000000000000848484008484840084848400848484008484
      8400848484000000000000000000FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000848484000000000000000000000000000000000084848400848484008484
      8400848484000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000FFFFFF000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000808000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400000000000000
      0000000000000000000084848400000000000000000000000000848484000000
      0000848484000000000000000000000000000000000084848400FFFFFF008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FF000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF008000
      0000800000008080800080000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000848400008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FF000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0C0C0008000
      0000800000008000000080000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      0000000000000000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C00000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848484008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF00000000008484840084848400848484008484
      84000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00FFFF
      FF0084848400FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF00000000000000000000000000000000008484
      84008484840000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF008484840084848400FFFFFF00FFFF
      FF008484840084848400FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF00000000008484840084848400848484008484
      84008484840000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00848484008484840084848400FFFFFF00FFFF
      FF00848484008484840084848400FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000848484008484
      84008484840000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF000000000084848400848484008484840084848400848484008484
      84008484840084848400848484008484840000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00848484008484840084848400FFFFFF00FFFF
      FF00848484008484840084848400FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF008484840084848400FFFFFF00FFFF
      FF008484840084848400FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF000000000084848400000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00FFFF
      FF0084848400FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000FFFF0000FFFF00000000000000000000FFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      840000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00000000008484
      84008484840000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000FF000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000000000000000000000848484000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000848484008484840084848400848484000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000008484840084848400848484008484840000000000000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000848484008484840084848400848484000000
      0000000000000000000084848400000000008484840000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000008484840084848400848484008484840000000000000000000000
      0000848484000000000084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000084848400FFFFFF00FFFFFF0084848400848484008484
      8400000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000084848400000000000000
      000084848400FFFFFF00FFFFFF00848484008484840084848400000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000084848400FFFFFF00FFFFFF0084848400848484008484
      8400000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000084848400000000000000
      000084848400FFFFFF00FFFFFF00848484008484840084848400000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF008484
      8400000000000000000000000000000000008484840000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      00008400000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      00000000000000000000000000008484840084848400FFFFFF00FFFFFF000000
      0000000000008484840000000000000000008484840000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      0000000000008484840084848400FFFFFF00FFFFFF0000000000000000008484
      8400000000000000000084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      00008400000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000848484000000000084848400000000000000000000000000848484000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000008400000000000000848484000000
      0000848484000000000000000000000000008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      00008400000084000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      000000000000848484000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00000000008484840000000000000000008484840000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      00008400000084000000840000008400000084000000FFFFFF00000000008484
      8400000000000000000084848400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008400000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008400000084000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008484
      8400000000000000000084000000840000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000840000008400000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000840000008400000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008400000084000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000000000000084848400848484008484
      8400848484000000000000000000000000000000000000000000848484000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000848484000000000000000000840000008400000084848400848484000000
      0000000000000000000000000000000000008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00840000008400000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000848484000000000000000000840000008400000000000000000000000000
      0000000000000000000000000000000000008484840000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000FFFFFF00FFFFFF0000000000000000000000
      0000840000008400000000000000FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000840000008400000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008400000084000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000000000000000000000000000000000
      0000000000000000000000000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000000000000000000000000000000000000000000000000000000000000000
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000840000008400000084000000840000008400000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000840000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      28000000580000006E0000000100010000000000280500000000000000000000
      000000000000000000000000FFFFFF00FFFFFC000000000000000000C0000C00
      0000000000000000C0000C000000000000000000C0000C000000000000000000
      C0000C000000000000000000C0000C000000000000000000C0000C0000000000
      00000000C0000C000000000000000000C0000C000000000000000000C0000C00
      0000000000000000C0000C000000000000000000C0000C000000000000000000
      C0000C000000000000000000C0000C000000000000000000C0000C0000000000
      00000000C0000C000000000000000000C0000C000000000000000000C0000C00
      0000000000000000C0000C000000000000000000C0000C000000000000000000
      C0000C000000000000000000FFFFFC000000000000000000FFFFFFFFFFFF8FFF
      FFFFFF00FFFFFF00003FF7FFFFFFFF00FFFFFF00003FFBFFFFFFFF00FFE01F00
      003FFBFFFFFFFF00FFE01F00003FE7FFFFC1FF00FFE01F00003FF7FFFF087F00
      FFE01F00003FFBFFFA3A3F00E0001F00003FC3FFF87F1F00E0001F00003FFBFF
      F8FF9F00E0001F00003FFBFFF87FCF00E0001F00003FE3FFFFFFCF00E0047F00
      003FEDFFFFFFFF00E0003F00003FEDFFF9FFFF00E0001F00003FFBFFF9FE0F00
      E0047F00003F3BFFFCFF0F00E00C7F00003EB7FFFC7F8F00E0187F00003F0FFF
      FE3E0F00E020FF00003CEFFFFF086F00E07FFF00003F0FFFFFC1FF00FFFFFF00
      003FEFFFFFFFFF00FFFFFF00003FEFFFFFFFFF00FFFFFFFFFFFFEFFFFFFFFF00
      FFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFC0000FF803F00F0C5C7FFFFFC0000
      FFC07F0001C18FFFFFFC0000FFE0FF0003C14FFFFFFC0000FFE0FF0003C01400
      000C0000FFE0FF0063C26400000C0000FFE0FF006382EC00000C0000FFE0FF00
      8303C400000C0000FFE0FF00860F8C00000C0000FFE0FF00FC2FCC00000C0000
      FFE0FF00986F8400000C0000FF80FF0050EF4400000C0000FF80FF0081EE0400
      000C0000FFFFFF0003C60400000C0000FFFFFF0083C78400000C0000FFE1FF00
      81C78400000C0000FFC0FF00907F97FFFFFC0000FFC0FF00FFFFFFFFFFFC0000
      FFE1FF00FFFFFFFFFFFC0000FFF3FF00FFFFFFFFFFFC0000FFFFFF00FFFFFFFF
      FFFFFFFFFFFFFF00FFFFFF80007FE0007FFFFF00FFFFFF80007FE0007FFFFF00
      FFFFFF80007FE0007FFFFF00FFFFFF80007FE0017FFFFF00FFFFFF80007FE001
      7FF1FF0000000380007FE0017FE0FF0000000380007FE0017FF07F0000000380
      007FE0017FE00F0000000380007FE0017FE0E70000000380007FE0017FE00700
      00000380007FE0017F30470000000380007FE0017E1C3F0000000380007FE001
      7E001F0000000380007FE0017F001F0000000380007FE0017F001F0000000380
      007FE0017F801F0000000380007FE0017FC03F00FFFFFF80007FE0017FF07F00
      FFFFFF80007FE0017FFFFF00FFFFFF80007FE0007FFFFF00FFFFFF80007FE000
      7FFFFF00FFFFFF80007FE0007FFFFF00FFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF
      FFFFFFFFFFFFFF00FFFFFFFFFFFF800FFE003F00FE0FFFF83FFF0007FC001F00
      C2101F08407F0007FC001F0084080E10203F0007FC001F0084080610201F0007
      FC001F0080040600101F0007FC001F0080040600101F0007FC001F0080040600
      101F0007C0001F0084080610201F0007C0001F0082100400401F0007CC001F00
      81280400201F0007CC001F0080500400401F0007CC001F00BC8E04F2381F0007
      CC001F00BFFFE4FE7F9F0007CC001F00D1021444085F0007CC001F00E0700C80
      403F000FCC003F00FFB3FCFE4FFF001FCC007F00FFC7FCFE1FFF003FCC00FF00
      FFFFFC007FFFFFFFC003FF00FFFFFC007FFFFFFFC003FF000000000000000000
      0000000000000000000000000000}
  end
  object magImageList1: TMagImageList
    IsGroupList = False
    Port = 0
    Left = 434
    Top = 32
  end
  object fontDlgReport: TPopupMenu
    OnPopup = fontDlgReportPopup
    Left = 720
    Top = 210
    object mnuFont: TMenuItem
      Caption = 'Font'
      OnClick = mnuFontClick
    end
    object mnuRptWordWrap: TMenuItem
      AutoCheck = True
      Caption = 'Word Wrap'
      OnClick = mnuRptWordWrapClick
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 512
    Top = 39
  end
  object MainMenu1: TMainMenu
    Images = ilMain16n
    Left = 278
    Top = 44
    object mnuFile: TMenuItem
      Caption = 'File'
      OnClick = mnuFileClick
      object mnuSelectPatient1: TMenuItem
        Caption = 'Select Patient...'
        ImageIndex = 0
        OnClick = mnuSelectPatient1Click
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object mnuOpenImage1: TMenuItem
        Caption = 'Open Image'
        ImageIndex = 6
        OnClick = mnuOpenImage1Click
      end
      object mnuOpenImagein2ndRadiologyWindow1: TMenuItem
        Caption = 'Open Image in 2nd Radiology Window'
        Visible = False
        OnClick = mnuOpenImagein2ndRadiologyWindow1Click
      end
      object mnuFileImageCopy: TMenuItem
        Caption = 'Image Copy'
        OnClick = mnuFileImageCopyClick
      end
      object mnuFileImagePrint: TMenuItem
        Caption = 'Image Print'
        OnClick = mnuFileImagePrintClick
      end
      object mnuImageReport1: TMenuItem
        Caption = 'Image Report'
        ImageIndex = 10
        OnClick = mnuImageReport1Click
      end
      object mnuImageDelete1: TMenuItem
        Caption = 'Image Delete...'
        ImageIndex = 17
        Visible = False
        OnClick = mnuImageDelete1Click
      end
      object mnuImageIndexEdit1: TMenuItem
        Caption = 'Image Index Edit...'
        OnClick = ImageIndexEdit1Click
      end
      object mnuImageInformation1: TMenuItem
        Caption = 'Image Information...'
        OnClick = mnuImageInformation1Click
      end
      object mnuImageInformationAdvanced1: TMenuItem
        Caption = 'Image Information Advanced...'
        OnClick = mnuImageInformationAdvanced1Click
      end
      object mnuCacheGroup1: TMenuItem
        Caption = 'Cache Images'
        OnClick = mnuCacheGroup1Click
      end
      object mnuNFile1: TMenuItem
        Caption = '-'
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object mnuClose1: TMenuItem
        Caption = 'Close'
        OnClick = mnuClose1Click
      end
      object mnuExit1: TMenuItem
        Caption = 'Exit'
        ImageIndex = 19
        OnClick = mnuExit1Click
      end
    end
    object mnuListContext: TMenuItem
      Caption = 'Context'
      OnClick = mnuListContextClick
      object mnuShowContext1: TMenuItem
        Caption = 'Show Context'
        OnClick = mnuShowContext1Click
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object mnuSuspendContext1: TMenuItem
        Caption = 'Suspend Context'
        OnClick = mnuSuspendContext1Click
      end
      object mnuResumeGetContext1: TMenuItem
        Caption = 'Resume Get Context'
        OnClick = mnuResumeGetContext1Click
      end
      object mnuResumeSetContext1: TMenuItem
        Caption = 'Resume Set Context'
        OnClick = mnuResumeSetContext1Click
      end
    end
    object mnuOptions: TMenuItem
      Caption = 'Options'
      OnClick = mnuOptionsClick
      object mnuRefreshPatientImages: TMenuItem
        Caption = 'Refresh Patient Images'
        ImageIndex = 1
        OnClick = mnuRefreshPatientImagesClick
      end
      object mnuPrefetch1: TMenuItem
        Caption = 'Prefetch Patient Images'
        Enabled = False
        OnClick = mnuPrefetch1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuSyncSelectedImage: TMenuItem
        AutoCheck = True
        Caption = '[force ON] Synchronize Selection'
        Visible = False
        OnClick = mnuSyncSelectedImageClick
      end
      object mnuUserPreferences1: TMenuItem
        Caption = 'User Preferences...'
        object ConfigureUserPreferences1: TMenuItem
          Caption = 'Configure User Preferences...'
          OnClick = ConfigureUserPreferences1Click
        end
        object N25: TMenuItem
          Caption = '-'
        end
        object SaveSettingsNow1: TMenuItem
          Caption = 'Save Settings Now'
          OnClick = SaveSettingsNow1Click
        end
        object mnuSaveSettingsonExit1: TMenuItem
          AutoCheck = True
          Caption = 'Save Settings on Exit'
          OnClick = mnuSaveSettingsonExit1Click
        end
      end
      object RemoteImageViewsConfiguration1: TMenuItem
        Caption = 'Remote Image Views Configuration...'
        OnClick = RemoteImageViewsConfiguration1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mnuShowHints1: TMenuItem
        Caption = 'Show Hints'
        OnClick = mnuShowHints1Click
        object ShowHintsonThiswindow1: TMenuItem
          AutoCheck = True
          Caption = 'Show Hints on This window'
          OnClick = ShowHintsonThiswindow1Click
        end
        object N23: TMenuItem
          Caption = '-'
        end
        object HintsOFFforallwindows1: TMenuItem
          Caption = 'Hints OFF for all windows'
          OnClick = HintsOFFforallwindows1Click
        end
        object HintsONforallwindows1: TMenuItem
          Caption = 'Hints ON for all windows'
          OnClick = HintsONforallwindows1Click
        end
      end
      object N24: TMenuItem
        Caption = '-'
      end
      object mnuBrowseImageList: TMenuItem
        AutoCheck = True
        Caption = 'Browse Image List'
        OnClick = mnuBrowseImageListClick
      end
      object mnuCPRSSyncOptions1: TMenuItem
        Caption = 'CPRS Sync Options...'
        Enabled = False
        OnClick = mnuCPRSSyncOptions1Click
      end
      object mnuStayonTop1: TMenuItem
        Caption = 'Stay on Top'
        Visible = False
        OnClick = mnuStayonTop1Click
      end
      object mnuIconShortCutKeyLegend1: TMenuItem
        Caption = 'Shortcut Key legend...'
        OnClick = mnuIconShortCutKeyLegend1Click
      end
      object mnuMessageLog: TMenuItem
        Caption = 'Message Log...'
        OnClick = mnuMessageLogClick
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      OnClick = View1Click
      object mnuMUSEEKGlistIL: TMenuItem
        Caption = 'MUSE EKG Window...'
        Enabled = False
        OnClick = mnuMUSEEKGlistILClick
      end
      object mnuGroupWindow1: TMenuItem
        Caption = 'Group Window...'
        Enabled = False
        OnClick = mnuGroupWindow1Click
      end
      object N11: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuRadiologyExams1: TMenuItem
        Caption = 'Radiology Exams...'
        OnClick = mnuRadiologyExams1Click
      end
      object mnuMedicineProcedures1: TMenuItem
        Caption = 'Medicine Procedures...'
        Visible = False
      end
      object mnuLabExams1: TMenuItem
        Caption = 'Lab Exams...'
        Visible = False
      end
      object mnuSurgicalOperations1: TMenuItem
        Caption = 'Surgical Operations...'
        Visible = False
      end
      object mnuProgressNotes1: TMenuItem
        Caption = 'Progress Notes...'
        OnClick = mnuProgressNotes1Click
      end
      object mnuClinicalProcedures1: TMenuItem
        Caption = 'Clinical Procedures...'
        Enabled = False
        Visible = False
        OnClick = mnuClinicalProcedures1Click
      end
      object mnuConsults1: TMenuItem
        Caption = 'Consults'
        Enabled = False
        Visible = False
        OnClick = mnuConsults1Click
      end
      object N12: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuToolbars: TMenuItem
        Caption = 'Toolbars'
        OnClick = mnuToolbarsClick
        object mnuListToolbarList: TMenuItem
          AutoCheck = True
          Caption = 'Main Toolbar'
          Checked = True
          ShortCut = 16468
          OnClick = mnuListToolbarListClick
        end
        object MainToolbarinTree1: TMenuItem
          AutoCheck = True
          Caption = 'Main Toolbar in Tree'
          OnClick = MainToolbarinTree1Click
        end
        object mnuImageToolbar: TMenuItem
          AutoCheck = True
          Caption = 'Image Toolbar'
          Checked = True
          OnClick = mnuImageToolbarClick
        end
        object mnuVTtreesortbuttons: TMenuItem
          AutoCheck = True
          Caption = 'Tree Sort Buttons'
          Checked = True
          OnClick = mnuVTtreesortbuttonsClick
        end
        object mnuVTFilterTabs: TMenuItem
          AutoCheck = True
          Caption = 'Filter Buttons'
          Checked = True
          OnClick = mnuVTFilterTabsClick
        end
        object mnuRemoteConnections1: TMenuItem
          AutoCheck = True
          Caption = 'Remote Connections '
          Checked = True
          OnClick = mnuRemoteConnections1Click
        end
      end
      object ActiveForms1: TMenuItem
        Caption = 'Active windows...'
        ShortCut = 16471
        OnClick = ActiveForms1Click
      end
      object ShortCutMenu1: TMenuItem
        Caption = 'ShortCut Menu'
        ShortCut = 49229
        Visible = False
        OnClick = ShortCutMenu1Click
      end
      object GotoMainWindow1: TMenuItem
        Caption = 'Go to Main Window'
        ShortCut = 16461
        OnClick = GotoMainWindow1Click
      end
    end
    object mnuReports1: TMenuItem
      Caption = 'Reports'
      OnClick = mnuReports1Click
      object mnuPatientProfile1: TMenuItem
        Caption = 'Patient Profile'
        OnClick = mnuPatientProfile1Click
      end
      object mnuHealthSummary1: TMenuItem
        Caption = 'Health Summary'
        OnClick = mnuHealthSummary1Click
      end
      object mnuDischargeSummary1: TMenuItem
        Caption = 'Discharge Summary'
        OnClick = mnuDischargeSummary1Click
      end
      object mnuNReports1: TMenuItem
        Caption = '-'
      end
    end
    object mnuFilters: TMenuItem
      Caption = 'Fil&ters'
      object ImageFilter1: TMenuItem
        Caption = 'Image List Filters...'
        ImageIndex = 5
        ShortCut = 16460
        OnClick = ImageFilter1Click
      end
      object FilterDetails1: TMenuItem
        Caption = 'Filter Details...'
        OnClick = FilterDetails1Click
      end
      object mnuRefreshFilterlist: TMenuItem
        Caption = 'Refresh Filter list'
        ImageIndex = 16
        OnClick = mnuRefreshFilterlistClick
      end
      object mnuFiltersasTabs1: TMenuItem
        AutoCheck = True
        Caption = 'Filters as Buttons'
        Checked = True
        OnClick = mnuFiltersasTabs1Click
      end
      object mnuMultiLineTabs1: TMenuItem
        AutoCheck = True
        Caption = 'Multi-Line Tabs'
        OnClick = mnuMultiLineTabs1Click
      end
      object mnuShowDeletedImageInformation: TMenuItem
        AutoCheck = True
        Caption = 'Include Deleted Image Placeholder'
        OnClick = mnuShowDeletedImageInformationClick
      end
      object mnuNFilter1: TMenuItem
        Caption = '-'
      end
      object mnuNFilter2: TMenuItem
        Caption = '-'
      end
    end
    object mnuLayouts: TMenuItem
      Caption = '&Layouts'
      OnClick = mnuLayoutsClick
      object mnuThumbnails1: TMenuItem
        Caption = '&Abstracts'
        OnClick = mnuThumbnails1Click
        object mnuShowThumbNail: TMenuItem
          AutoCheck = True
          Caption = '&Show Abstracts'
          OnClick = mnuShowThumbNailClick
        end
        object N22: TMenuItem
          Caption = '-'
        end
        object mnuThumbsBottom2: TMenuItem
          AutoCheck = True
          Caption = 'Abstracts &Bottom'
          OnClick = mnuThumbsBottom2Click
        end
        object mnuThumbsLeft2: TMenuItem
          AutoCheck = True
          Caption = 'Abstracts &Left'
          OnClick = mnuThumbsLeft2Click
        end
        object mnuThumbsBottomTree2: TMenuItem
          AutoCheck = True
          Caption = 'Abstracts Bottom &Tree'
          OnClick = mnuThumbsBottomTree2Click
        end
        object mnuThumbNailWindow: TMenuItem
          AutoCheck = True
          Caption = 'Abstract Viewer in Separate &Window'
          OnClick = mnuThumbNailWindowClick
        end
        object N20: TMenuItem
          Caption = '-'
        end
        object mnuThumbsRefresh2: TMenuItem
          Caption = '&Refresh'
          ImageIndex = 16
          OnClick = mnuThumbsRefresh2Click
        end
        object N21: TMenuItem
          Caption = '-'
        end
      end
      object mnuTree: TMenuItem
        Caption = '&Tree view'
        OnClick = mnuTreeClick
        object mnuShowTree: TMenuItem
          AutoCheck = True
          Caption = 'Show Tree View'
          OnClick = mnuShowTreeClick
        end
        object N16: TMenuItem
          Caption = '-'
        end
        object mnuTreeTabs1: TMenuItem
          AutoCheck = True
          Caption = 'Sort Buttons'
          Checked = True
          OnClick = mnuTreeTabs1Click
        end
        object mnuAutoExpandCollapse: TMenuItem
          AutoCheck = True
          Caption = 'Auto Expand/Collapse'
          OnClick = mnuAutoExpandCollapseClick
        end
        object N15: TMenuItem
          Caption = '-'
        end
        object mnuTreeSpecEvent: TMenuItem
          Caption = 'Specialty - Event'
          OnClick = mnuTreeSpecEventClick
        end
        object mnuTreeTypeSpec: TMenuItem
          Caption = 'Type - Specialty'
          OnClick = mnuTreeTypeSpecClick
        end
        object mnuTreePkgType: TMenuItem
          Caption = 'Package - Type'
          OnClick = mnuTreePkgTypeClick
        end
        object mnuTreeCustom: TMenuItem
          Caption = 'Custom...'
          OnClick = mnuTreeCustomClick
        end
        object N17: TMenuItem
          Caption = '-'
        end
        object mnuExpandAll: TMenuItem
          Caption = 'Expand All'
          ImageIndex = 18
          OnClick = mnuExpandAllClick
        end
        object mnuExpand1Level: TMenuItem
          Caption = 'Expand 1 level'
          OnClick = mnuExpand1LevelClick
        end
        object mnuCollapseAll: TMenuItem
          Caption = 'Collapse All'
          OnClick = mnuCollapseAllClick
        end
        object mnuAlphaSort: TMenuItem
          Caption = 'Alpha Sort'
          Visible = False
          OnClick = mnuAlphaSortClick
        end
        object N14: TMenuItem
          Caption = '-'
        end
        object mnuTreeRefresh1: TMenuItem
          Caption = 'Refresh'
          ImageIndex = 16
          OnClick = mnuTreeRefresh1Click
        end
      end
      object mnuList: TMenuItem
        Caption = '&List view'
        OnClick = mnuListClick
        object mnuShowList: TMenuItem
          AutoCheck = True
          Caption = 'Show Image List'
          Checked = True
          OnClick = mnuShowListClick
        end
        object N18: TMenuItem
          Caption = '-'
        end
        object mnuSelectColumns: TMenuItem
          Caption = 'Select Columns...'
          ImageIndex = 3
          OnClick = mnuSelectColumnsClick
        end
        object mnuSelectColumnSet: TMenuItem
          Caption = '[not 93] Select Column set...'
          Visible = False
          OnClick = mnuSelectColumnSetClick
        end
        object mnuSaveColumnSet: TMenuItem
          Caption = '[not 93] Save Column set'
          Visible = False
          OnClick = mnuSaveColumnSetClick
        end
        object N27: TMenuItem
          Caption = '-'
        end
        object mnuFitColToText: TMenuItem
          Caption = 'Fit to Text'
          ImageIndex = 2
          OnClick = mnuFitColToTextClick
        end
        object mnuFitColToWin: TMenuItem
          Caption = 'Fit to Window'
          ImageIndex = 4
          OnClick = mnuFitColToWinClick
        end
        object N19: TMenuItem
          Caption = '-'
        end
        object mnuShowGrid: TMenuItem
          AutoCheck = True
          Caption = 'Show Grid'
          Checked = True
          OnClick = mnuShowGridClick
        end
        object mnuPreviewAbstract: TMenuItem
          AutoCheck = True
          Caption = 'Preview Abstract'
          ImageIndex = 7
          OnClick = mnuPreviewAbstractClick
        end
        object mnuPreviewReport: TMenuItem
          AutoCheck = True
          Caption = 'Preview Report'
          ImageIndex = 8
          OnClick = mnuPreviewReportClick
        end
        object N31: TMenuItem
          Caption = '-'
        end
        object mnuListRefresh: TMenuItem
          Caption = 'Refresh'
          OnClick = mnuListRefreshClick
        end
      end
      object N30: TMenuItem
        Caption = '-'
      end
      object ExplorerStyle1: TMenuItem
        Caption = 'Explorer Style'
        OnClick = ExplorerStyle1Click
      end
      object TreeList1: TMenuItem
        Caption = 'Explorer with List'
        OnClick = TreeList1Click
      end
      object TreeAbs1: TMenuItem
        Caption = 'Explorer with Abstracts'
        OnClick = TreeAbs1Click
      end
      object Filmstrip1: TMenuItem
        Caption = 'Abstract strip'
        OnClick = Filmstrip1Click
      end
      object mnuFilmStripLeft: TMenuItem
        Caption = 'Abstract strip left'
        OnClick = mnuFilmStripLeftClick
      end
      object AbsList1: TMenuItem
        Caption = 'Abstract strip with List'
        OnClick = AbsList1Click
      end
      object ListwithPreviews1: TMenuItem
        Caption = 'List with Previews'
        OnClick = ListwithPreviews1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object mnuFullImageViewerWindow: TMenuItem
        AutoCheck = True
        Caption = 'Document Viewer in Separate window'
        Checked = True
        OnClick = mnuFullImageViewerWindowClick
      end
      object N36: TMenuItem
        Caption = '-'
      end
      object colorcontrol1: TMenuItem
        Caption = '&Set Active Control'
        object mnuFocusAbs: TMenuItem
          Caption = '&Abstract'
          ShortCut = 16500
          OnClick = mnuFocusAbsClick
        end
        object mnuFocusTree: TMenuItem
          Caption = '&Tree View'
          ShortCut = 16501
          OnClick = mnuFocusTreeClick
        end
        object mnuFocusList: TMenuItem
          Caption = '&List View'
          ShortCut = 16502
          OnClick = mnuFocusListClick
        end
        object mnuFocusFull: TMenuItem
          Caption = '&Full Resolution Viewer'
          ShortCut = 16503
          OnClick = mnuFocusFullClick
        end
        object mnuFocusShow: TMenuItem
          Caption = '<hidden> Show Focus Control'
          ShortCut = 16454
          Visible = False
          OnClick = mnuFocusShowClick
        end
        object N3: TMenuItem
          Caption = '-'
        end
        object mnuFocusBar: TMenuItem
          AutoCheck = True
          Caption = 'Active &Control Indicator'
          OnClick = mnuFocusBarClick
        end
      end
    end
    object mnuUtilities: TMenuItem
      Caption = '&Utilities'
      OnClick = mnuUtilitiesClick
      object mnuListQAReview: TMenuItem
        Caption = '&QA Review...'
        OnClick = mnuListQAReviewClick
      end
      object mnuListQAReviewReport: TMenuItem
        Caption = 'QA Review &Report...'
        OnClick = mnuListQAReviewReportClick
      end
      object mnuIndexEdit: TMenuItem
        Caption = '&Edit Index fields...'
        OnClick = mnuIndexEditClick
      end
      object N37: TMenuItem
        Caption = '-'
      end
      object mnuROIPrintOptions: TMenuItem
        Caption = 'ROI Print options'
        Hint = 'Enable Release of Information Print Options'
        OnClick = mnuROIPrintOptionsClick
        object Printalllistedimages1: TMenuItem
          Caption = 'Print all listed images...'
          OnClick = Printalllistedimages1Click
        end
        object mnuROISelectImagestoPrint: TMenuItem
          AutoCheck = True
          Caption = 'Choose Images to Print'
          OnClick = mnuROISelectImagestoPrintClick
        end
      end
      object N32: TMenuItem
        Caption = '-'
      end
      object mnuSetImageStatus: TMenuItem
        Caption = 'Image &Status ()'
        OnClick = mnuSetImageStatusClick
        object mnuSetImageStatusViewable: TMenuItem
          Caption = '=> &Viewable'
          ImageIndex = 21
          OnClick = mnuSetImageStatusViewableClick
        end
        object mnuSetImageStatusQAReviewed: TMenuItem
          Caption = '=> &QA Reviewed'
          ImageIndex = 22
          OnClick = mnuSetImageStatusQAReviewedClick
        end
        object mnuSetImageStatusNeedsReview: TMenuItem
          Caption = '=> &Needs Review.  (block from view)'
          ImageIndex = 31
          OnClick = mnuSetImageStatusNeedsReviewClick
        end
      end
      object mnuSetControlledImage: TMenuItem
        Caption = '&Controlled Image ()'
        OnClick = mnuSetControlledImageClick
        object mnuSetControlledImageFalse: TMenuItem
          Caption = '=> &False. (Normal display)'
          ImageIndex = 21
          OnClick = mnuSetControlledImageFalseClick
        end
        object mnuSetControlledImageTrue: TMenuItem
          Caption = '=> &True.  (Controlled display)'
          ImageIndex = 27
          OnClick = mnuSetControlledImageTrueClick
        end
      end
    end
    object mnuManager: TMenuItem
      Caption = 'Manager'
      OnClick = mnuManagerClick
      object mnuWorkstationConfigurationwindow1: TMenuItem
        Caption = 'Workstation Configuration window...'
        OnClick = mnuWorkstationConfigurationwindow1Click
      end
      object mnuClearCurrentPatient1: TMenuItem
        Caption = 'Clear Current Patient'
        OnClick = mnuClearCurrentPatient1Click
      end
      object mnuImageFileNetSecurityON1: TMenuItem
        AutoCheck = True
        Caption = 'Image File NetSecurity ON'
        Checked = True
        OnClick = mnuImageFileNetSecurityON1Click
      end
      object mnuShowMessagesfromlastOpenSecureFileCall1: TMenuItem
        Caption = 'Show Messages from last OpenSecureFile Call'
        OnClick = mnuShowMessagesfromlastOpenSecureFileCall1Click
      end
      object mnuChangeTimeoutvalue1: TMenuItem
        Caption = 'Change Timeout value'
        OnClick = mnuChangeTimeoutvalue1Click
      end
      object mnuPatientLookupLoginEnabled1: TMenuItem
        AutoCheck = True
        Caption = 'Patient Lookup/Login Enabled'
        Checked = True
        OnClick = mnuPatientLookupLoginEnabled1Click
      end
      object mnuSetWorkstationsAlternateVideoViewer1: TMenuItem
        Caption = 'Set Workstation'#39's Alternate Video Viewer'
        OnClick = mnuSetWorkstationsAlternateVideoViewer1Click
      end
      object NextControl1: TMenuItem
        Caption = 'Next Control'
        Visible = False
        OnClick = NextControl1Click
      end
    end
    object mnuImage1: TMenuItem
      Caption = '<&Image>'
      Visible = False
      object PagingControls1: TMenuItem
        Caption = 'Paging Controls...'
        Visible = False
      end
      object ZoomBrightnessContrast1: TMenuItem
        Caption = 'Zoom, Brightness, Contrast...'
        Visible = False
      end
      object FocusNextControl1: TMenuItem
        Caption = 'Focus Next Control'
        ShortCut = 16454
        OnClick = FocusNextControl1Click
      end
      object N9: TMenuItem
        Caption = '-'
        Visible = False
      end
      object mnuApplytoAll1: TMenuItem
        Caption = 'Apply to All'
      end
      object mnuZoom1: TMenuItem
        Caption = 'Zoom'
        object ZoomIn1: TMenuItem
          Caption = 'Zoom In'
          ShortCut = 24649
        end
        object ZoomOut1: TMenuItem
          Caption = 'Zoom Out'
          ShortCut = 24655
        end
        object mnuFittoWidht1: TMenuItem
          Caption = 'Fit to Width'
          ImageIndex = 24
          ShortCut = 24663
        end
        object mnuFittoHeight1: TMenuItem
          Caption = 'Fit to Height'
          ImageIndex = 23
        end
        object mnuFittoWindow1: TMenuItem
          Caption = 'Fit to Window'
          ImageIndex = 22
        end
        object mnuActualSize1: TMenuItem
          Caption = 'Actual Size'
          ImageIndex = 29
          ShortCut = 24641
        end
      end
      object mnuMouse1: TMenuItem
        Caption = 'Mouse'
        object mnuPan1: TMenuItem
          Caption = 'Pan'
          ImageIndex = 7
        end
        object mnuMagnify1: TMenuItem
          Caption = 'Magnify'
          ImageIndex = 9
        end
        object mnuSelect1: TMenuItem
          Caption = 'Zoom'
          ImageIndex = 8
        end
        object mnuPointer1: TMenuItem
          Caption = 'Pointer'
          ImageIndex = 40
        end
      end
      object mnuRotate1: TMenuItem
        Caption = 'Rotate'
        object Rightclockwise1: TMenuItem
          Caption = 'Right'
          Hint = 'Rotate +90 (clockwise)'
          ImageIndex = 26
          ShortCut = 24658
        end
        object Left1: TMenuItem
          Caption = 'Left'
          Hint = 'Rotate -90 (counter-clockwise) '
          ImageIndex = 25
        end
        object N33: TMenuItem
          Caption = '180'
          ImageIndex = 27
        end
        object mnuFlipHoriz1: TMenuItem
          Caption = 'Flip Horizontal'
          ImageIndex = 31
        end
        object mnuFlipVertical1: TMenuItem
          Caption = 'Flip Vertical'
          ImageIndex = 32
        end
      end
      object mnuConBri1: TMenuItem
        Caption = 'Contrast/Brightness'
        object mnuContrastP1: TMenuItem
          Caption = 'Contrast +'
        end
        object mnuContrastM1: TMenuItem
          Caption = 'Contrast -'
        end
        object mnuBrightnessP1: TMenuItem
          Caption = 'Brightness +'
        end
        object mnuBrightnessM1: TMenuItem
          Caption = 'Brightness -'
        end
      end
      object mnuInvert1: TMenuItem
        Caption = 'Invert'
      end
      object mnuReset1: TMenuItem
        Caption = 'Reset'
        ShortCut = 24659
      end
      object mnuScroll1: TMenuItem
        Caption = 'Scroll'
        object mnuScrollToCornerTL1: TMenuItem
          Caption = 'Top Left'
        end
        object mnuScrollToCornerTR1: TMenuItem
          Caption = 'Top Right'
        end
        object mnuScrollToCornerBL1: TMenuItem
          Caption = 'Bottom Left'
        end
        object mnuScrollToCornerBR1: TMenuItem
          Caption = 'Bottom Right'
        end
        object mnuScrollLeft1: TMenuItem
          Caption = 'Left'
        end
        object mnuScrollRight1: TMenuItem
          Caption = 'Right'
        end
        object mnuScrollUp1: TMenuItem
          Caption = 'Up'
        end
        object mnuScrollDown1: TMenuItem
          Caption = 'Down'
        end
      end
      object mnuMaximize1: TMenuItem
        Caption = 'Maximize Image'
      end
      object DeSkewSmooth1: TMenuItem
        Caption = '<hidden> DeSkew && Smooth'
        Visible = False
      end
      object N35: TMenuItem
        Caption = '-'
      end
      object PreviousImage1: TMenuItem
        Caption = 'Previous Image'
        ShortCut = 16464
      end
      object NextImage1: TMenuItem
        Caption = 'Next Image'
        ShortCut = 16462
      end
    end
    object mnuHelp: TMenuItem
      Caption = 'Help'
      object ImageListingwindow1: TMenuItem
        Caption = 'Image Listing window...'
        ImageIndex = 20
        OnClick = ImageListingwindow1Click
      end
      object mnuListHelpWhatNew93: TMenuItem
        Caption = 'What'#39's new in Patch 93'
        OnClick = mnuListHelpWhatNew93Click
      end
      object mnuNHelp1: TMenuItem
        Caption = '-'
      end
      object mnuListAbout: TMenuItem
        Caption = 'About...'
        OnClick = mnuListAboutClick
      end
    end
    object mnuTesting: TMenuItem
      Caption = 'Testing'
      Visible = False
      object estingAddImagetoViewer1: TMenuItem
        Caption = 'Testing : Add Image to Viewer'
        OnClick = estingAddImagetoViewer1Click
      end
      object mnuROI: TMenuItem
        Caption = 'Release of Information'
        Visible = False
      end
      object mnuMultiLine: TMenuItem
        Caption = 'Enable Multi Image Index Edit'
        OnClick = mnuMultiLineClick
      end
      object mnuOpenImageID: TMenuItem
        Caption = 'Open Image ID#...'
        OnClick = mnuOpenImageIDClick
      end
      object UpreftoImageListWin1: TMenuItem
        Caption = 'Upref to Image List Win'
        OnClick = UpreftoImageListWin1Click
      end
      object dimensions1: TMenuItem
        Caption = 'dimensions'
        OnClick = dimensions1Click
        object mnuCurrentSettings: TMenuItem
          Caption = 'cURRENT'
        end
        object mnuD: TMenuItem
          Caption = 'set to :  1024 x 768'
          OnClick = mnuDClick
        end
        object setto1280x10241: TMenuItem
          Caption = 'set to 1280 x 1024'
          OnClick = setto1280x10241Click
        end
      end
      object Color1: TMenuItem
        Caption = 'Color'
        OnClick = Color1Click
      end
      object GetZoomLevelOfSelectedImage1: TMenuItem
        Caption = 'GetZoomLevelOfSelectedImage'
      end
      object empTestAbs1: TMenuItem
        Caption = 'TempTestAbs'
        object enableAbsButton1: TMenuItem
          Caption = 'enable Abs Button'
          OnClick = enableAbsButton1Click
        end
        object DisableAbsButton1: TMenuItem
          Caption = 'Disable Abs Button'
          OnClick = DisableAbsButton1Click
        end
        object mnuTESTAbsButtonDown1: TMenuItem
          Caption = 'Abs Button Down'
          OnClick = mnuTESTAbsButtonDown1Click
        end
        object mnuTESTAbsButtonUp1: TMenuItem
          Caption = 'Abs Button Up'
          OnClick = mnuTESTAbsButtonUp1Click
        end
        object mnuTESTShowAbschecked1: TMenuItem
          Caption = 'Show Abs checked'
          OnClick = mnuTESTShowAbschecked1Click
        end
        object mnuTESTShowAbsNotChecked1: TMenuItem
          Caption = 'Show Abs Not Checked'
          OnClick = mnuTESTShowAbsNotChecked1Click
        end
      end
      object mnuTestSyncAll: TMenuItem
        Caption = 'Sync All'
        OnClick = mnuTestSyncAllClick
      end
      object mnuTestsetcoolbandBreak: TMenuItem
        Caption = 'coolband break'
        OnClick = mnuTestsetcoolbandBreakClick
      end
      object mnuTestFixFullRespanel: TMenuItem
        Caption = 'Fix Full Res panel'
        OnClick = mnuTestFixFullRespanelClick
      end
      object mnuOpenGroupThumbnailPreview: TMenuItem
        AutoCheck = True
        Caption = 'Use Group Abstract Preview window'
        Checked = True
        Enabled = False
        Visible = False
        OnClick = mnuOpenGroupThumbnailPreviewClick
      end
    end
    object NCATTesting1: TMenuItem
      Caption = 'DoD-Testing'
      Visible = False
      object mnu_ShowUrlMap: TMenuItem
        Caption = 'Show URL Mapping'
        OnClick = mnu_ShowUrlMapClick
      end
    end
  end
  object MagMenuPublic: TMag4Menu
    MenuBarItem = mnuFilters
    InsertAfterItem = mnuNFilter2
    OnNewItemClick = MagMenuFilterClick
    MaxInsert = 20
    ExitItem = False
    Left = 352
    Top = 48
  end
  object MagMenuPrivate: TMag4Menu
    MenuBarItem = mnuFilters
    InsertAfterItem = mnuNFilter1
    OnNewItemClick = MagMenuFilterClick
    MaxInsert = 20
    ExitItem = False
    Left = 258
    Top = 102
  end
  object FilterTabPopup: TPopupMenu
    OnPopup = FilterTabPopupPopup
    Left = 696
    Top = 31
    object mnuImageListFilters2: TMenuItem
      Caption = 'Image List Filters'
      OnClick = mnuImageListFilters2Click
    end
    object mnuFilterInfo2: TMenuItem
      Caption = 'Filter Details...'
      OnClick = mnuFilterInfo2Click
    end
    object mnuRefreshFilterList2: TMenuItem
      Caption = 'Refresh Filter List'
      OnClick = mnuRefreshFilterList2Click
    end
    object mnuFiltersasTabs2: TMenuItem
      AutoCheck = True
      Caption = 'Filters as Tabs'
      OnClick = mnuFiltersasTabs2Click
    end
    object mnuMultiLineTabs2: TMenuItem
      Caption = 'Multi-Line Tabs'
      OnClick = mnuMultiLineTabs2Click
    end
  end
  object timerSyncTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = timerSyncTimerTimer
    Left = 239
    Top = 358
  end
  object ilMain24n: TImageList
    Height = 24
    Width = 24
    Left = 932
    Top = 332
    Bitmap = {
      494C01010F001300040018001800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000600000006000000001002000000000000090
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
      0000000000000000000000000000000000009B3B0A009B3B0A009B3B0A009B3B
      0A009B3B0A009B3B0A0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006B410700653F
      12006D431E0065411F006D431E00653F12006B41070000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009B3B0A00F4D19F00FBEDC600ECB9
      7A00C7854600993B0D0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000613B0600855F5200C097
      9700C0979700C0979700C0979700C0979700855F5200613B0600000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009B3B0A00F3D19D00FBEDC700ECBA
      7D00C7854800993B0D0000000000000000000A0A9A0000000000000000000000
      0000000000000000000000000000000000000000000084593C00C0999900CCB9
      B900DDCDCD00DDD9D900DDCDCD00CCB9B900C099990084593C00000000000000
      00000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009B3B0A00F3D09C00FCEEC800EDBC
      7F00C8874A00993B0D00000000000A0A9A003B0AB9000A0A9A00000000000000
      000000000000000000000000000000000000000000009B694200C08F8F00CC93
      9300D6B0B000DFDEDE00D6B0B000CC939300C08F8F009B694200000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000000000000000000000000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009B3B0A00F2CF9A00FCEEC900EDBD
      8100C8874C00993B0D000A0A9A000A2DE2000A2DE1003B0AB9000A0A9A000000
      000000000000000000000000000000000000000000007F4D0800965F5200CC6E
      6E00D0979700D9C5C500D0979700CC6E6E00965F52007F4D0800BB710B000000
      000000000000000000000000FF00000000000000000000000000000000000000
      FF0000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000FF000000FF000000FF000000
      000000000000000000000000FF000000FF00000000000000FF000000FF000000
      FF0000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009B3B0A00F2CD9900FCEFCA00EEBF
      8300C8884D000A0A9A000A2DE2000A2EE3000A2EE2000A2DE1003B0AB9000A0A
      9A000000000000000000000000000000000000000000000000006D3A2400CB79
      7900CD848400CD848400CD848400CB7979006D3A240055330600845008000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF00000000000000FF0000000000000000000000FF000000
      000000000000000000000000FF00000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009B3B0A00F2CD9800FCEFC900EFBF
      86000A0A9A000A2DE2000A2FE4000A2FE4000A2EE3000A2EE2000A2DE1003B0A
      B9000A0A9A0000000000000000000000000000000000F6B35400F6B35400F6B3
      5400F6B35400FFB33400FFB33400F6B35400F6B35400CB797900683F07000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000000000000000000000000000FF000000
      FF0000000000000000000000FF00000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009B3B0A00EFC18800FBE4BB000A0A
      9A000A2DE2000A31E7000A30E6000A30E5000A2FE4000A2EE3000A2EE2000A2D
      E1003B0AB9000A0A9A00000000000000000000000000C6B69300FF000000FF00
      0000FF000000FF000000FF000000FF00000000800000CB797900683F07000000
      0000000000006B410700653F12006D431E0065411F006D431E00653F12006B41
      0700935909000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BB9F90009B3B0A009B3B0A000A0A9A0073A6
      FB0073A6FB0073A6FB0073A6FB000A31E7000A30E5000A2FE4003B0AB9003B0A
      B9003B0AB9003B0AB9000A0A9A000000000000000000C6B69300FFFF0000FFFF
      FF00FFFF0000FFFFFF00008000000080000000800000CB797900683F07000000
      0000613B0600855F5200C0979700C0979700C0979700C0979700C0979700855F
      5200613B0600A7650A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C7C4C300A24F2300D9A06C000A0A9A000A0A9A000A0A
      9A000A0A9A000A0A9A0073A6FB000A31E8000A31E7000A30E6003B0AB9000A0A
      9A000A0A9A000A0A9A000A0A9A000A0A9A0000000000C6B69300FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF000000800000CB797900683F07000000
      000084593C00C0999900CCB9B900DDCDCD00DDD9D900DDCDCD00CCB9B900C099
      990084593C00A6650A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000B17E6300B2643300F5D09D00F8D9AC00FCE0B400F9D9
      AA00ECC596000A0A9A0073A6FB000A32EA000A32E9000A31E7003B0AB9000A0A
      9A000000000000000000000000000000000000000000C6B69300FFFF0000C0C0
      C000C0C0C000FFFFFF00FFFF0000FFFFFF00FFFF0000CB797900683F07000000
      00009B694200C08F8F00CC939300D6B0B000DFDEDE00D6B0B000CC939300C08F
      8F009B694200C4760C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C2B4AD009F441400E5B47E00F7D8AC00F9DDB100FBDEB100F7D5
      A500F3CC97000A0A9A0073A6FB000A33EC000A32EA000A32E9003B0AB9000A0A
      9A000000000000000000000000000000000000000000C6B69300C0C0C000FFFF
      FF0000FFFF00C0C0C000FFFFFF00FFFF0000FFFFFF00CB797900683F07000000
      00007F4D0800965F5200CC6E6E00D0979700D9C5C500D0979700CC6E6E00965F
      52007F4D0800BB710B00E1880D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A9644100C7835000F4CD9A00F8DFBB00FBE0B400FADBAC00F7D2
      A000F3C993000A0A9A0073A6FB000A34ED000A33EC000A33EB003B0AB9000A0A
      9A000000000000000000000000000000000000000000C6B69300C0C0C00000FF
      FF00FFFFFF00C0C0C000FFFF0000FFFFFF00FFFF0000CB797900683F07000000
      0000000000006D3A2400CB797900CD848400CD848400CD848400CB7979006D3A
      24005533060084500800CB7B0C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000BB9F9000A54E2000EFC38B00F7D8AF00F9E4C400FCE1B500F8D8A800F5CF
      9B00F1C68E000A0A9A0073A6FB000A35EF000A34ED000A34EC003B0AB9000A0A
      9A000000000000000000000000000000000000000000C6B69300FFFFFF00C0C0
      C000C0C0C000FFFF0000FFFFFF00FFFF0000FFFFFF00CB797900895309000000
      0000F6B35400F6B35400F6B35400F6B35400FFB33400FFB33400F6B35400F6B3
      5400CB797900683F0700C0740C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C7C4
      C300A24E2300D5986200F3CA9600F9E4C700FAE5C500FBDEB000F7D4A300F4CC
      9700F0C289000A0A9A0073A6FB0073A6FB0073A6FB0073A6FB0073A6FB000A0A
      9A000000000000000000000000000000000000000000CFA68900CFA68900CFA6
      8900CFA68900CFA68900CFA68900CFA68900CFA68900CB797900CB7B0C000000
      0000C6B69300FF000000FF000000FF000000FF000000FF000000FF0000000080
      0000CB797900683F0700C0740C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B181
      6800B0623300F0C38A00F6D7AF00FAEAD200FBE5C400F9DAAC00F6D19E00F2C8
      9100EEBF85000A0A9A000A0A9A000A0A9A000A0A9A000A0A9A000A0A9A000A0A
      9A00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6B69300FFFF0000FFFFFF00FFFF0000FFFFFF0000800000008000000080
      0000CB797900683F0700C0740C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C2B4AD009D42
      1200E3AC7100F2C68F00F9E7CF00FAEEDA00FCE4BF00F8D7A700F5CE9900F1C5
      8D00EDBC8000E9B37300E0A46300C6895200AE7145009D5B3500A24B1F00C7C4
      C300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6B69300FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF00000080
      0000CB797900683F0700C0740C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A9644100C27E
      4E00EFC08700F5D4AA00FAF0E100FBF2E200FADEB200F7D3A200F3CB9500F0C1
      8800ECB97B00E8AF6E00E4A76100CE8D4F00B57542009E613B009E4D2200B385
      6D00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6B69300FFFF0000C0C0C000C0C0C000FFFFFF00FFFF0000FFFFFF00FFFF
      0000CB797900683F0700C0740C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BB9F9000A44D2100EBB9
      7C00F1C48B00F8E7D000FBF4E800FCF1E000F9D9AB00F6D19D00F2C79000EEBF
      8400EAB57600E6AC6900E3A35C00D4914D00BC784000A5643800955330009E42
      1300C5BEBB000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6B69300C0C0C000FFFFFF0000FFFF00C0C0C000FFFFFF00FFFF0000FFFF
      FF00CB797900683F0700C0740C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C7C4C300A14E2400D1925D00EEBF
      8400F3CE9E00FBF7F000FCF7F000FBEDD600F7D6A600F4CD9900F1C48B00EDBB
      7E00E9B27200E5A96400E2A05700DA944900C27C3C00AC67340096563100974A
      2200AE7353000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6B69300C0C0C00000FFFF00FFFFFF00C0C0C000FFFF0000FFFFFF00FFFF
      0000CB797900683F0700C0740C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B2826A00AE603400ECB97B00F0C1
      8800F7E5CC00FCFAF800FCF9F700FBE6C700F7D2A100F3CA9400EFC08700EBB8
      7900E7AE6D00E4A66000E19D5200DD944600C97F3900B26A30009C592D008A4B
      2D009B421400C0ADA40000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6B69300FFFFFF00C0C0C000C0C0C000FFFF0000FFFFFF00FFFF0000FFFF
      FF00CB79790089530900CB7B0C00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009D3E0F009B3B0A009B3B0A009B3B
      0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B
      0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B
      0A009B3B0A00A65E380000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CFA68900CFA68900CFA68900CFA68900CFA68900CFA68900CFA68900CFA6
      8900CB797900CB7B0C0000000000000000000000000000000000000000000000
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
      0000000000000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A00000000000A0A
      0A000A0A0A000A0A0A000A0A0A000A0A0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B2B8BE00788CA2007A90A400000000000000000066819A00788DA100B6BB
      C00000000000000000000000000000000000000000000000000000000000B05A
      1200AE581200AD551100AC541100AB511000A94F1000A84E0F00A74C0E00A54A
      0E00A5480E000A0A0A00121212000B0B0B000A0A0A000A0A0A009E3F0C000A0A
      0A0015151500222222000A0A0A000A0A0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007289
      9F00184F7C000B74A300164D7A0000000000B8BDC1000D4979000A74A3001C50
      7C007A8FA200000000000000000000000000000000000000000000000000B25D
      1300FCF6EE00FCF4EC00FCF3E800FCF1E600FCEFE300FCEEE000FBECDE00FCEB
      DA00FBE9D7007549490074444000EBC8A3009F674D0070414000FBE0C4007549
      4900A0725E00EFE1D2009F674D00704140000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C1C2C5004C6E8D000E6C
      9A001FBFE70028DBFC000E74A20075869F00627995000B7CAC000BD6FC000AB4
      E3000A6496005A7794000000000000000000000000000000000000000000B35F
      1400FCF7F000FCF6ED00FCF4EB00FCF2E800FCF1E500FCF0E300FCEEE000FCED
      DE00FCEBDA008461610074444000EAC5A000865043007D565500FBE2C6008461
      610085554C00F5E5D400865043007D565500000000006B3B3B00000000000000
      00000000000000000000000000000000000000000000000000009B3B0A009B3B
      0A009B3B0A009B3B0A0000000000000000000000000000000000000000000000
      000000000000000000006B3B3B0000000000000000006B3B3B00000000000000
      00000000000000000000000000000000000000000000000000009B3B0A009B3B
      0A009B3B0A009B3B0A0000000000000000000000000000000000000000000000
      000000000000000000006B3B3B0000000000000000006B3B3B00000000000000
      00000000000000000000000000000000000000000000C2C3C60047688C00117A
      A70040DCFC0044DBFC0034C2E800116F9B001276A40025C7F1001AD2FC000DD0
      FC000A71A100567294006B3B3B0000000000000000000000000000000000B562
      1400FCF7F300FCF6F100FCF5EE00FBF4EB00FCF2E800FCF2E500FCEFE300FCEE
      E000FBEDDD009A82820074444000E1B488007443400093777700FBE4CB009A82
      820074444000F5E4D30074433E00937777000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00E1A7
      4C00E2AB55009B3B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00E1A7
      4C00E2AB55009B3B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00385B
      830034ACD10062E2FC0062E2FC005FE5FC0055E4FC0043DBFC0031D9FC00149B
      C90043638700000000000000000000000000000000000000000000000000B764
      1500FCF8F500FCF7F300FCF6F000C36E2300C16A2300BE662300BB632200B760
      2200B35D2200B7AEAE006E3E3E006B3B3B006B3B3B000B0B0B000A0A0A000E0D
      0D006C3C3C006B3B3B006C3B3B0000000000000000006B3B3B00000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00E2A9
      5100E3AE5C009B3B0A0000000000000000000000000000000000000000000000
      000000000000000000006B3B3B0000000000000000006B3B3B00000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00E2A9
      5100E3AE5C009B3B0A0000000000000000000000000000000000000000000000
      000000000000000000006B3B3B0000000000000000006B3B3B00000000000000
      0000000000000000000000000000000000008699A900758AA000929FAE00415E
      83003DA4C80086EEFC0068D1ED002D95BC002A98BF004FCFF1004CE2FC001993
      BF004B668700909FAD0071889D0095A2B200000000000000000000000000B966
      1500FCF9F700FCF8F500FCF7F200CA742400C66F2300C26C2300BF682300BB64
      2200B9622200B55E22006C3B3B006B3B3B006B3B3B00141010000A0A0A002316
      14006C3B3B006C3B3B006C3B3B00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00E3AC
      5700E4B162009B3B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00E3AC
      5700E4B162009B3B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002D5982001778A300146F98003593
      B9008EE5F7007DD1E800114E7B005B75910056728F000E517F004FD0F00041D3
      F6001587B4000B6A99000A72A2003F668800000000000000000000000000BB69
      1700FCF9F700FCF9F700FCF8F400FCF7F200FCF6F000FCF5ED00FCF4EB00FCF2
      E800FCF1E500FCF0E2000A0A0A00C4C4C400696969000A0A0A00FCE7D3000A0A
      0A00C4C4C400696969000A0A0A0000000000000000006B3B3B00000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00E4AF
      5E00E4B467009B3B0A0000000000000000000000000000000000000000000000
      000000000000000000006B3B3B0000000000000000006B3B3B00000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00E4AF
      5E00E4B467009B3B0A0000000000000000000000000000000000000000000000
      000000000000000000006B3B3B0000000000000000006B3B3B00000000000000
      0000000000000000000000000000000000001A527E0068D7F5008CECFC009FEE
      FC00B3F5FC003A8BAE006F839C0000000000000000005F7893002491B90057E3
      FC003ADAFC001DD7FC000AB5E5002F5B8200000000000000000000000000BD6C
      1700FCFBF900FCFAF700FCF9F700FCF8F500FBF7F200FCF6F000FCF5EE00FCF4
      EA00FBF3E800FCF1E5000A0A0A000A0A0A000A0A0A001D1D1D00FBE8D6000A0A
      0A000A0A0A000A0A0A001D1D1D00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00E4B2
      6300E5B76D009B3B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00E4B2
      6300E5B76D009B3B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000018527D0078DEF700A0F2FC00B6F4
      FC00CCF8FC003C87A8007C8EA20000000000000000006A809900238BB20062E4
      FC0044DDFC0028DBFC000CB7E6002F5B8200000000000000000000000000BE6F
      1700FCFCFB00FCFBF900FCFAF700D9822400D47E2400D17B2400CE762300CA74
      2300C6702300C26B2300BF682200BC652200B9622200FBECDC00FBEAD900FBE8
      D600A64B0E00000000000000000000000000000000006B3B3B00000000000000
      000000000000000000006B3B3B000000000000000000000000009B3B0A00E5B5
      6900E6B973009B3B0A000000000000000000000000006B3B3B00000000000000
      000000000000000000006B3B3B0000000000000000006B3B3B00000000000000
      0000000000006B3B3B00000000000000000000000000000000009B3B0A00E5B5
      6900E6B973009B3B0A00000000000000000000000000000000006B3B3B000000
      000000000000000000006B3B3B0000000000000000006B3B3B00000000000000
      000000000000000000000000000000000000275780003393B800358AAC0068AF
      CB00D9F7FB00AFD1E0001B4D79007A8CA10073879E00154D7A0065CDE80062DF
      F900239CC5001082AE000C86B50039618600000000000000000000000000BF71
      1700FCFCFC00FCFBFB00FCFBF900DD872500DA842400D6802400D27C2400CF78
      2300CB742300C8712300C46D2300C0692200BD662200FCEDDF00FCECDC00FCEA
      D900A84E0F000000000000000000000000000000000000000000000000000000
      000000000000000000006B3B3B006B3B3B0000000000000000009B3B0A00E6B8
      6F00E7BC78009B3B0A0000000000000000006B3B3B006B3B3B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006B3B3B006B3B3B00000000000000000000000000000000009B3B0A00E6B8
      6F00E7BC78009B3B0A00000000000000000000000000000000006B3B3B006B3B
      3B00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000748BA2005673900073889E003555
      7E0087BAD000FCFCFC00AED0DE003A81A4003384A70075CAE30087EEFC0034A1
      C7003C5B810073889E0052728F008598A900000000000000000000000000C173
      1700FCFCFC00FCFCFC00FCFBFB00FCFBF900FCFAF700FCF9F600FBF7F500FCF7
      F200FCF6EF00FCF4ED00FBF4EA00FCF2E700FCF1E500FCEFE200FBEDDF00FBEB
      DC00AA501000000000000000000000000000000000006B3B3B00000000006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B00000000009B3B0A00E7BA
      7400E8BF7E009B3B0A00000000006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B00000000006B3B3B0000000000000000006B3B3B00000000006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B00000000009B3B0A00E7BA
      7400E8BF7E009B3B0A00000000006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B00000000006B3B3B0000000000000000006B3B3B00000000000000
      00000000000000000000000000000000000000000000000000009B3B0A004864
      890072AEC700E6FBFC00E4FCFC00D8FCFC00BEFAFC009AEDFC007EE8FC002A98
      BE00546D9000000000006B3B3B0000000000000000000000000000000000C375
      1900FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFAF900FCFAF800FCF9F600FBF7
      F400FBF7F200FCF6EF00FBF5ED00FCF3EA00FBF2E700FCF0E400FCEFE200F9E0
      C800AC5211000000000000000000000000000000000000000000000000006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B009B3B0A00E8BD
      7A00E9C184009B3B0A006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B0000000000000000000000000000000000000000006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B00000000009B3B0A00E8BD
      7A00E9C184009B3B0A00000000006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000677E9B001B74
      9C00B4EDF800C6F5FC00B5E9F7004E99B9004A9FBF0085E3F80073E4FC0053D7
      F7000B5885007488A3000000000000000000000000000000000000000000C577
      1900FCFCFC00FCFCFC00FCFCFC00EB952500E8922500E48E2500E28B2400DE88
      2400DA842400D7802400D37D2300D0792300CD742100FCE5D100F8D9BC00ECC7
      A300AC551100000000000000000000000000000000006B3B3B00000000006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B00000000009B3B0A00E8BF
      8000EAC58A009B3B0A00000000006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B00000000006B3B3B0000000000000000006B3B3B00000000006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B00000000009B3B0A00E8BF
      8000EAC58A009B3B0A00000000006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B00000000006B3B3B0000000000000000006B3B3B00000000000000
      00000000000000000000000000000000000000000000BEC0C400315880002882
      A8009EE9F900B5F8FC00358AAC00546B8D00456185002B93B8006DEBFC004AD6
      F7001174A100406486006B3B3B0000000000000000000000000000000000C679
      1A00FCFCFC00FCFCFC00FCFCFC00EF992500ED962500E9942500E6902500E38D
      2400E0892400DC852100D8801F00D47A1E00D0761B00ECC7A300ECC7A300ECC7
      A300AE5712000000000000000000000000000000000000000000000000000000
      000000000000000000006B3B3B006B3B3B0000000000000000009B3B0A00EAC3
      8700EBC890009B3B0A0000000000000000006B3B3B006B3B3B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00006B3B3B006B3B3B00000000000000000000000000000000009B3B0A00EAC3
      8700EBC890009B3B0A00000000000000000000000000000000006B3B3B006B3B
      3B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDC0C300506F
      8E0010618D0044A0C000114E7A00C1C3C500B0B6BD000B5382002599BF000C5A
      880059769300C1C3C5000000000000000000000000000000000000000000C87B
      1B00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFA
      F900FCF9F700BB691600B9661500B8641500B6621400B5611400B35E1400B15C
      1300AF5A1200000000000000000000000000000000006B3B3B00000000000000
      000000000000000000006B3B3B000000000000000000000000009B3B0A00EAC6
      8C00ECCA96009B3B0A000000000000000000000000006B3B3B00000000000000
      000000000000000000006B3B3B0000000000000000006B3B3B00000000000000
      0000000000006B3B3B00000000000000000000000000000000009B3B0A00EAC6
      8C00ECCA96009B3B0A00000000000000000000000000000000006B3B3B000000
      000000000000000000006B3B3B0000000000000000006B3B3B00000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00EAC6
      8C0095A2B0004E6C8D0050738F000000000000000000486B8D0052708E009AA6
      B20000000000000000006B3B3B0000000000000000000000000000000000C87D
      1B00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFB00FCFB
      FB00FCFAF900BC6B1700FCFCFC00FCF7F200FCEFE300FCE5D100FBDEC100B35F
      1400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00EBC9
      9200EDCD9B009B3B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00EBC9
      9200EDCD9B009B3B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000009B3B0A00EBC9
      9200EDCD9B009B3B0A0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CA80
      1B00FCFCFC00FCFCFC00FCFCFC00F9A42500F7A12500F59F2500F29C2500F19A
      2500ED972500BE6E1700FCF7F200FCEFE300FCE5D100FBDEC100B76215000000
      00000000000000000000000000000000000000000000CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A009B3B0A009B3B0A009B3B0A00ECCB
      9800EED0A1009B3B0A009B3B0A009B3B0A00CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A000000000000000000CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A009B3B0A009B3B0A009B3B0A00ECCB
      9800EED0A1009B3B0A009B3B0A009B3B0A00CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A000000000000000000CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A009B3B0A009B3B0A009B3B0A00ECCB
      9800EED0A1009B3B0A009B3B0A009B3B0A00CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A0000000000000000000000000000000000CB82
      1C00FCFCFC00FCFCFC00FCFCFC00FBA52500F9A42500F7A22500F6A02500F49D
      2500F19B2500BF701700FCEFE300FCE5D100FBDEC100BA671600000000000000
      00000000000000000000000000000000000000000000CC6B0A00000000000000
      0000000000000000000000000000000000009B3B0A00EBC891009B3B0A00EDCE
      9D00EFD2A7009B3B0A00E1A84E009B3B0A000000000000000000000000000000
      00000000000000000000CC6B0A000000000000000000CC6B0A00000000000000
      0000000000000000000000000000000000009B3B0A00EBC891009B3B0A00EDCE
      9D00EFD2A7009B3B0A00E1A84E009B3B0A000000000000000000000000000000
      00000000000000000000CC6B0A000000000000000000CC6B0A00000000000000
      0000000000000000000000000000000000009B3B0A00EBC891009B3B0A00EDCE
      9D00EFD2A7009B3B0A00E1A84E009B3B0A000000000000000000000000000000
      00000000000000000000CC6B0A0000000000000000000000000000000000CC83
      1C00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00C0721800FCE5D100FBDEC100BD6D170000000000000000000000
      00000000000000000000000000000000000000000000CC6B0A00000000000000
      0000000000000000000000000000000000009B3B0A00EDCF9E009B3B0A00EED1
      A300F0D5AC009B3B0A00E3AD5B009B3B0A000000000000000000000000000000
      00000000000000000000CC6B0A000000000000000000CC6B0A00000000000000
      0000000000000000000000000000000000009B3B0A00EDCF9E009B3B0A00EED1
      A300F0D5AC009B3B0A00E3AD5B009B3B0A000000000000000000000000000000
      00000000000000000000CC6B0A000000000000000000CC6B0A00000000000000
      0000000000000000000000000000000000009B3B0A00EDCF9E009B3B0A00EED1
      A300F0D5AC009B3B0A00E3AD5B009B3B0A000000000000000000000000000000
      00000000000000000000CC6B0A0000000000000000000000000000000000CD85
      1D00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00C3751800FBDEC100BF7217000000000000000000000000000000
      00000000000000000000000000000000000000000000CC6B0A00000000000000
      0000000000000000000000000000000000009B3B0A00F0D5AC009B3B0A00EFD3
      A900F1D9B3009B3B0A00E5B468009B3B0A000000000000000000000000000000
      00000000000000000000CC6B0A000000000000000000CC6B0A00000000000000
      0000000000000000000000000000000000009B3B0A00F0D5AC009B3B0A00EFD3
      A900F1D9B3009B3B0A00E5B468009B3B0A000000000000000000000000000000
      00000000000000000000CC6B0A000000000000000000CC6B0A00000000000000
      0000000000000000000000000000000000009B3B0A00F0D5AC009B3B0A00EFD3
      A900F1D9B3009B3B0A00E5B468009B3B0A000000000000000000000000000000
      00000000000000000000CC6B0A0000000000000000000000000000000000CE86
      1D00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00C4771900C3751800000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A009B3B0A009B3B0A009B3B0A009B3B
      0A009B3B0A009B3B0A009B3B0A009B3B0A00CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A000000000000000000CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A009B3B0A009B3B0A009B3B0A009B3B
      0A009B3B0A009B3B0A009B3B0A009B3B0A00CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A000000000000000000CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A009B3B0A009B3B0A009B3B0A009B3B
      0A009B3B0A009B3B0A009B3B0A009B3B0A00CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A0000000000000000000000000000000000CF87
      1D00CE861D00CE851D00CD831C00CC821C00CB811C00CA801B00C97E1B00C87C
      1A00C77B1A00C579190000000000000000000000000000000000000000000000
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
      000072899F00184F7C000B74A300164D7A0000000000B8BDC1000D4979000A74
      A3001C507C007A8FA20000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A00000000000A0A
      0A000A0A0A000A0A0A000A0A0A000A0A0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C1C2C5004C6E
      8D000E6C9A001FBFE70028DBFC000E74A20075869F00627995000B7CAC000BD6
      FC000AB4E3000A6496005A77940000000000000000000000000000000000B359
      0A00B1580A00AF560A00AE530A00AC510A00AC4F0A00AA4E0A00A94C0A00A74A
      0A00A6480A00A4460A00A3450A00A2430A00A0410A009F400A009E3E0A009D3D
      0A009C3C0A00000000000000000000000000000000000000000000000000B05A
      1200AE581200AD551100AC541100AB511000A94F1000A84E0F00A74C0E00A54A
      0E00A5480E00A3470D00A2440D00A1430D009F410C009F400B009E3F0C009D3D
      0B009C3C0B00000000000000000000000000000000000000000000000000B359
      0A00B1580A00AF560A00AE530A00AC510A00AC4F0A00AA4E0A00A94C0A00A74A
      0A00A6480A000A0A0A00121212000B0B0B000A0A0A000A0A0A009E3E0A000A0A
      0A0015151500222222000A0A0A000A0A0A006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B00C2C3C6004768
      8C00117AA70040DCFC0044DBFC0034C2E800116F9B001276A40025C7F1001AD2
      FC000DD0FC000A71A100567294006B3B3B00000000000000000000000000B55C
      0A00FCF6EE00FCF4EC00FCF3E800FCF1E600FCEFE300FCEEE000FBECDE00FCEB
      DA00FBE9D700FCE8D300FCE5D100FCE4CE00FBE3CB00FCE2C700FBE0C400FBDE
      C1009D3E0A00000000000000000000000000000000000000000000000000B25D
      1300FCF6EE00FCF4EC00FCF3E800FCF1E600FCEFE300FCEEE000FBECDE00FCEB
      DA00FBE9D700FCE8D300FCE5D100FCE4CE00FBE3CB00FCE2C700FBE0C400FBDE
      C1009D3E0B00000000000000000000000000000000000000000000000000B55C
      0A00FCF6EE00FCF4EC00FCF3E800FCF1E600FCEFE300FCEEE000FBECDE00FCEB
      DA00FBE9D7007549490074444000EBC8A3009F674D0070414000FBE0C4007549
      4900A0725E00EFE1D2009F674D00704140006B3B3B00BEA6A200FBF7EF00FCF7
      ED00FCF6EA00FCF4E700FBF3E5006B3B3B00BEA29900FBF0DE00FCEFDB00FBEE
      D800385B830034ACD10062E2FC0062E2FC005FE5FC0055E4FC0043DBFC0031D9
      FC00149BC90043638700FBE4BD006B3B3B00000000000000000000000000B75F
      0A00FCF7F000FCF6ED00FCF4EB00FCF2E800FCF1E500FCF0E300FCEEE000FCED
      DE00FCEBDA00FCEAD600FCE7D300FBE5D100FCE4CE00FCE4CA00FBE2C600FCE0
      C3009F3F0A00000000000000000000000000000000000000000000000000B35F
      1400FCF7F000FCF6ED00FCF4EB00FCF2E800FCF1E500FCF0E300FCEEE000FCED
      DE00FCEBDA00FCEAD600FCE7D300FBE5D100FCE4CE00FCE4CA00FBE2C600FCE0
      C3009E3F0B00000000000000000000000000000000000000000000000000B75F
      0A00FCF7F000FCF6ED00FCF4EB00FCF2E800FCF1E500FCF0E300FCEEE000FCED
      DE00FCEBDA008461610074444000EAC5A000865043007D565500FBE2C6008461
      610085554C00F5E5D400865043007D5655006B3B3B00BEA7A300FCF7F100FCF7
      EF00FCF6EB00FBF5EA00FCF5E7006B3B3B00BDA399008699A900758AA000929F
      AE00415E83003DA4C80086EEFC0068D1ED002D95BC002A98BF004FCFF1004CE2
      FC001993BF004B668700909FAD0071889D00000000000000000000000000B961
      0A00FCF7F300FCF6F100FCF5EE00FBF4EB00FCF2E800FCF2E500FCEFE300FCEE
      E000FBEDDD00FBEBDA00FCE9D700FCE7D300FCE5D100FBE4CD00FBE4CB00FCE2
      C600A0410A00000000000000000000000000000000000000000000000000B562
      1400FCF7F300FCF6F100FCF5EE00FBF4EB00FCF2E800FCF2E500FCEFE300FCEE
      E000FBEDDD00FBEBDA00FCE9D700FCE7D300FCE5D100FBE4CD00FBE4CB00FCE2
      C6009F410C00000000000000000000000000000000000000000000000000B961
      0A00FCF7F300FCF6F100FCF5EE00FBF4EB00FCF2E800FCF2E500FCEFE300FCEE
      E000FBEDDD009A82820074444000E1B488007443400093777700FBE4CB009A82
      820074444000F5E4D30074433E00937777006B3B3B00BEA7A300FCF8F200FCF7
      F000FBF7ED00FCF6EB00FCF5E9006B3B3B00BEA39A002D5982001778A300146F
      98003593B9008EE5F7007DD1E800114E7B005B75910056728F000E517F004FD0
      F00041D3F6001587B4000B6A99000A72A200000000000000000000000000BC63
      0A00FCF8F500FCF7F300FCF6F000FCF5EE00FCF3EB00FCF2E800FCF1E500FBEF
      E300FCEEE000FCECDC00FBEADA00FCE9D600FCE7D300FCE5D100FCE4CD00FBE3
      CA00A1430A00000000000000000000000000000000000000000000000000B764
      1500FCF8F500FCF7F300FCF6F000C36E2300C16A2300BE662300BB632200B760
      2200B35D2200B15A2100AE562100AC532100AA512000FCE5D100FCE4CD00FBE3
      CA00A1420C00000000000000000000000000000000000000000000000000BC63
      0A00FCF8F500FCF7F300FCF6F000FCF5EE00FCF3EB00FCF2E800FCF1E500FBEF
      E300FCEEE000B7AEAE006E3E3E006B3B3B006B3B3B000B0B0B000A0A0A000E0D
      0D006C3C3C006B3B3B006C3B3B00B2A7A7006B3B3B00BEA7A400FCF8F300FCF7
      F100FBF7EE00FBF6ED00FBF6EA006B3B3B00BDA39B001A527E0068D7F5008CEC
      FC009FEEFC00B3F5FC003A8BAE006F839C00FCEAD000FBE9CD005F7893002491
      B90057E3FC003ADAFC001DD7FC000AB5E500000000000000000000000000BD66
      0A00FCF9F700FCF8F500FCF7F200FCF7F000FBF5ED00FCF4EB00FCF2E800FBF1
      E500FCF0E300FCEEE000FCECDC00FCEADA00FCE9D600FCE7D300FCE5D100FBE4
      CD00A3450A00000000000000000000000000000000000000000000000000B966
      1500FCF9F700FCF8F500FCF7F200CA742400C66F2300C26C2300BF682300BB64
      2200B9622200B55E2200B35A2100AF572100AC552100FCE7D300FCE5D100FBE4
      CD00A2450C00000000000000000000000000000000000000000000000000BD66
      0A00FCF9F700FCF8F500FCF7F200FCF7F000FBF5ED00FCF4EB00FCF2E800FBF1
      E500FCF0E300FCEEE0006C3B3B006B3B3B006B3B3B00141010000A0A0A002316
      14006C3B3B006C3B3B006C3B3B00000000006B3B3B00BDA8A600FCF9F600FBF8
      F400FCF7F100FCF7EE00FCF7EC006B3B3B00BEA49C0018527D0078DEF700A0F2
      FC00B6F4FC00CCF8FC003C87A8007C8EA200BE9F9000BD9E8E006A809900238B
      B20062E4FC0044DDFC0028DBFC000CB7E600000000000000000000000000BF69
      0A00FCF9F700FCF9F700FCF8F400FCF7F200FCF6F000FCF5ED00FCF4EB00FCF2
      E800FCF1E500FCF0E200FCEEE000FCECDC00FCEAD900FCE9D600FCE7D300FBE5
      D100A5470A00000000000000000000000000000000000000000000000000BB69
      1700FCF9F700FCF9F700FCF8F400FCF7F200FCF6F000FCF5ED00FCF4EB00FCF2
      E800FCF1E500FCF0E200FCEEE000FCECDC00FCEAD900FCE9D600FCE7D300FBE5
      D100A3470D00000000000000000000000000000000000000000000000000BF69
      0A00FCF9F700FCF9F700FCF8F400FCF7F200FCF6F000FCF5ED00FCF4EB00FCF2
      E800FCF1E500FCF0E2000A0A0A00C4C4C400696969000A0A0A00FCE7D3000A0A
      0A00C4C4C400696969000A0A0A00000000006B3B3B00BEA8A600FCFAF700FCF9
      F500FCF7F300FBF7F000FBF7EE006B3B3B006B3B3B00275780003393B800358A
      AC0068AFCB00D9F7FB00AFD1E0001B4D79007A8CA10073879E00154D7A0065CD
      E80062DFF900239CC5001082AE000C86B500000000000000000000000000C06B
      0A00FCFBF900FCFAF7003FBB5A003DB857003CB4530039B1500037AE4E0035AB
      4A0033A8470030A544002EA241002C9E3D002A9B3B0029983700FBE8D600FBE7
      D300A6490A00000000000000000000000000000000000000000000000000BD6C
      1700FCFBF900FCFAF700FCF9F700FCF8F500FBF7F200FCF6F000FCF5EE00FCF4
      EA00FBF3E800FCF1E500FCEFE300FCEDE000FCECDD00FCEAD900FBE8D600FBE7
      D300A54A0E00000000000000000000000000000000000000000000000000C06B
      0A00FCFBF900FCFAF7003FBB5A003DB857003CB4530039B1500037AE4E0035AB
      4A0033A8470030A544000A0A0A000A0A0A000A0A0A001D1D1D00FBE8D6000A0A
      0A000A0A0A000A0A0A001D1D1D00000000006B3B3B00BEA8A600FCFAF700FCF9
      F500FCF9F300FCF7F100FBF7EF006B3B3B00BDA59E00748BA200567390007388
      9E0035557E0087BAD000FCFCFC00AED0DE003A81A4003384A70075CAE30087EE
      FC0034A1C7003C5B810073889E0052728F00000000000000000000000000C36E
      0A00FCFCFB00FCFBF90059E1800057DE7D004CCE6D0045C3620049CA69004FD1
      71004DCE6D004BCB6A0048C8670046C4630044C1610041BF5E00FBEAD900FBE8
      D600A84B0A00000000000000000000000000000000000000000000000000BE6F
      1700FCFCFB00FCFBF900FCFAF700D9822400D47E2400D17B2400CE762300CA74
      2300C6702300C26B2300BF682200BC652200B9622200FBECDC00FBEAD900FBE8
      D600A64B0E00000000000000000000000000000000000000000000000000C36E
      0A00FCFCFB00FCFBF90059E1800057DE7D004CCE6D0045C3620049CA69004FD1
      71004DCE6D004BCB6A0048C8670046C4630044C1610041BF5E00FBEAD900FBE8
      D600A84B0A000000000000000000000000006B3B3B00BEA8A700FCFBF800FCFA
      F700FCF9F500FCF9F300FCF7F0006B3B3B00BEA69F00FCF6EA00FBF5E600FBF3
      E4004864890072AEC700E6FBFC00E4FCFC00D8FCFC00BEFAFC009AEDFC007EE8
      FC002A98BE00546D9000FBE8C8006B3B3B00000000000000000000000000C571
      0A00FCFCFC00FCFBFB0068F8980056DC7B004BCB6A0045C262003EBA590042BF
      5F0056DE7D0063F2910062EE8D0060EB8A005EE787005CE48400FCECDC00FCEA
      D900AA4E0A00000000000000000000000000000000000000000000000000BF71
      1700FCFCFC00FCFBFB00FCFBF900DD872500DA842400D6802400D27C2400CF78
      2300CB742300C8712300C46D2300C0692200BD662200FCEDDF00FCECDC00FCEA
      D900A84E0F00000000000000000000000000000000000000000000000000C571
      0A00FCFCFC00FCFBFB0068F8980056DC7B004BCB6A0045C262003EBA590042BF
      5F0056DE7D0063F2910062EE8D0060EB8A005EE787005CE48400FCECDC00FCEA
      D900AA4E0A000000000000000000000000006B3B3B00BEA9A800FCFBF900FCFA
      F800FCF9F700FCF9F400FCF8F3006B3B3B00BEA5A000FBF6EB00FCF5E800677E
      9B001B749C00B4EDF800C6F5FC00B5E9F7004E99B9004A9FBF0085E3F80073E4
      FC0053D7F7000B5885007488A3006B3B3B00000000000000000000000000C673
      0A00FCFCFC00FCFCFC00A8AF870077DD8D005EE9880058E1800064CB78007DB0
      7300A4957400B59A810084DC93006BFC9B006BFC9B006BFC9B00FBEDDF00FBEB
      DC00AC4F0A00000000000000000000000000000000000000000000000000C173
      1700FCFCFC00FCFCFC00FCFBFB00FCFBF900FCFAF700FCF9F600FBF7F500FCF7
      F200FCF6EF00FCF4ED00FBF4EA00FCF2E700FCF1E500FCEFE200FBEDDF00FBEB
      DC00AA501000000000000000000000000000000000000000000000000000C673
      0A00FCFCFC00FCFCFC00A8AF870077DD8D005EE9880058E1800064CB78007DB0
      7300A4957400B59A810084DC93006BFC9B006BFC9B006BFC9B00FBEDDF00FBEB
      DC00AC4F0A000000000000000000000000006B3B3B00BEA9A800FCFBFA00FCFB
      F800FCFAF700FCF9F600FCF8F4006B3B3B00BDA6A000FCF6EC00BEC0C4003158
      80002882A8009EE9F900B5F8FC00358AAC00546B8D00456185002B93B8006DEB
      FC004AD6F7001174A100406486006B3B3B00000000000000000000000000C875
      0A00FCFCFC00FCFCFC00DA959500DA959500DA959500DA959500DA959500DA95
      9500DA959500DA959500B1755E0092744600869F6200869F6200FCEFE200FBED
      DF00AD520A00000000000000000000000000000000000000000000000000C375
      1900FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFAF900FCFAF800FCF9F600FBF7
      F400FBF7F200FCF6EF00FBF5ED00FCF3EA00FBF2E700FCF0E400FCEFE200F9E0
      C800AC521100000000000000000000000000000000000000000000000000C875
      0A00FCFCFC00FCFCFC00DA959500DA959500DA959500DA959500DA959500DA95
      9500DA959500DA959500B1755E0092744600869F6200869F6200FCEFE200FBED
      DF00AD520A000000000000000000000000006B3B3B00BEA8A900FCFBFA00FCFB
      F900FBFBF800FCFAF600FCF9F5006B3B3B00BEA6A200FCF7EF00FBF6EC00BDC0
      C300506F8E0010618D0044A0C000114E7A00C1C3C500B0B6BD000B5382002599
      BF000C5A880059769300C1C3C5006B3B3B00000000000000000000000000CA77
      0A00FCFCFC00FCFCFC00E2ACA900E2ADAD00E2ADAD00E2ADAD00E2ADAD00E2AD
      AD00E2ADAD00D39F8900B4845800B4845800B4845800B5855700FCF0E400FCEF
      E200AF540A00000000000000000000000000000000000000000000000000C577
      1900FCFCFC00FCFCFC00FCFCFC00EB952500E8922500E48E2500E28B2400DE88
      2400DA842400D7802400D37D2300D0792300CD742100FCE5D100F8D9BC00ECC7
      A300AC551100000000000000000000000000000000000000000000000000CA77
      0A00FCFCFC00FCFCFC00E2ACA900E2ADAD00E2ADAD00E2ADAD00E2ADAD00E2AD
      AD00E2ADAD00D39F8900B4845800B4845800B4845800B5855700FCF0E400FCEF
      E200AF540A000000000000000000000000006B3B3B00BEA9A900FCFCFB00FCFC
      FA00FCFAF900FCFAF700FCF9F6006B3B3B00BEA6A300FBF7F000FCF6ED00FCF6
      EA00FCF5E80095A2B0004E6C8D0050738F00FCF1DE00FBEFDB00486B8D005270
      8E009AA6B200FBEBD000FBEACF006B3B3B00000000000000000000000000CB79
      0A00FCFCFC00FCFCFC00D78E2900E6BAA700EAC5C500EAC5C500EAC5C500EAC5
      C500E3B08900D4851000D1943F00D0A67600D1A36C00D28A2100FCF2E700FCF0
      E400B1570A00000000000000000000000000000000000000000000000000C679
      1A00FCFCFC00FCFCFC00FCFCFC00EF992500ED962500E9942500E6902500E38D
      2400E0892400DC852100D8801F00D47A1E00D0761B00ECC7A300ECC7A300ECC7
      A300AE571200000000000000000000000000000000000000000000000000CB79
      0A00FCFCFC00FCFCFC00D78E2900E6BAA700EAC5C500EAC5C500EAC5C500EAC5
      C500E3B08900D4851000D1943F00D0A67600D1A36C00D28A2100FCF2E700FCF0
      E400B1570A000000000000000000000000006B3B3B00BEA9A900FCFCFC00FCFB
      FB00FCFBFA00FCFAF800FCFAF7006B3B3B00BEA7A300FCF7F100FCF7EF00FCF6
      EC00FCF5E900FBF5E700FCF3E400FCF2E200FCF2E000FBF0DC00FBEFDA00FCEE
      D700FCECD400FCEBD100FCEBD0006B3B3B00000000000000000000000000CD7B
      0A00FCFCFC00FCFCFC00CA770A00CC7B1200E2B48700F3DFDF00F3DFDF00E4B8
      8F00CB7A0F00CA770A00CA770A00D0862500CD7F1800CA770A00FCF3EA00FCF1
      E600B35A0A00000000000000000000000000000000000000000000000000C87B
      1B00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFA
      F900FCF9F700BB691600B9661500B8641500B6621400B5611400B35E1400B15C
      1300AF5A1200000000000000000000000000000000000000000000000000CD7B
      0A00FCFCFC00FCFCFC00CA770A00CC7B1200E2B48700F3DFDF00F3DFDF00E4B8
      8F00CB7A0F00CA770A00CA770A00D0862500CD7F1800CA770A00FCF3EA00FCF1
      E600B35A0A000000000000000000000000006B3B3B00BEA9A900BEA9A900BEA9
      A900BEA9A900BEA8A700BEA8A7006B3B3B00BEA7A400BEA7A300BEA6A200BDA6
      A000BDA59F00BEA59E00BDA49C00BDA39B00BEA39900BEA29800BEA29700BEA1
      9600BDA09400BEA09200BD9F91006B3B3B00000000000000000000000000CE7D
      0A00FCFCFC00FCFCFC00C16B0A00C16B0A00C16B0A00D3985500D7A16600C16B
      0A00C16B0A00C16B0A00C16B0A00C16B0A00C16B0A00C16B0A00FCF5ED00FCF4
      EA00B65C0A00000000000000000000000000000000000000000000000000C87D
      1B00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFB00FCFB
      FB00FCFAF900BC6B1700FCFCFC00FCF7F200FCEFE300FCE5D100FBDEC100B35F
      140000000000000000000000000000000000000000000000000000000000CE7D
      0A00FCFCFC00FCFCFC00C16B0A00C16B0A00C16B0A00D3985500D7A16600C16B
      0A00C16B0A00C16B0A00C16B0A00C16B0A00C16B0A00C16B0A00FCF5ED00FCF4
      EA00B65C0A000000000000000000000000006B3B3B00FBCB9900FAC99800F8C5
      9200F7C18D00F5BE8600F3B97F00F0B37700EDAE7000EAA86700E7A35F00E49D
      5600E2984D00DF914400DC8C3C00D9873400D6822B00D37C2500D1771D00D074
      1700CD701200CC6C0D00CC6B0B006B3B3B00000000000000000000000000D07F
      0A00FCFCFC00FCFCFC00B85F0A00B85F0A00B85F0A00B85F0A00B85F0A00B85F
      0A00B85F0A00B85F0A00B85F0A00B85F0A00B85F0A00B85F0A00FCF6EF00FCF4
      EC00B7600A00000000000000000000000000000000000000000000000000CA80
      1B00FCFCFC00FCFCFC00FCFCFC00F9A42500F7A12500F59F2500F29C2500F19A
      2500ED972500BE6E1700FCF7F200FCEFE300FCE5D100FBDEC100B76215000000
      000000000000000000000000000000000000000000000000000000000000D07F
      0A00FCFCFC00FCFCFC00B85F0A00B85F0A00B85F0A00B85F0A00B85F0A00B85F
      0A00B85F0A00B85F0A00B85F0A00B85F0A00B85F0A00B85F0A00FCF6EF00FCF4
      EC00B7600A000000000000000000000000006B3B3B00FBCA9900FAC89800F8C6
      9300F7C28D00F5BE8700F3B98000F0B47900EDAF7100EAA96800E8A46000E59D
      5600E2984E00DE934500DC8C3C00D9873400D7822C00D47D2500D1781E00D074
      1800CF701300CC6C0D00CB6B0B006B3B3B00000000000000000000000000D181
      0A00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFBFB00FCFBF900FCF9F700FCF9F500FCF7F300FCF7F100FCF5
      EF00B9610A00000000000000000000000000000000000000000000000000CB82
      1C00FCFCFC00FCFCFC00FCFCFC00FBA52500F9A42500F7A22500F6A02500F49D
      2500F19B2500BF701700FCEFE300FCE5D100FBDEC100BA671600000000000000
      000000000000000000000000000000000000000000000000000000000000D181
      0A00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFBFB00FCFBF900FCF9F700FCF9F500FCF7F300FCF7F100FCF5
      EF00B9610A000000000000000000000000006B3B3B00FBCB9A00FACA9900F9C7
      9300F7C28E00F5BE8700F3B98000F0B57900EDAF7200EAAA6900E7A46000E49E
      5800E2994F00DF924600DC8C3D00DA873500D7832E00D47D2600D2791F00D074
      1800CE701300CD6D0D00CB6C0C006B3B3B00000000000000000000000000D282
      0A00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFBFA00FCFAF800FCF9F700FCF8F500FBF7F300FCF6
      F000BB630A00000000000000000000000000000000000000000000000000CC83
      1C00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00C0721800FCE5D100FBDEC100BD6D170000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D282
      0A00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFBFA00FCFAF800FCF9F700FCF8F500FBF7F300FCF6
      F000BB630A000000000000000000000000006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B00000000000000000000000000D384
      0A00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFB00FBFBFA00FCFAF800FCFAF700FBF8F500FCF7
      F300BD670A00000000000000000000000000000000000000000000000000CD85
      1D00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00C3751800FBDEC100BF7217000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D384
      0A00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFB00FBFBFA00FCFAF800FCFAF700FBF8F500FCF7
      F300BD670A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D486
      0A00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFB00FBFBFA00FCFAF800FCFAF700FBF8F500FCF7
      F300BF690A00000000000000000000000000000000000000000000000000CE86
      1D00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00C4771900C3751800000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D486
      0A00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFB00FBFBFA00FCFAF800FCFAF700FBF8F500FCF7
      F300BF690A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D586
      0A00D4860A00D4840A00D3830A00D2820A00D1810A00D17F0A00CF7D0A00CE7C
      0A00CD7A0A00CC790A00CA760A00C8750A00C7740A00C5720A00C46F0A00C26E
      0A00C06C0A00000000000000000000000000000000000000000000000000CF87
      1D00CE861D00CE851D00CD831C00CC821C00CB811C00CA801B00C97E1B00C87C
      1A00C77B1A00C579190000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D586
      0A00D4860A00D4840A00D3830A00D2820A00D1810A00D17F0A00CF7D0A00CE7C
      0A00CD7A0A00CC790A00CA760A00C8750A00C7740A00C5720A00C46F0A00C26E
      0A00C06C0A000000000000000000000000000000000000000000000000000000
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
      0000277E260000000000A4B6A400458A4600127113000A6B0A000A6B0A001A75
      1B0060976200BBC1BB0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000CFA18B00AE5D3200BC754700A8501F00C38B6E00000000000000
      0000000000000000000000000000000000006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B00000000000000000000000000000000000000
      00000000000000000000C5C4C400AD9F9F0095787500835A5200774842006B3B
      3B006B3B3B0072424000825A55009B848400C3C0C00000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000277E2600187419001474160026A2340032BF45002CB83E001C972500117B
      14000A6B0A001372130099B19900000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C8937A00E0B27E00FFE9B700C47A3800C2856400FBFEFF00A2A1
      D600000000000000000000000000000000006B3B3B00BEA7A300FCF6EA00FCF3
      E500FCF2E100FCF0DB00FCEDD600FBEBD100FCE9CC00FBE7C700FCE5C3006B3B
      3B00BEA7A300FCF6EA00FCF3E500FCF2E100FCF0DB00FCEDD600FBEBD100FCE9
      CC00FBE7C700FCE5C3006B3B3B00000000000000000000000000000000000000
      000000000000AA99980071433F0088543F00A6682E00BE792700CC831C00D787
      0D00D1830D00BF761500A56320008952330070413F00A8979700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C3C500BBBEC200BBBEC200C0C2
      C500277E260046D763003CCA57003DCF5700269D320012711300569256007CA3
      7C006A996A00237A23000F6D0F00A6B7A600B3590A00B1580A00AF560A00AE53
      0A00AC510A00AC4F0A00AA4E0A00A94C0A00A74A0A00A6480A00A4460A00A345
      0A00A2430A00C9957D00DDAD7900FCE4B400CA803C00BD7C58005D66D4000D06
      AA009490D0000000000000000000000000006B3B3B00BEA7A400FCF7EC00FCF5
      E800FCF3E400FCF1DF00FBEFD900FCECD400FCEAD000FBE9CB00FBE6C6006B3B
      3B00BEA7A400FCF7EC00FCF5E800FCF3E400FCF1DF00FBEFD900FCECD400FCEA
      D000FBE9CB00FBE6C6006B3B3B00000000000000000000000000000000000000
      0000000000008C686200B6773500E39D3A00E39E3B00E29C3700E0982E00DC91
      2100D8891100D1830D00C57A1200B9721700A161220071423F00B2A7A7000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000091ABB1006194A5004390AC003390B600228DBC001987BB0077AF
      CD00277E26004BDC6B0046D763002BA53A00267C2700B4BEB400000000000000
      000000000000000000006197620068996800B55C0A00FCF6EE00FCF4EC00FCF3
      E800FCF1E600FCEFE300FCEEE000FBECDE00FCEBDA00FBE9D700FCE8D300FCE5
      D100FCE4CE00C9957D00DCAB7800FFE8B500D38E4900311772000021DF001028
      E2001700AD009B98D10000000000000000006B3B3B00BEA8A600FCF7F000FBF7
      EB00FCF4E700FBF2E300FCF0DD00FCEED800FCECD300FBEACE00FCE8C8006B3B
      3B00BEA8A600FCF7F000FBF7EB00FCF4E700FBF2E300FCF0DD00FCEED800FCEC
      D300FBEACE00FCE8C8006B3B3B00000000000000000000000000000000000000
      00000000000083595300C98B4400E8A85000E9A95200E8A74E00E4A14100E199
      3200DC911F00D6870B00CC7F0F00BF761500B36E1A00874F2D00998282000000
      00000000000000000000000000000000000000000000000000000000000097AA
      B0005399A70066CAD7006AE5F60058E9FC003DE4FC0022DDFC000BD4FC0077E1
      FA00277E26004FE0700049DA690046D763001E77210000000000000000000000
      000000000000000000000000000000000000B75F0A00FCF7F000FCF6ED00FCF4
      EB00FCF2E800FCF1E500FCF0E300FCEEE000FCEDDE00FCEBDA00FCEAD600FCE7
      D300FBE5D100CB988100E6B57B00FAE3AF0047358F000019E200082EE6000930
      E4000D29E1001507B1009897D300000000006B3B3B00BEA8A700FBF8F300FCF7
      EF00FCF6EA00FBF4E500FBF2E000FBF0DB00FCEDD600FBEBD100FBE9CD006B3B
      3B00BEA8A700FBF8F300FCF7EF00FCF6EA00FBF4E500FBF2E000FBF0DB00FCED
      D600FBEBD100FBE9CD006B3B3B00000000000000000000000000000000000000
      0000000000007C524C00D4995500EFB36800F0B46B00EDB06200E9AA5400E4A0
      4000DF972C00BC7620007B483A00C2781300B77118008D522B00947877000000
      000000000000000000000000000000000000000000000000000092A0AC00469C
      B30097FAFC008FFCFC006EF1FC0055E4FC003DDDFC0024D5FC000FCDFB005CD6
      F600277E2600277E2600277E2600277E2600277E2600277E2600000000000000
      000000000000000000000000000000000000B9610A00FCF7F300FCF6F100FCF5
      EE00FBF4EB00FCF2E800FCF2E500FCEFE300FCEEE000FBEDDD00FBEBDA00FCE9
      D700FEFFFF00BB826500BF7038006B70BB00315AED003C6CF800173FE800062D
      E5001528DA002815CD001E00A8009998D5006B3B3B00BEA9A800FCF9F500FCF8
      F100FCF7ED00FCF5E800FBF3E400FCF1DF00FCEFDA00FBEDD400FBEBD0006B3B
      3B00BEA9A800FCF9F500FCF8F100FCF7ED00FCF5E800FBF3E400FCF1DF00FCEF
      DA00FBEDD400FBEBD0006B3B3B00000000000000000000000000000000000000
      0000000000007D524D00D89E6200F5BE7D00F6BF8300F3BA7600EDB06200E7A6
      4B00C684360074443F0075464100B66F1800B97217008C532D009A8080000000
      00000000000000000000000000000000000000000000C4C5C6003E7996006FE5
      F50096F8FB0099F8FC0086F0FC0072EAFC005FE4FC004DDFFC003DDBFC0048DB
      FA006DDEF8007EDBF40079D1EA0077C8E30077C6E1008CA1B800277E2600277E
      2600277E2600277E2600277E2600277E2600BC630A00FCF8F500FCF7F300FCF6
      F000FCF5EE00FCF3EB00FCF2E800FCF1E500FBEFE300FCEEE000FCECDC00FBEA
      DA00D0C1BB00B96F3A004E2A6C001821AB003A47B4005270D1003260F300002C
      E9002B15C7002509A1002516A90016139D006B3B3B00BEA9A900FCFAF700FCF9
      F400FCF7F000FCF6EB00FCF4E600FCF2E300FCF0DD00FCEED800FCECD2006B3B
      3B00BEA9A900FCFAF700FCF9F400FCF7F000FCF6EB00FCF4E600FCF2E300FCF0
      DD00FCEED800FCECD2006B3B3B00000000000000000000000000000000000000
      000000000000855D5800CD966200F7C38900FBCA9800F5BF8000EEB26600CC8F
      4A0075474200D5C1B800966C6000A9651F00BA73170085503600A28E8E000000
      00000000000000000000000000000000000000000000BBBEC000348BA9007BE9
      F700ACF7FB009AEEFA0070E0F70056D6F6003FCDF4002AC4F30019BFF30026BF
      EF0045C8F00046CBF20026CAF6000EBCEB000AA1D100316C9300BEBEC100277C
      280054E579004FE071004ADB6900277E2600BD660A00FCF9F700FCF8F500FCF7
      F200FCF7F000FBF5ED00FCF4EB00FCF2E800FBF1E500FCF0E300FCEEE000F4F4
      F500AE725100DBA36E00F2DCBA00F4D7AE00C8A18E003546BB003161F700002E
      EB001C0CC5004941B000F5F8FA00F4F4FA006B3B3B00BEA9A900BEA9A900BEA9
      A900BEA8A800BEA8A700BEA8A600BEA8A600BEA7A400BEA7A300BEA6A2006B3B
      3B00BEA9A900BEA9A900BEA9A900BEA8A800BEA8A700BEA8A600BEA8A600BEA7
      A400BEA7A300BEA6A2006B3B3B00000000000000000000000000000000000000
      000000000000977D7B00A4715100F5BE7E00F6C08400F3BA7600DB9F5D00794B
      4600D5C8C800FCF7EF00AD8D85009B5D2600B972170077463E00B7AFAF000000
      00000000000000000000000000000000000000000000BBBEC1004596AE0091F3
      FB0084E4F40077E0F40066DFF70051DDF80039D7F9001FD1FA000AC8F9002AC5
      F30048A27D0056A1700084CBE3004DBFE60042CEF5005E92B000A9B5AC00257B
      27003AB34F0054E579004FE17200277E2600BF690A00FCF9F700FCF9F700FCF8
      F400FCF7F200FCF6F000FCF5ED00FCF4EB00FCF2E800FCF1E500FCF0E200CDAF
      A300BB713D00F8D7A900FDE2B700FFDEA900DBB29100394CBE002D5DF8000028
      ED001805C3004D43B20000000000000000006B3B3B00EFB27600EBAA6900E6A1
      5C00E2984E00DE8F4000D9873300D47E2800D1761C00CE711300CC6C0C006B3B
      3B00EFB27600EBAA6900E6A15C00E2984E00DE8F4000D9873300D47E2800D176
      1C00CE711300CC6C0C006B3B3B00000000000000000000000000000000000000
      000000000000BEB8B80072444100D39A6000F0B56C00E6AB62007E4F4A00C9B8
      B800FCFCFC00FCFAF700C7B1AB008E573600A8661F0076494500000000000000
      00000000000000000000000000000000000000000000BBBEC100469AB1006FD9
      F1008DEEF6008AF8FC006EF0FC0053E5FC003ADDFC001FD4FC000ACCFB0020C7
      F4006FCAD00016741700247E280070AB79008DBD990050975800137416003DB6
      55005FF0880052DF750054E57900277E2600C06B0A00FCFBF900FCFAF7003FBB
      5A003DB857003CB4530039B1500037AE4E0035AB4A0033A84700E6E1DE00AD68
      4200E7B57E00FBE5C200FBE2B800FBD7A100D7AB8A003A4EC0004B82FF002459
      FA00363BDA004E48B50000000000000000006B3B3B00EFB37800EBAB6A00E7A1
      5C00E2994F00DD904100D9873400D57F2800D1771D00CF711500CC6C0C006B3B
      3B00EFB37800EBAB6A00E7A15C00E2994F00DD904100D9873400D57F2800D177
      1D00CF711500CC6C0C006B3B3B00000000000000000000000000000000000000
      00000000000000000000AC9C9C0075474100AD8759003B658400145484000A4B
      7B000B4C7C002A689400718EA7007E4F4100814D38009F888700000000000000
      00000000000000000000000000000000000000000000BFC1C3003783A3006DE1
      F20093F8FA008FF7FC007DF0FC006AE9FC0057E4FC0044DEFC0032D8FC002AD1
      F80045D0F30087CBC2001A791D000A6B0A001C87260044C2620063F08F005EE9
      87003DB656001575170019751A00277E2600C36E0A00FCFCFB00FCFBF90059E1
      800057DE7D004CCE6D0045C3620049CA69004FD171004DCE6D00B48B7700C780
      4800F9DAAE00FBEACE00FADDB100FAD29A00D8AD8800161FAA003A54C9003B54
      C8002E4AC500464AB90000000000000000006B3B3B00EFB37800EBAB6B00E6A2
      5D00E2995000DE8F4200DA873500D5802A00D1781E00CF711400CC6D0D006B3B
      3B00EFB37800EBAB6B00E6A25D00E2995000DE8F4200DA873500D5802A00D178
      1E00CF711400CC6D0D006B3B3B00000000000000000000000000000000000000
      0000000000000000000000000000778A9B00115182003988B9005EBBEB0067C6
      F7005DB9E9004093C3001D649500164F7B006B4E5300C5C4C400000000000000
      00000000000000000000000000000000000000000000BDBFC2003687A50072E6
      F500ABF7FB00A8F5FC007FE8FA0062DEF7004BD4F70039CEF6002BC9F60027C6
      F40029C8F30042D2F7007FDAEB0076B1840027802A000A6B0A000A6B0A001674
      18004E915000A6B7A60000000000277E2600C5710A00FCFCFC00FCFBFB0068F8
      980056DC7B004BCB6A0045C262003EBA590042BF5F00DBCDC800AE623400EDBD
      8300FAE8CE00FCEBD000F9D8A800F4CA9300ECBC8300C5937100A97158008A51
      47007D362D00BDB0BB0000000000000000006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B00000000000000000000000000000000000000
      000000000000BFC2C5002F648B00115383005EB5E40074CEFC0074CFFC0073CE
      FC006FCDFC0068C8F8005AB5E500307EAE001A548200BFC2C500000000000000
      00000000000000000000000000000000000000000000BBBEC1003D91AB0092F3
      FB0090E9F70077DEF40062D9F4004ED5F50037D1F7001DCBF8000AC2F7000AB8
      EE000AACE3000CA4DB001EACDD0041C7EF0064D3F200759EB900BDBDC0000000
      000000000000000000000000000000000000C6730A00FCFCFC00FCFCFC00A8AF
      870077DD8D005EE9880058E1800064CB7800F9F8F800B57C6100D3925800F7D5
      A900FBF3E700FBE8CB00F7D29E00F1C68D00EDB97B00EFB26600DE9A5000B775
      3D009C512300B9826200F6F9FA00000000006B3B3B00BEA7A300FCF6EA00FCF3
      E500FCF2E100FCF0DB00FCEDD600FBEBD100FCE9CC00FBE7C700FCE5C3006B3B
      3B00BEA7A300FCF6EA00FCF3E500FCF2E100FCF0DB00FCEDD600FBEBD100FCE9
      CC00FBE7C700FCE5C3006B3B3B00000000000000000000000000000000000000
      000000000000849BAC000A4B7B002066960079D0FC007DD1FC007ED1FC007CD1
      FC0077D0FC0072CEFC0069CAFA0057B0E100276B9A006587A100000000000000
      00000000000000000000000000000000000000000000BBBEC1004B9DB20077E0
      F40087E6F30088F3FA006FEFFC0053E5FC0039DEFC001DD4FC000ACCFC000AC2
      F3000AB9E9000AAFDF000AA0D2000A92C6000AA7DC00186E9C00BBBBBE000000
      000000000000000000000000000000000000C8750A00FCFCFC00FCFCFC00DA95
      9500DA959500DA959500DA959500DA959500C4ABA100BC734000F6CA8E00FFF3
      DE0092744600FFEDCA00FAD6A100F5C98F00EFBC7B00EAAE6600E19D5100C07B
      3D009B5A310093482200DAC8BD00000000006B3B3B00BEA7A400FCF7EC00FCF5
      E800FCF3E400FCF1DF00FBEFD900FCECD400FCEAD000FBE9CB00FBE6C6006B3B
      3B00BEA7A400FCF7EC00FCF5E800FCF3E400FCF1DF00FBEFD900FCECD400FCEA
      D000FBE9CB00FBE6C6006B3B3B00000000000000000000000000000000000000
      0000000000004B7898000A568700125586007BCBF50086D2FB007EC9F30078C4
      EF0075C6F20072C8F5006DCAF90062BFEF004092C200215A8500000000000000
      00000000000000000000000000000000000000000000BDC0C2003787A6006CDD
      F10093F8FA0088F8FC0073EEFC0062E7FC0051E2FC003CDBFC0028D3FB001DCA
      F50013BEEB000BAFE0000AA4D5000A9CCC000A94C6001B5A8900BCBDC0000000
      000000000000000000000000000000000000CA770A00FCFCFC00FCFCFC00E2AC
      A900E2ADAD00E2ADAD00E2ADAD00FBFAF900A2532E00B8642800CC895300CFA0
      8500D0A38A00CE906100CA854E00C77D4200C3763700C06E2B00BE662000AE55
      1500984411008A2F0200A25B3700F6F5F4006B3B3B00BEA8A600FCF7F000FBF7
      EB00FCF4E700FBF2E300FCF0DD00FCEED800FCECD300FBEACE00FCE8C8006B3B
      3B00BEA8A600FCF7F000FBF7EB00FCF4E700FBF2E300FCF0DD00FCEED800FCEC
      D300FBEACE00FCE8C8006B3B3B00000000000000000000000000000000000000
      0000000000002E658D000A6798000F558600488DBA003F83AF00286C99001A5E
      8D001D6291002A72A0003884B200469BCC004BA2D2000D4E7D00000000000000
      00000000000000000000000000000000000000000000BEC0C2003885A3006DE4
      F400A3F7F900B4FAFC00A2F7FC0090F4FC0081F1FC0073ECFC0063E8FC0055E4
      FC0044DCFA0031D1F5001CBDE7000EA3D1000A99C8001C568200BDBDC0000000
      000000000000000000000000000000000000CB790A00FCFCFC00FCFCFC00D78E
      2900E6BAA700EAC5C500EAC5C500FEFCFB00E3C6B800DFC0B300DCBCAF00DCBA
      A900DCB9A800DCBBAD00DDBDAF00DDBEB100DDBFB200DEC0B300DEC0B500E0C3
      B600E2C5B700E3C6B700E2C8BA00FBF8F6006B3B3B00BEA8A700FBF8F300FCF7
      EF00FCF6EA00FBF4E500FBF2E000FBF0DB00FCEDD600FBEBD100FBE9CD006B3B
      3B00BEA8A700FBF8F300FCF7EF00FCF6EA00FBF4E500FBF2E000FBF0DB00FCED
      D600FBEBD100FBE9CD006B3B3B00000000000000000000000000000000000000
      0000000000002A638B000A6D9D000A6D9D000B4C7C000C6495000A6E9E000A73
      A3000A6C9C000A6292000C5B8B000E5485000E51820011507F00000000000000
      00000000000000000000000000000000000000000000BBBEC100368EA90092F0
      F800BAFBFC00A8FCFC008FF7FC0080F3FC0074F0FC0068ECFC005DE7FC0050E4
      FC0045E0FC003BDEFC002FD9FC001FCEF6000EAEDE0017578600BBBBBE000000
      000000000000000000000000000000000000CD7B0A00FCFCFC00FCFCFC00CA77
      0A00CC7B1200E2B48700F3DFDF00F3DFDF00E4B88F00CB7A0F00CA770A00CA77
      0A00D0862500CD7F1800CA770A00FCF3EA00FCF1E600B35A0A00000000000000
      0000000000000000000000000000000000006B3B3B00BEA9A800FCF9F500FCF8
      F100FCF7ED00FCF5E800FBF3E400FCF1DF00FCEFDA00FBEDD400FBEBD0006B3B
      3B00BEA9A800FCF9F500FCF8F100FCF7ED00FCF5E800FBF3E400FCF1DF00FCEF
      DA00FBEDD400FBEBD0006B3B3B00000000000000000000000000000000000000
      000000000000386D91000A6D9D000A85B5000A89BA000A8ABB000A88B9000A83
      B3000A7DAD000A75A6000A6E9E000A6B9B000A6596000D4F7E00A2B0B9000000
      00000000000000000000000000000000000000000000BBBEC100519DB000A9FC
      FC009AFCFC0097FBFC008DF7FC0081F3FC0074F0FC0069ECFC005DE7FC0050E4
      FC0044DFFC0039DCFC002CD7FC0021D5FC0014D5FC00186A9700BBBBBE000000
      000000000000000000000000000000000000CE7D0A00FCFCFC00FCFCFC00C16B
      0A00C16B0A00C16B0A00D3985500D7A16600C16B0A00C16B0A00C16B0A00C16B
      0A00C16B0A00C16B0A00C16B0A00FCF5ED00FCF4EA00B65C0A00000000000000
      0000000000000000000000000000000000006B3B3B00BEA9A900FCFAF700FCF9
      F400FCF7F000FCF6EB00FCF4E600FCF2E300FCF0DD00FCEED800FCECD2006B3B
      3B00BEA9A900FCFAF700FCF9F400FCF7F000FCF6EB00FCF4E600FCF2E300FCF0
      DD00FCEED800FCECD2006B3B3B00000000000000000000000000000000000000
      0000000000006F8FA5000C6191000A89BA000A90C0000A93C3000A8FBF000A88
      B9000A80B0000A78A9000A71A1000A6B9B000A6B9B0010507F00B2BABF000000
      00000000000000000000000000000000000000000000BBBEC10057ABB900A5FC
      FC009BFCFC0099FBFC008DF7FC0081F3FC0074F0FC0069ECFC005DE7FC0050E4
      FC0044DFFC0039DCFC002CD7FC0020D3FC0014DBFC00167FAC00BBBBBE000000
      000000000000000000000000000000000000D07F0A00FCFCFC00FCFCFC00B85F
      0A00B85F0A00B85F0A00B85F0A00B85F0A00B85F0A00B85F0A00B85F0A00B85F
      0A00B85F0A00B85F0A00B85F0A00FCF6EF00FCF4EC00B7600A00000000000000
      0000000000000000000000000000000000006B3B3B00BEA9A900BEA9A900BEA9
      A900BEA8A800BEA8A700BEA8A600BEA8A600BEA7A400BEA7A300BEA6A2006B3B
      3B00BEA9A900BEA9A900BEA9A900BEA8A800BEA8A700BEA8A600BEA8A600BEA7
      A400BEA7A300BEA6A2006B3B3B00000000000000000000000000000000000000
      000000000000B4BAC000115281000A86B6000A94C4000A9ACB000A92C2000A8A
      BB000A82B2000A79AA000A71A1000A6B9B000A6090002A608900000000000000
      00000000000000000000000000000000000000000000000000004F93A300A1FC
      FC009EFCFC0099FBFC008DF7FC0081F3FC0074F0FC0069ECFC005DE7FC0050E4
      FC0044DFFC0039DCFC002CD7FC0021D5FC0014DAFC002A6C9500C3C3C5000000
      000000000000000000000000000000000000D1810A00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFB
      F900FCF9F700FCF9F500FCF7F300FCF7F100FCF5EF00B9610A00000000000000
      0000000000000000000000000000000000006B3B3B00EFB27600EBAA6900E6A1
      5C00E2984E00DE8F4000D9873300D47E2800D1761C00CE711300CC6C0C006B3B
      3B00EFB27600EBAA6900E6A15C00E2984E00DE8F4000D9873300D47E2800D176
      1C00CE711300CC6C0C006B3B3B00000000000000000000000000000000000000
      000000000000000000007290A600105686000A8ABB000A94C4000A8FBF000A88
      B9000A81B1000A78A9000A71A1000A63940011518000A4B0B900000000000000
      000000000000000000000000000000000000000000000000000098ABB20057B6
      BD00A0FCFC00A0FCFC0090F9FC0082F3FC0074F0FC0069ECFC005DE7FC0050E4
      FC0044E0FC003ADFFC002EE0FC0021DAFC001786B3009296A500000000000000
      000000000000000000000000000000000000D2820A00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFB
      FA00FCFAF800FCF9F700FCF8F500FBF7F300FCF6F000BB630A00000000000000
      0000000000000000000000000000000000006B3B3B00EFB37800EBAB6A00E7A1
      5C00E2994F00DD904100D9873400D57F2800D1771D00CF711500CC6C0C006B3B
      3B00EFB37800EBAB6A00E7A15C00E2994F00DD904100D9873400D57F2800D177
      1D00CF711500CC6C0C006B3B3B00000000000000000000000000000000000000
      00000000000000000000000000006D8DA400105180000C6A9A000A79AA000A83
      B3000A7CAC000A6B9B00105B8B001452810097A8B40000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A0B3
      B70062ACAE0073D5D70086F1F50084F7FC007AF7FC006FF5FC0062F0FC0054EB
      FC0045E4FC0035D5F50021ABD00039779A009B9FAB0000000000000000000000
      000000000000000000000000000000000000D3840A00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FBFBFA00FCFAF800FCFAF700FBF8F500FCF7F300BD670A00000000000000
      0000000000000000000000000000000000006B3B3B00EFB37800EBAB6B00E6A2
      5D00E2995000DE8F4200DA873500D5802A00D1781E00CF711400CC6D0D006B3B
      3B00EFB37800EBAB6B00E6A25D00E2995000DE8F4200DA873500D5802A00D178
      1E00CF711400CC6D0D006B3B3B00000000000000000000000000000000000000
      000000000000000000000000000000000000B0B8BE005C829D0027618A000A4B
      7B000A4B7B00255F88006A8AA200BBBFC2000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009EB7B90069A7AE0053A4B10048A8BB0040ABC4003BA5C3003C99
      B900478BA8006388A10099A3AE00000000000000000000000000000000000000
      000000000000000000000000000000000000D4860A00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FBFBFA00FCFAF800FCFAF700FBF8F500FCF7F300BF690A00000000000000
      0000000000000000000000000000000000006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D5860A00D4860A00D4840A00D383
      0A00D2820A00D1810A00D17F0A00CF7D0A00CE7C0A00CD7A0A00CC790A00CA76
      0A00C8750A00C7740A00C5720A00C46F0A00C26E0A00C06C0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000060000000600000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFFFFFFFF000000FF03FFC0
      7DFFFFFFFF000000FF03FF8039FFFFFFFF000000FF037F80300FFFFE7F000000
      FF023F8039EFFFDE3F000000FF001F801DEF871C8D000000FF000FC01FEFFADD
      E1000000FF0007801FEFFDCDF3000000FF0003801807FFEDFF000000FE000180
      1003FFEBFF000000FC0000801003FFEBFF000000FC000F801003FFEBFF000000
      F8000F801001FFEBFF000000F8000F801801FFEBFF000000F0000F801001FFEB
      FF000000E0000F801001FFEBFF000000E0000FFFF001FFEBFF000000C0000FFF
      F001FFEBFF000000C0000FFFF001FFE3FF000000800007FFF001FFF7FF000000
      000007FFF001FFF7FF000000000003FFF001FFFFFF000000000003FFF003FFFF
      FF000000FFFFFFFFFFFFFFFFFF000000FFF820FFFFFFFFFFFFFFF18FE00000FF
      FFFFFFFFFFFFE107E00000FFFFFFFFFFFFFF8003E00000BFC3FDBFC3FDBF8001
      E00000FFC3FFFFC3FFFFC007E00001BFC3FDBFC3FDBF0000E00001FFC3FFFFC3
      FFFF0000E00001BFC3FDBFC3FDBF0180E00001FFC3FFFFC3FFFF0180E00007BD
      C3BDBBC3DDBF0000E00007FCC33FF3C3CFFF0000E00007A04205A04205BFC005
      E00007E00007C04203FFC003E00007A04205A04205BF8001E00007FCC33FF3C3
      CFFFC003E00007BDC3BDBBC3DDBFC18DE0000FFFC3FFFFC3FFFFC3FFE0001F80
      0001800001800001E0003FBF00FDBF00FDBF00FDE0007FBF00FDBF00FDBF00FD
      E000FFBF00FDBF00FDBF00FDE001FF800001800001800001E003FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF083FFFFFFFFFFFFFFF820FFC001E0
      0007E00007E00000000000E00007E00007E00000000000E00007E00007E00000
      000000E00007E00007E00000000000E00007E00007E00000000000E00007E000
      07E00001000000E00007E00007E00001000000E00007E00007E00001000000E0
      0007E00007E00007000000E00007E00007E00007000000E00007E00007E00007
      000000E00007E00007E00007000000E00007E00007E00007000000E00007E000
      07E00007000000E00007E00007E00007000000E00007E0000FE00007000000E0
      0007E0001FE00007000000E00007E0003FE00007000000E00007E0007FE00007
      000000E00007E000FFE00007FFFFFFE00007E001FFE00007FFFFFFE00007E003
      FFE00007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF403FFF83F000001FC007FFF
      F001FFF80F000001F8003FFF0000000007000001F8001FF8003C000003000001
      F8001FE0007F000001000001F8001FC0003F000000000001F8001F8000000000
      00000001F8001F800000000000000001F8001F800000000003000001F8003F80
      0000000003000001FC003F800000000003000001FE003F800002000003000001
      F8003F80001F000001000001F8003F80001F000001000001F8003F80001F0000
      00000001F8003F80001F000000000001F8003F80001F00003F000001F8001F80
      001F00003F000001F8001F80001F00003F000001F8003FC0001F00003F000001
      FC003FC0003F00003F000001FE007FE0007F00003F000001FF00FFF801FF0000
      3F000001FFFFFFFFFFFF00003FFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object ilMain16n: TImageList
    Left = 940
    Top = 168
    Bitmap = {
      494C010121002200040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000009000000001002000000000000090
      000000000000000000000000000000000000000000000A0A9A000A0A9A000000
      00000000000000000000000000000A0A9A000A0A9A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001F1FA0000A1DC2000A2ADE000A0A
      9A00AD561200AC5311000A0A9A000A22CD000A18B9001B118B00A1440D00A042
      0C009F3F0C009D3E0B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A9A000A2ADE000A2B
      DD000A0A9A000A0A9A000A26D2000A22CD000A0A9A00FBEDD500FBEBD100FBE9
      CD00FBE7C8009E400B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A0A9A000A2A
      DE000A2ADD000A29D9000A29D9000A0A9A00FCF1E000FCEFDA00FCEDD600FBEB
      D100FBEACE00A1430C0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BB6916000A0A
      9A000A2CE0000A2ADC000A0A9A00FCF5E700FCF3E400FCF1DF00FBEFDB00FCED
      D600FBEBD100A3470D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A0A9A000A2D
      E3000A2DE4000A2ADE000A2ADC000A0A9A00FBF5E800FBF3E400FCF1E000FBEF
      DB00FBEDD700A64B0E0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A9A000A2EE5000A2E
      E5000A0A9A000A0A9A000A2ADE000A2ADB000A0A9A00FBF5E900FCF4E400FBF1
      E100FCEFDC00A94F0F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A9A000A22CA000A0A
      9A00FCFCFC00FCFBFA000A0A9A000A1DC2000A0A9A00FCF7EE00FCF5E900FBF3
      E400FCF2E200AC51100000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001F178C00FCFC
      FC00FCFCFC00FCFCFC00FCFBF9002525A500FCF9F500FCF7F200FCF7EE00FBF6
      E900FBF3E500AD56110000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C77C1A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFAF800FCF9F500FBF8F200FCF7
      EE00FBF6EA00B05A120000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C97F1C00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFA00FCFBF800FCF9F600FCF8
      F200FCF7EF00B35E130000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CC821C00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFA00FCFBF900FCFA
      F600FCF8F300B662140000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CE851D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFB
      F900FCFAF700B966150000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CF861D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FCFBF800BC6A160000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000CF871D00CF87
      1D00CE861D00CC831C00CC821C00CA801B00C87D1B00C67A1A00C4771900C374
      1900C1721700BF6F170000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000A6B0A0000000000000000000000
      000083A683003A863B000F6E0F000A6B0A000A6B0A0013721300468B46009BB2
      9B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A6B0A000A6B0A0056915600237A
      24001A80200029AA380030BF44002FC042002BBD3C001FA22A00148719001070
      11003F883F00BFC4BF0000000000000000000000000000000000B25D1300AF59
      1200AD561200AC531100AA4F1000A84E0F00A54A0E00A4480D00A1440D00A042
      0C009F3F0C009D3E0B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A2450C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A6B0A0040CA5C00218928002DAC
      3F003DCF58003ACB520032BF47001E8F270011701200237B2300267D27001170
      11000A6B0A0023792300BBC1BB00000000000000000000000000B5611400FCF7
      EF00FBF6EB00FBF4E700FCF2E300FBF0DE00FBEFDA00FBEDD500FBEBD100FBE9
      CD00FBE7C8009E400B0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A74B0E00FBEBD100A246
      0D000000000000000000000000000000000000000000B7AFAF00835D5B00703C
      3800794A4600A695950000000000000000000000000000000000AD9F9F007A4E
      4B00713D380080565400B3A8A800000000000A6B0A0048D6670048D9670044D5
      620040D15C0034BD4900147415005C945C00B8C0B80000000000000000000000
      00008CAA8C001D761D0039833900000000000000000000000000B8651600FCF8
      F300FCF7EF00FCF6EC00FCF5E700FCF2E400FCF1E000FCEFDA00FCEDD600FBEB
      D100FBEACE00A1430C0000000000000000000000000000000000B86515000000
      000000000000000000000000000000000000AB511000FCEFDA00FCEDD600FBEB
      D100A3460D00000000000000000000000000B7AFAF0073444300C39E8300F2CA
      9400DCAA740089534200AD9D9A000000000000000000B0A2A200784B4800D7B2
      8C00F2C68E00CC9869007E4A4000B5AAAA000A6B0A004BD96B004BDC6B0047D8
      650040D05C00157617008CAA8C00000000000000000000000000000000000000
      000000000000BBC1BB00528F5300000000000000000000000000BB691600FCFA
      F700FCF8F400FCF7F000FCF7EC00FCF5E700FCF3E400FCF1DF00FBEFDB00FCED
      D600FBEBD100A3470D0000000000000000000000000000000000BB691600B965
      1600000000000000000000000000AF581100FCF3E400FCF1DF00FBEFDB00FCED
      D600FBEBD100A3460D00000000000000000085605F00C19E8500FCE1B500F9DB
      AC00F2C79000D09963008B5D4F000000000000000000875F5C00CEAC8E00FCE3
      BA00F7D4A500F0C28800C99362008A615A000A6B0A004EDC6F004EDF70004ADB
      690044D361000A6B0A0066996600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BE6D1700FCFB
      F900FCFAF700FCF8F400FBF7F100FCF6EC00FBF5E800FBF3E400FCF1E000FBEF
      DB00FBEDD700A64B0E0000000000000000000000000000000000BE6D1700FCFB
      F900B966150000000000B4601400FCF6EC00FBF5E800FBF3E400FCF1E000FBEF
      DB00FBEDD700A54A0E0000000000000000006E3F3E00F6DEBA00FCEDD300FCEC
      D200F9DEB400EDC18B00804A3800000000000000000071424100F4DFC100FCEE
      D800FCEBD100F7D6A800EABC840079463D000A6B0A0042C75E0042CA5F003FC7
      5A003CC4550034B849000A6B0A00669966000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C0721700FCFB
      FC00FCFBF900FCF9F700FCF9F500FCF7F100FCF6EC00FBF5E900FCF4E400FBF1
      E100FCEFDC00A94F0F0000000000000000000000000000000000BF701700FCFB
      FC00FCFBF900BA661600FCF9F500FCF7F100FCF6EC00FBF5E900FCF4E400FBF1
      E100FCEFDC00A84D0F00000000000000000074474600E6D0B700FCF7ED00FCF5
      EA00FCE9CB00E5C49B007E4D43000000000000000000784B4800E6D3C000FCF9
      F500FCF2E300FCE6C400E5C09600703F3B000A6B0A000A6B0A000A6B0A000A6B
      0A000A6B0A000A6B0A000A6B0A000A6B0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C3751900FCFC
      FC00FCFCFC00FCFBFA00FCFAF700FCF9F500FCF7F100FCF7EE00FCF5E900FBF3
      E400FCF2E200AC51100000000000000000000000000000000000C1741800FCFC
      FC00FCFCFC00C06A0A00BD670A00BB640A00B8610A00B65D0A00B3590A00FBF3
      E400FCF2E200AA500F000000000000000000977D7D007A4C4800D9C4B600FCF0
      DD00E1C6AB008E645B007B51500089686800896868007B5452008A625E00DFCE
      C100FCEFD900DCBFA200855A54006B3B3B000000000000000000000000000000
      0000000000000000000000000000000000000A6B0A000A6B0A000A6B0A000A6B
      0A000A6B0A000A6B0A000A6B0A000A6B0A000000000000000000C5791900FCFC
      FC00FCFCFC00FCFCFC00FCFBF900FCFAF700FCF9F500FCF7F200FCF7EE00FBF6
      E900FBF3E500AD56110000000000000000000000000000000000C4771900FCFC
      FC00FCFCFC00FCFCFC00FCFBF900FCFAF700FCF9F500FCF7F200FCF7EE00FBF6
      E900FBF3E500AC541100000000000000000000000000927676006C3C3C006B3B
      3B00794E4E00987E7E00C3C1C1009982820099828200C3C1C1009B8484007A51
      51006B3B3B007A5151009F8B8B006B3B3B000000000000000000000000000000
      000000000000000000000000000000000000000000000A6B0A004AD46A004FE1
      73004DDE6D0049DA670045D662000A6B0A000000000000000000C77C1A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFAF800FCF9F500FBF8F200FCF7
      EE00FBF6EA00B05A120000000000000000000000000000000000C77B1A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFAF800FCF9F500FBF8F200FCF7
      EE00FBF6EA00AF58120000000000000000000000000000000000B9B0B000784E
      4E008F707000C5C4C40000000000000000000000000000000000000000000000
      00000000000000000000000000006B3B3B000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A6B0A0050E0
      740050E274004DDE6E0049DA69000A6B0A000000000000000000C97F1C00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFA00FCFBF800FCF9F600FCF8
      F200FCF7EF00B35E130000000000000000000000000000000000C97E1B00FCFC
      FC00FCFCFC00C8740A00C6720A00C3700A00C16C0A00BF690A00BD650A00FCF8
      F200FCF7EF00B25C13000000000000000000000000000000000000000000C1BE
      BE00825D5D00815C5C00C0BBBB00000000000000000000000000000000000000
      00000000000000000000000000006B3B3B000000000055935600ABBAAB000000
      0000000000000000000000000000000000000000000083A683001778190053E2
      780054E57A0050E274004EDF6F000A6B0A000000000000000000CC821C00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFA00FCFBF900FCFA
      F600FCF8F300B662140000000000000000000000000000000000CB801C00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFA00FCFBF900FCFA
      F600FCF8F300B460130000000000000000000000000000000000000000000000
      0000C5C4C40092767600764B4B00B7AFAF00000000000000000000000000B6AD
      AD00C5C4C40000000000000000006B3B3B0000000000519052001371140075A0
      7500BDC3BD000000000000000000ADBBAD0051905200197B1E0051DB76005CED
      860059EA800055E67A0051E375000A6B0A000000000000000000CE851D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFB
      F900FCFAF700B966150000000000000000000000000000000000CC831C00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFB
      F900FCFAF700B763140000000000000000000000000000000000000000000000
      00000000000000000000A18D8D0070434300AA9B9B0000000000000000006F41
      4100BEB8B80000000000000000006B3B3B0000000000C3C5C300348537000A6B
      0A000A6B0A0018751A001270120018791A003BB0520062F08E0064F6910061F2
      8B003CB753000A6B0A004AD36A000A6B0A000000000000000000CF861D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FCFBF800BC6A160000000000000000000000000000000000CE851D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FCFBF800BA67160000000000000000000000000000000000000000000000
      0000000000000000000000000000AFA3A300724545008F707000A59292007043
      43000000000000000000000000006B3B3B000000000000000000C3C5C3005A95
      5C00147416002FA142004ED06F0069F898006BFC9B0060EB8A0042C05F001F81
      250031823200659965000A6B0A000A6B0A000000000000000000CF871D00CF87
      1D00CE861D00CC831C00CC821C00CA801B00C87D1B00C67A1A00C4771900C374
      1900C1721700BF6F170000000000000000000000000000000000CF871D00CE86
      1C00CD841D00CB811C00C97F1B00C87C1B00C67A1900C4771900C2741900C072
      1700BF6E1700BC6C170000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0BCBC00947878007E575700AA9B
      9B00000000000000000000000000000000000000000000000000000000000000
      0000A9B9A900619862002A822E000D6D0D000A6B0A0019751A00478C49000000
      0000000000000000000072A073000A6B0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000BD660A00B8610A00B35B0A00AF540A00AB4F
      0A00A74A0A00A3450A00A0400A00000000001122BF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001122BF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C16C0A00FBF3E400FBF1E100FBEFDE00FBEE
      DA00FBECD600FBEBD200A3450A00000000008AB4FC001122BF00000000000000
      0000B25D1300AF591200AD561200AC531100AA4F1000A84E0F00A54A0E00A448
      0D00A1440D00A0420C009F3F0C009D3E0B008AB4FC001122BF00000000000000
      000000000000000000000000000000000000BD660A00B8610A00B35B0A00AF54
      0A00AB4F0A00A74A0A00A3450A00A0400A006471720057575700595959005555
      5500515151004D4D4D0049494900444444003F3F3F003C3C3C00383838003434
      34002E2E2E002A2A2A0020202000293B3F000000000000000000000000000000
      0000000000000000000000000000C6720A00FBF5EA00FBF4E500FCF1E200FBF0
      DE00FBEEDA00FBECD700A74A0A00000000001122BF008AB4FC001122BF000000
      0000B5611400FCF7EF00FBF6EB00FBF4E700FCF2E300FBF0DE00FBEFDA00FBED
      D500FBEBD100FBE9CD00FBE7C8009E400B001122BF008AB4FC001122BF000000
      000000000000000000000000000000000000C16C0A00FBF3E400FBF1E100FBEF
      DE00FBEEDA00FBECD600FBEBD200A3450A00858989005D95990078D7E00074D5
      E1006FD3E00069D1DF0063CFDE0052B2BF004BABBA0053C8DC004EC5DB0047C3
      DA0041C0D9003CBED8003A8999001E2325000000000000000000000000000000
      0000BD660A00B8610A00B05D1700C9760A00FCF7EE00FCF6EB00FCF3E700FCF2
      E300FBF0DF00FBEFDB00AB4F0A0000000000000000001122BF008AB4FC001B25
      800038303B002A2A3F002A2A3F0047455600BFB8B500FCF2E400FCF1E000FCEF
      DA00FCEDD600FBEBD100FBEACE00A1430C00000000001122BF008AB4FC001B25
      800039384A002A2A3F002A2A3F0042415300995E1C00FBF5EA00FBF4E500FCF1
      E200FBF0DE00FBEEDA00FBECD700A74A0A00A0ADAD004C5C5D007DEFF80078F1
      FC0073EFFC006DEDFC0065E6F700191C1D001315150050D5EB004FE3FC004AE1
      FC0044DFFC003ED9F7003C525700304247000000000000000000000000000000
      0000C16C0A00FBF3E400EFE0D100CD7B0A00FCF8F300FCF7EF00FCF6EB00FCF4
      E700FCF3E400FBF1DF00AE540A000000000000000000000000001B247E002E2D
      410067566300B79A9F00BFACB0006E69760034334700BFB8B500FCF3E400FCF1
      DF00FBEFDB00FCEDD600FBEBD100A3470D0000000000000000001B247E002E2D
      410067566300B79A9F00BFACB0006E69760034314300BFB9B900FCF6EB00FCF3
      E700FCF2E300FBF0DF00FBEFDB00AB4F0A00C1C1C100858A8B00599599007CF2
      FC0076F0FC0071EEFC006BECFC004FAAB600479FAC0059E6FC0053E4FC004EE3
      FC0048E1FC004093A30030373900B4B5B5000000000000000000000000000000
      0000C6720A00FBF5EA00EFE2D500D1800A00FBF9F700FCF8F400FCF7F000FBF6
      EC00FBF4E800FCF2E400B45B0A00000000000000000000000000373648006553
      6100D1A5A500DEBFBF00EDDEDE00F7F4F400736F7C0044435400FBF5E800FBF3
      E400FCF1E000FBEFDB00FBEDD700A64B0E000000000000000000373648006553
      6100D1A5A500DEBFBF00EDDEDE00F7F4F400736F7C0044435500FCF7EF00FCF6
      EB00FCF4E700FCF3E400FBF1DF00AE540A0000000000A6B2B3005156560079E0
      E8007AF1FC0074EFFC006FEDFC005CC4D10058C6D5005EE7FC0058E5FC0051E4
      FC004BD1E900484F4F00495A5E00A64B0E0000000000BD660A00B8610A00B05D
      1700C9760A00FCF7EE00F0E4DB00D3830A00FCFBF900FCFAF700FCF9F400FCF7
      F100FBF6ED00FCF5E900B8610A00000000000000000000000000292A3E00AE87
      8C00CFA1A100DDBDBD00EAD7D700F2E7E700C4B7BC002A2A3F00FCF6EC00FBF5
      E900FCF4E400FBF1E100FCEFDC00A94F0F000000000000000000292A3E00AE87
      8C00CFA1A100DDBDBD00EAD7D700F2E7E700C4B7BC002A2A3F00FCF8F400FCF7
      F000FBF6EC00FBF4E800FCF2E400B45B0A0000000000000000008F9B9B005179
      7C007EF3FC0078F1FC0073EFFC00406469003C61650062E9FC005CE7FC0055E4
      FC004B7F880037454800FCEFDC00A94F0F0000000000C16C0A00FBF3E400EFE0
      D100CD7B0A00FCF8F300F0E5DE00D5870A00FCFCFC00FCFCFA00FCFAF700FCF9
      F500FBF8F100FBF6ED00BD660A00000000000000000000000000292A3F00C7B8
      BD00D1A6A600D2A9A900DFC1C100E3CACA00BCA5AA002A2A3F00FCF7F100FCF7
      EE00FCF5E900FBF3E400FCF2E200AC51100000000000000000002A2A3E00C7B8
      BD00D1A6A600D2A9A900DFC1C100E3CACA00BCA5AA002A2A3F00FCFAF700FCF9
      F400FCF7F100FBF6ED00FCF5E900B8610A000000000000000000B0B8B8006262
      62006EC9D0007DF2FC0077F0FC00405557003B4F510065EAFC0060E8FC0051C4
      D6004F50510078828400FCF2E200AC51100000000000C6720A00FBF5EA00EFE2
      D500D1800A00FBF9F700F0E6E200D6870A00D5860A00D3830A00D1800A00CD7B
      0A00CA760A00C5720A00C16C0A0000000000000000000000000035344600716C
      7900E9D0D000D1A6A600D1A6A600D6AEAE00695A67003C3C4D00FCF9F500FCF7
      F200FCF7EE00FBF6E900FBF3E500AD5611000000000000000000352E3900716C
      7900E9D0D000D1A6A600D1A6A600D6AEAE00695A67003C3C4E00FCFCFA00FCFA
      F700FCF9F500FBF8F100FBF6ED00BD660A0000000000000000000000000094A1
      A200516C6D0081F4FC007BF2FC00444F51003D45460069EBFC0063E9FC005676
      7C003E4C4E00FBF6E900FBF3E500AD56110000000000C9760A00FCF7EE00F0E4
      DB00D3830A00FCFBF900F0E7E500F0E7E200F0E5E000EFE4DC00F0E3D900B462
      17000000000000000000000000000000000000000000000000008A8A90002D2D
      4000706B7800C6B6BB00B08A8F00655361002F2E4100B2B2B800FCFAF800FCF9
      F500FBF8F200FCF7EE00FBF6EA00B05A12000000000000000000885419002D2D
      4000706B7800C6B6BB00B08A8F00655361002E2C3E0099641900D3830A00D180
      0A00CD7B0A00CA760A00C5720A00C16C0A00000000000000000000000000B7BA
      BA007678780062ACB0007FF3FC00484B4B00424242006BE6F60062B7C2005254
      54009D9FA000FCF7EE00FBF6EA00B05A120000000000CD7B0A00FCF8F300F0E5
      DE00D5870A00FCFCFC00FCFCFA00FCFAF700FCF9F500FBF8F100FBF6ED00BD66
      0A00000000000000000000000000000000000000000000000000000000008A8A
      9000352F3B002A2A3F002A2A3E003B3A4B00B0B0B700FCFCFC00FCFCFA00FCFB
      F800FCF9F600FCF8F200FCF7EF00B35E13000000000000000000C9760A00ABA8
      A800383647002A2A3E002A2A3E003A384900A9A3A500F0E5E000EFE4DC00F0E3
      D900B46217000000000000000000000000000000000000000000000000000000
      000097A5A600535F60007DE4EB004F4F4F004A4A4A006CD4E0005E6A6C004D5D
      5F00FCF9F600FCF8F200FCF7EF00B35E130000000000D1800A00FBF9F700F0E6
      E200D6870A00D5860A00D3830A00D1800A00CD7B0A00CA760A00C5720A00C16C
      0A00000000000000000000000000000000000000000000000000000000000000
      0000CC821C00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FA00FCFBF900FCFAF600FCF8F300B66214000000000000000000CD7B0A00FCF8
      F300F0E5DE00D5870A00FCFCFC00FCFCFA00FCFAF700FCF9F500FBF8F100FBF6
      ED00BD660A000000000000000000000000000000000000000000000000000000
      0000C4C4C4007F8687005E929500617C7E005A7173006CA5AB004E575700BDBD
      BD00FCFBF900FCFAF600FCF8F300B662140000000000D3830A00FCFBF900F0E7
      E500F0E7E200F0E5E000EFE4DC00F0E3D900B462170000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CE851D00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFBFB00FCFBF900FCFAF700B96615000000000000000000D1800A00FBF9
      F700F0E6E200D6870A00D5860A00D3830A00D1800A00CD7B0A00CA760A00C572
      0A00C16C0A000000000000000000000000000000000000000000000000000000
      0000CE851D00A2ABAC005B5D5E007DDEE4007BE1E9005E61610068757700FCFC
      FC00FCFBFB00FCFBF900FCFAF700B966150000000000D5870A00FCFCFC00FCFC
      FA00FCFAF700FCF9F500FBF8F100FBF6ED00BD660A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CF861D00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFB00FCFBF800BC6A16000000000000000000D3830A00FCFB
      F900F0E7E500F0E7E200F0E5E000EFE4DC00F0E3D900B4621700000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CF861D00FCFCFC008D9797006A8D8F0060848700515B5C00FCFCFC00FCFC
      FC00FCFCFC00FCFCFB00FCFBF800BC6A160000000000D6870A00D5860A00D383
      0A00D1800A00CD7B0A00CA760A00C5720A00C16C0A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CF871D00CF871D00CE861D00CC831C00CC821C00CA801B00C87D1B00C67A
      1A00C4771900C3741900C1721700BF6F17000000000000000000D5870A00FCFC
      FC00FCFCFA00FCFAF700FCF9F500FBF8F100FBF6ED00BD660A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CF871D00CF871D00B0B5B500949697006E7172009AA0A000C87D1B00C67A
      1A00C4771900C3741900C1721700BF6F17000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6870A00D586
      0A00D3830A00D1800A00CD7B0A00CA760A00C5720A00C16C0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080800000808000000000
      00000000000000000000000000000000000035AAD5003BC4EF002AA4D4000D74
      AA00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B25D1300AF59
      1200AD561200AC531100AA4F1000A84E0F00A54A0E00A4480D00A1440D00A042
      0C009F3F0C009D3E0B0000000000000000000000000000000000B25D1300AF59
      1200AD561200AC531100AA4F1000A84E0F00A54A0E00A4480D00A1440D00A042
      0C009F3F0C009D3E0B0000000000000000000000000000000000B25D1300AF59
      1200AD561200AC531100AA4F1000A84E0F000080000080800000808000008080
      00009F3F0C009D3E0B0000000000000000004FD7F9000DC9F90033D8FB0028AB
      DB000D74AA00AC531100AA4F1000A84E0F00A54A0E00A4480D00A1440D00A042
      0C009F3F0C009D3E0B0000000000000000000000000000000000B5611400FCF7
      EF00FBF6EB00FBF4E700FCF2E300FBF0DE00FBEFDA00FBEDD500FBEBD100FBE9
      CD00FBE7C8009E400B0000000000000000000000000000000000B5611400FCF7
      EF00FBF6EB00FBF4E700FCF2E300FBF0DE00FBEFDA00FBEDD500FBEBD100FBE9
      CD00FBE7C8009E400B0000000000000000000000000000000000B5611400FCF7
      EF00FBF6EB00FBF4E700FCF2E3008080000080800000FBEDD500008000008080
      0000FBE7C8009E400B0000000000000000006EE0FC001FBEF1000ACCFC0030D7
      FC0022ACDE000D74AA00FCF2E300FBF0DE00FBEFDA00FBEDD500FBEBD100FBE9
      CD00FBE7C8009E400B0000000000000000000000000000000000B8651600FCF8
      F300FCF7EF00FCF6EC00FCF5E700FCF2E400FCF1E000FCEFDA00FCEDD600FBEB
      D100FBEACE00A1430C0000000000000000000000000000000000B8651600FCF8
      F300FCF7EF00FCF6EC00FCF5E700FCF2E400FCF1E000FCEFDA00FCEDD600FBEB
      D100FBEACE00A1430C0000000000000000000000000000000000B8651600FCF8
      F300FCF7EF00FCF6EC000080000000800000FCF1E000FCEFDA00FCEDD6008080
      000000800000A1430C0000000000000000002386B0006EE0FC001AB9EF000ACC
      FC002AD6FC001BABDF000D74AA00FCF2E400FCF1E000FCEFDA00FCEDD600FBEB
      D100FBEACE00A1430C0000000000000000000000000000000000BB691600FCFA
      F700FCF8F400FCF7F000FCF7EC00FCF5E700FCF3E400FCF1DF00FBEFDB00FCED
      D600FBEBD100A3470D0000000000000000000000000000000000BB691600FCFA
      F700FCF8F400FCF7F000FCF7EC00FCF5E700FCF3E400FCF1DF00FBEFDB00FCED
      D600FBEBD100A3470D0000000000000000000000000000000000BB691600FCFA
      F700FCF8F400FCF7F000FCF7EC00FCF5E700FCF3E400FCF1DF00FBEFDB000080
      000080800000A3470D000000000000000000000000002386B0006EE0FC0017BB
      F1000ACCFC0023D4FC0015A8DE000D74AA001974A5002386B000F6EBDA00FCED
      D600FBEBD100A3470D0000000000000000000000000000000000BE6D1700FCFB
      F900FCFAF700FCF8F400FBF7F100FCF6EC00FBF5E800FBF3E400FCF1E000FBEF
      DB00FBEDD700A64B0E0000000000000000000000000000000000BE6D1700FCFB
      F900FCFAF700FCF8F400FBF7F100FCF6EC00FBF5E800FBF3E400FCF1E000FBEF
      DB00FBEDD700A64B0E0000000000000000000000000000000000BE6D1700FCFB
      F900FCFAF700FCF8F400FBF7F100FCF6EC00FBF5E800FBF3E400FCF1E000FBEF
      DB008080000000800000000000000000000000000000000000002386B0006EE0
      FC0012BEF30019CBF9003CCAF6003BD0F90024C8F80024C8F8002386B000F3EA
      D800FBEDD700A64B0E0000000000000000000000000000000000C0721700FCFB
      FC0035AC4B0031A645002DA03F002A9A3A0027953400238F2E001F8929001B85
      2400FCEFDC00A94F0F0000000000000000000000000000000000C0721700FCFB
      FC0035AC4B0031A645002DA03F002A9A3A0027953400238F2E001F8929001B85
      2400FCEFDC00A94F0F0000000000000000000000000000000000C0721700FCFB
      FC0035AC4B0031A645002DA03F002A9A3A0027953400238F2E001F8929001B85
      2400008000008080000000000000000000000000000000000000C07217002386
      B0006EE0FC0054D5F90056DBFC003FD5FB00147FB30024C8F80024C8F8002386
      B000FCEFDC00A94F0F0000000000000000000000000000000000C3751900FCFC
      FC005EEA89004CCD6C0045C463004FD3730053D877004FD272004CCD6C0048C7
      6600FCF2E200AC51100000000000000000000000000000000000C3751900FCFC
      FC005EEA89004CCD6C0045C463004FD3730053D877004FD272004CCD6C0048C7
      6600FCF2E200AC51100000000000000000000000000000000000C3751900FCFC
      FC005EEA89004CCD6C0045C463004FD3730053D877004FD272004CCD6C0048C7
      6600FCF2E2008080000000800000000000000000000000000000C3751900FCFC
      FC002386B0006EE0FC0052D8FB00147FB3008FBFD300147FB30024C8F8002386
      B000FCF2E200AC51100000000000000000000000000000000000C5791900FCFC
      FC00A2B98C007FCF870085B97D009D9E7700A0B3870075E18D006BFC9B0079CF
      8100FBF3E500AD56110000000000000000000000000000000000C5791900FCFC
      FC00A2B98C007FCF870085B97D009D9E7700A0B3870075E18D006BFC9B0079CF
      8100FBF3E500AD56110000000000000000000000000000000000C5791900FCFC
      FC00A2B98C007FCF870085B97D009D9E7700A0B3870075E18D006BFC9B0079CF
      8100FBF3E5000080000080800000000000000000000000000000C5791900FCFC
      FC002B83AC0071DEF900147FB3008FC0D700FCF9F500FCF7F200147FB3002386
      B000FBF3E500AD56110000000000000000000000000000000000C77C1A00FCFC
      FC00E1AAA400E1ABAB00E1ABAB00E1ABAB00C8937300B1805500B3815200CF8D
      3200FBF6EA00B05A120000000000000000000000000000000000C77C1A00FCFC
      FC00E1AAA400E1ABAB00E1ABAB00E1ABAB00C8937300B1805500B3815200CF8D
      3200FBF6EA00B05A120000000000000000000000000000000000C77C1A00FCFC
      FC00E1AAA400E1ABAB00E1ABAB00E1ABAB00C8937300B1805500B3815200CF8D
      3200FBF6EA00B05A120000800000808000000000000000000000C77C1A00FCFC
      FC002386B00067C4E10071DEF900147FB300FCFAF800FCF9F500FBF8F2002386
      B000FBF6EA00B05A120000000000000000000000000000000000C97F1C00FCFC
      FC00D2872700E8C3AC00EFD5D500DDA56700CF7E0F00D69A4B00D0831900CE7B
      0A00FCF7EF00B35E130000000000000000000000000000000000C97F1C00FCFC
      FC00D2872700E8C3AC00EFD5D500DDA56700CF7E0F00D69A4B00D0831900CE7B
      0A00FCF7EF00B35E130000000000000000000000000000000000C97F1C00FCFC
      FC00D2872700E8C3AC00EFD5D500DDA56700CF7E0F00D69A4B00D0831900CE7B
      0A00FCF7EF00B35E130000000000008000000000000000000000C97F1C00FCFC
      FC00FCFCFC002386B00055BDDD0071DEF900147FB300FCFBF800FCF9F600FCF8
      F200FCF7EF00B35E130000000000000000000000000000000000CC821C00FCFC
      FC00BE660A00BF6A1000CA853B00BE660A00BE660A00BE660A00BE660A00BE66
      0A00FCF8F300B662140000000000000000000000000000000000CC821C00FCFC
      FC00BE660A00BF6A1000CA853B00BE660A00BE660A00BE660A00BE660A00BE66
      0A00FCF8F300B662140000000000000000000000000000000000CC821C00FCFC
      FC00BE660A00BF6A1000CA853B00BE660A00BE660A00BE660A00BE660A00BE66
      0A00FCF8F300B662140000000000808000000000000000000000CC821C00FCFC
      FC00FCFCFC00FCFCFC002386B0002A7EA8003585AC002386B000FCFBF900FCFA
      F600FCF8F300B662140000000000000000000000000000000000CE851D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFB
      F900FCFAF700B966150000000000000000000000000000000000CE851D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFB
      F900FCFAF700B966150000000000000000000000000000000000CE851D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFB
      F900FCFAF700B966150000000000000000000000000000000000CE851D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFB
      F900FCFAF700B966150000000000000000000000000000000000CF861D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FCFBF800BC6A160000000000000000000000000000000000CF861D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FCFBF800BC6A160000000000000000000000000000000000CF861D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FCFBF800BC6A160000000000000000000000000000000000CF861D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FCFBF800BC6A160000000000000000000000000000000000CF871D00CF87
      1D00CE861D00CC831C00CC821C00CA801B00C87D1B00C67A1A00C4771900C374
      1900C1721700BF6F170000000000000000000000000000000000CF871D00CF87
      1D00CE861D00CC831C00CC821C00CA801B00C87D1B00C67A1A00C4771900C374
      1900C1721700BF6F170000000000000000000000000000000000CF871D00CF87
      1D00CE861D00CC831C00CC821C00CA801B00C87D1B00C67A1A00C4771900C374
      1900C1721700BF6F170000000000000000000000000000000000CF871D00CF87
      1D00CE861D00CC831C00CC821C00CA801B00C87D1B00C67A1A00C4771900C374
      1900C1721700BF6F170000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A6B0A0000000000000000000000
      000083A683003A863B000F6E0F000A6B0A000A6B0A0013721300468B46009BB2
      9B000000000000000000000000000000000000000000A9A9C0003D3FAA004748
      AD00BDBDC5000000000000000000000000000000000000000000000000000000
      0000C3C3C7004C4DAC000E0E9C006363B1000000000000000000000000000000
      00000A6B0A000000000000000000000000000000000000000000000000000000
      00000A6B0A00000000000000000000000000000000000000000020547700116E
      9B00F3E5BE00E0CAAC00CEB6A000BDA49D00B69E9E00B69E9E00B69F9F00B69F
      9F00B69F9F00B69F9F004199B700244E6E000A6B0A000A6B0A0056915600237A
      24001A80200029AA380030BF44002FC042002BBD3C001FA22A00148719001070
      11003F883F00BFC4BF00000000000000000000000000191BA2000A21C800101D
      B8003234A800C3C3C7000000000000000000000000000000000000000000C3C3
      C7003B3CA9001117A9000A1ABC000F0F9D000000000000000000000000000A6B
      0A0030C143000A6B0A0000000000000000000000000000000000000000000A6B
      0A0030C143000A6B0A000000000000000000000000000000000020547700106D
      9B000A0A9A00FCE6AD00FCE09E00FCD88F00F1C88200DBB27E00C6A18000B294
      8A00AB909000AB909000439AB800244E6E000A6B0A0040CA5C00218928002DAC
      3F003DCF58003ACB520032BF47001E8F270011701200237B2300267D27001170
      11000A6B0A0023792300BBC1BB0000000000000000001012A1000A32EC000A32
      E900111EB5003D3FAA0000000000000000000000000000000000C3C3C7003B3C
      A9001118AB000A1FC5000A1ABC0011129E0000000000000000000A6B0A003DCE
      560037C84D0031C144000A6B0A000000000000000000000000000A6B0A003DCE
      560037C84D0031C144000A6B0A0000000000000000000000000020557700116E
      9B000A0A9A000A0A9A00FCDC9800FCD58800FCCF7A00FCC86B00FCC05B00F2B3
      5200A0818100A0818100459CB900244E6E000A6B0A0048D6670048D9670044D5
      620040D15C0034BD4900147415005C945C00B8C0B80000000000000000000000
      00008CAA8C001D761D003983390000000000000000004042AC001120BA000A32
      EC000A30E800121BB1004A4BAC000000000000000000C3C3C7003B3CA9001119
      AD000A23CC000A1EC2001112A0008989B900000000000A6B0A000A6B0A000A6B
      0A003DCE57000A6B0A000A6B0A000A6B0A00000000000A6B0A000A6B0A000A6B
      0A003DCE57000A6B0A000A6B0A000A6B0A0000000000000000001F5578001371
      9D000A0A9A001744FB000A0A9A00FCD28200FCCC7400FCC56400FCBE5400F0AE
      4B009572720095727200479DBA00244E6E000A6B0A004BD96B004BDC6B0047D8
      650040D05C00157617008CAA8C00000000000000000000000000000000000000
      000000000000BBC1BB00528F53000000000000000000C1C1C6003335A9001120
      BA000A32EC000A30E6001118AB005859AF00C3C3C7003B3CA900111AAE000A27
      D2000A22CB001113A2007D7DB700000000000000000000000000000000000A6B
      0A0044D561000A6B0A0000000000000000000000000000000000000000000A6B
      0A0044D561000A6B0A0000000000000000000A0A9A000A0A9A000A0A9A000A0A
      9A000A0A9A001E4BFB001744FB000A0A9A00FCC96D00FCC15D00FCBB4E00EFAB
      43008963630089636300499FBB00244E6E000A6B0A004EDC6F004EDF70004ADB
      690044D361000A6B0A0066996600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C1C1C6003335
      A9001120BA000A32EC000A2FE4001116A7002021A200111AB0000A2AD9000A25
      D2001316A6006B6CB30000000000000000000000000000000000000000000A6B
      0A000A6B0A000A6B0A0000000000000000000000000000000000000000000A6B
      0A000A6B0A000A6B0A0000000000000000000A0A9A005174FB00466BFB003C62
      FB00315AFB002752FB001E4BFB001744FB000A0A9A00FCBF5600FCB84700EDA6
      3C007E5454007E5454004BA1BC00244E6E000A6B0A0042C75E0042CA5F003FC7
      5A003CC4550034B849000A6B0A00669966000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C1C1
      C6003335A9001120BA000A32EB000A2EE3000A21CA000A2DE1000A2ADC001217
      A7005E5FB1000000000000000000000000000000000000000000000000000000
      00006B3B3B000000000000000000000000000000000000000000000000000000
      00006B3B3B000000000000000000000000000A0A9A005C7CFB005174FB00466B
      FB003C62FB00315AFB002852FB001E4BFB001744FB000A0A9A00FCB44000ECA1
      340074464600744646004DA3BD00244E6E000A6B0A000A6B0A000A6B0A000A6B
      0A000A6B0A000A6B0A000A6B0A000A6B0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C1C1C6003335A9001121BC000A32EC000A31E8000A2FE4001119AD005051
      AE00000000000000000000000000000000000000000000000000000000000000
      00006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B000000000000000000000000000A0A9A006684FB005C7CFB005174
      FB00476AFB003C62FB00315AFB002852FB000A0A9A00FCB8490040AFBA003FAE
      BA006B3B3B006B3B3B004FA5BE00244E6E000000000000000000000000000000
      0000000000000000000000000000000000000A6B0A000A6B0A000A6B0A000A6B
      0A000A6B0A000A6B0A000A6B0A000A6B0A000000000000000000000000000000
      0000C3C3C7003B3DAA001120BA000A34EF000A32EB000A2FE5001012A1008E8E
      BB00000000000000000000000000000000000000000000000000000000000000
      00006B3B3B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000A0A9A000A0A9A000A0A9A000A0A
      9A000A0A9A00476BFB003C62FB000A0A9A00FCBC5100FCB542000AFBFB0071D1
      CA006B3B3B006B3B3B0051A7BF00244E6E000000000000000000000000000000
      000000000000000000000000000000000000000000000A6B0A004AD46A004FE1
      73004DDE6D0049DA670045D662000A6B0A00000000000000000000000000C3C3
      C7003B3DAA001120B8000A37F6000A36F3000A2BDE000A32EA000A29D7001113
      A0009B9BBD000000000000000000000000000000000000000000000000000000
      00000A6B0A000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021587B001F7F
      A8000A0A9A005174FB000A0A9A00FCC05A00FCB94B00FCB23C00FCAC2D00EB99
      22006B3B3B006B3B3B0053AAC000244E6E000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A6B0A0050E0
      740050E274004DDE6E0049DA69000A6B0A000000000000000000C3C3C7003B3D
      AA001120BA000A3AFB000A39F9001024C3000F109E001120B8000A32EA000A27
      D3001314A000A4A4C00000000000000000000000000000000000000000000A6B
      0A0030C143000A6B0A0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000021597B002182
      AA000A0A9A000A0A9A00FCC46200FCBD5300FCB64400FCAF3500FCA92700E28E
      1D006B3B3B006B3B3B0056ACC200244E6E000000000055935600ABBAAB000000
      0000000000000000000000000000000000000000000083A683001778190053E2
      780054E57A0050E274004EDF6F000A6B0A0000000000C3C3C7003B3DAA001120
      BA000A3AFB000A3BFC000E27CE002325A500B6B6C3003335A9001120B8000A32
      E9000A25D0001516A100ADADC2000000000000000000000000000A6B0A003DCE
      560037C84D0031C144000A6B0A00000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000022597C002485
      AC000A0A9A00FCC86B00FCC15C00FCBA4D00FCB33D00EDA12F00D1862800B66E
      25006B3B3B006B3B3B0059AEC400244E6E0000000000519052001371140075A0
      7500BDC3BD000000000000000000ADBBAD0051905200197B1E0051DB76005CED
      860059EA800055E67A0051E375000A6B0A00000000004446AC001120BA000A3A
      FB000A3BFC000D28D3001D1FA300B6B6C30000000000C1C1C6003335A900111F
      B8000A31E9000C22CA002223A500C3C3C700000000000A6B0A000A6B0A000A6B
      0A003DCE57000A6B0A000A6B0A000A6B0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000225A7C002687
      AD00FCCC7400FCC56400FBBD5500E9A74400CA873800B7743000AE6B2B009F5D
      2A006B3B3B006B3B3B005BB1C600244E6E0000000000C3C5C300348537000A6B
      0A000A6B0A0018751A001270120018791A003BB0520062F08E0064F6910061F2
      8B003CB753000A6B0A004AD36A000A6B0A00000000001216A5000A3AFA000A3B
      FC000A2ADA00181AA300ADADC200000000000000000000000000C1C1C6003335
      A900111FB8000A31E8001417A600A4A4C0000000000000000000000000000A6B
      0A0044D561000A6B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000215B7D002989
      AF00FAC76C00E4AC5800C1874600AF743C00A66937009D60320095572F00874E
      31006B3B3B006B3B3B005EB4C700244E6E000000000000000000C3C5C3005A95
      5C00147416002FA142004ED06F0069F898006BFC9B0060EB8A0042C05F001F81
      250031823200659965000A6B0A000A6B0A00000000001012A1000A34F0000A2D
      E1001416A100A6A6C0000000000000000000000000000000000000000000C1C1
      C6003538A9001316A5001E20A300C1C1C6000000000000000000000000000A6B
      0A000A6B0A000A6B0A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000225B7E002C8D
      B2003192B6003798B9003C9CBD0041A2BF0045A6C3004BACC6004FB0CA0055B6
      CD005ABBD1005FBFD4005DB7CB00244E6E000000000000000000000000000000
      0000A9B9A900619862002A822E000D6D0D000A6B0A0019751A00478C49000000
      0000000000000000000072A073000A6B0A0000000000797AB7001011A0001213
      A000A0A0BE000000000000000000000000000000000000000000000000000000
      000000000000A2A2C000C1C1C600000000000000000000000000000000000000
      00006B3B3B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000244E6E00244E
      6E00244E6E00244E6E00244E6E00244E6E00244E6E00244E6E00244E6E00244E
      6E00244E6E00244E6E00244E6E00244E6E00C3C5C700327FA5001275A4001275
      A40000000000C3C5C70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B2B8BE00788CA2007A90A400000000000000000066819A00788DA100B6BB
      C00000000000000000000000000000000000A4A5C0003238B0006265B6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B00000000002678A30032A6D10043C4ED0039B9
      E6001275A40000000000C3C5C700000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007289
      9F00184F7C000B74A300164D7A0000000000B8BDC1000D4979000A74A3001C50
      7C007A8FA2000000000000000000000000003C43B100749FF7002038CE005C60
      B500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006B3B3B00BEA8A700FCF8F200FCF5
      E800FBF0DE00FBECD200FBE7C8006B3B3B00BEA8A700FCF8F200FCF5E800FBF0
      DE00FBECD200FBE7C8006B3B3B00000000001275A40054D9FA0018C9F8002DD7
      FC003DCCF5001275A40000000000C3C5C7000000000000000000000000000000
      00000000000000000000000000000000000000000000C1C2C5004C6E8D000E6C
      9A001FBFE70028DBFC000E74A20075869F00627995000B7CAC000BD6FC000AB4
      E3000A6496005A7794000000000000000000363AAE00B0CAF3007AA8FC002038
      CE005C60B5000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006B3B3B00BEA8A800FCFAF700FCF7
      F000FCF3E600FCF0DB00FCEBD1006B3B3B00BEA8A800FCFAF700FCF7F000FCF3
      E600FCF0DB00FCEBD1006B3B3B00000000001275A40063DCF90017B8EF000ACC
      FC0022D3FC0036CBF5001275A40000000000C3C5C70000000000000000000000
      00000000000000000000000000000000000000000000C2C3C60047688C00117A
      A70040DCFC0044DBFC0034C2E800116F9B001276A40025C7F1001AD2FC000DD0
      FC000A71A100567294000000000000000000BDBDC500343AAE00B0CCF3007AA8
      FC002038CE005B5FB50000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006B3B3B00BEA9A800FCFCFC00FCFA
      F700FCF7EE00FCF3E400FCEFDA006B3B3B00BEA9A800FCFCFC00FCFAF700FCF7
      EE00FCF3E400FCEFDA006B3B3B0000000000000000001275A4004FD0F50013BC
      F2000ACCFC0021D3FC0030C9F5001275A40000000000C3C5C700000000000000
      000000000000000000000000000000000000000000000000000000000000385B
      830034ACD10062E2FC0062E2FC005FE5FC0055E4FC0043DBFC0031D9FC00149B
      C9004363870000000000000000000000000000000000BBBBC5003237AE00B2CF
      F5007AA8FC002038CE005B5FB500000000000000000000000000000000000000
      0000000000000000000000000000000000006B3B3B00BEA9A900BEA8A800BEA8
      A700BEA8A600BEA7A400BEA6A2006B3B3B00BEA9A900BEA8A800BEA8A700BEA8
      A600BEA7A400BEA6A2006B3B3B000000000000000000000000001275A40046CE
      F50011BBF2000ACCFC001FD3FC0029C8F5001275A40000000000C3C5C7000000
      0000000000000000000000000000000000008699A900758AA000929FAE00415E
      83003DA4C80086EEFC0068D1ED002D95BC002A98BF004FCFF1004CE2FC001993
      BF004B668700909FAD0071889D0095A2B2000000000000000000B8B8C5003237
      AE00B3D0F5007AA8FC001B2686006A697E0000000000A6A6A6007C7C7C008585
      8500B6B6B6000000000000000000000000006B3B3B00DD8D3D00D8863100D47E
      2700D1761B00CE711300CC6C0C006B3B3B00DD8D3D00D8863100D47E2700D176
      1B00CE711300CC6C0C006B3B3B00000000000000000000000000000000001275
      A4003ECDF50010BBF2000ACCFC001ED2FC0023C5F5001275A4001275A400116E
      9D002678A30076A0B50000000000000000002D5982001778A300146F98003593
      B9008EE5F7007DD1E800114E7B005B75910056728F000E517F004FD0F00041D3
      F6001587B4000B6A99000A72A2003F668800000000000000000000000000B6B6
      C3003035AD00798EB500423B4500312424002C26260046303000684444005C3C
      3C00372B2B0055515100C1C1C100000000006B3B3B00DC8E3E00D9863200D57E
      2700D1771C00CF711400CC6C0C006B3B3B00DC8E3E00D9863200D57E2700D177
      1C00CF711400CC6C0C006B3B3B00000000000000000000000000000000000000
      00001275A40037CBF5000EBAF1000ACCFC0023D1FB002ABDF0002AB4EA0021B1
      E7001195D2000A73AB002E7DA300000000001A527E0068D7F5008CECFC009FEE
      FC00B3F5FC003A8BAE006F839C0000000000000000005F7893002491B90057E3
      FC003ADAFC001DD7FC000AB5E5002F5B82000000000000000000000000000000
      0000B4B4C300232143009A989800251B1B009A717100CA999900D1A7A700DAB7
      B700C0A5A5006A4C4C00403B3B00000000006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B00000000000000000000000000000000000000
      0000000000001275A4002ECAF50016B9EF004CD1F70051DAFC0040D6FC002ED3
      FC001DD0FC000CB3EE000A75AE006B9BB20018527D0078DEF700A0F2FC00B6F4
      FC00CCF8FC003C87A8007C8EA20000000000000000006A809900238BB20062E4
      FC0044DDFC0028DBFC000CB7E6002F5B82000000000000000000000000000000
      000000000000B6B6BA00221A1A00A0777700CC9B9B00CE9F9F00DAB7B700E4CD
      CD00EBD9D900DBC8C8005B4444007A7878006B3B3B00BEA8A700FCF8F200FCF5
      E800FBF0DE00FBECD200FBE7C8006B3B3B00BEA8A700FCF8F200FCF5E800FBF0
      DE00FBECD200FBE7C8006B3B3B00000000000000000000000000000000000000
      000000000000000000001275A40056DAFB0064DEFC0052DAFC0040D6FB0033B3
      D90032BDE00011CFFC000A9CDD001B739F00275780003393B800358AAC0068AF
      CB00D9F7FB00AFD1E0001B4D79007A8CA10073879E00154D7A0065CDE80062DF
      F900239CC5001082AE000C86B500396186000000000000000000000000000000
      00000000000095939300533C3C00CC9B9B00CC9B9B00D1A5A500DEBFBF00EBDA
      DA00F7F2F200F2E8E800A68C8C00393434006B3B3B00BEA8A800FCFAF700FCF7
      F000FCF3E600FCF0DB00FCEBD1006B3B3B00BEA8A800FCFAF700FCF7F000FCF3
      E600FCF0DB00FCEBD1006B3B3B00000000000000000000000000000000000000
      000000000000000000001275A4006DD9F40065DEFC0050D9FC0021AAD5001D74
      A0001C74A00021ADD2000ABCF3000B71A500748BA2005673900073889E003555
      7E0087BAD000FCFCFC00AED0DE003A81A4003384A70075CAE30087EEFC0034A1
      C7003C5B810073889E0052728F008598A9000000000000000000000000000000
      000000000000646060007E5C5C00CC9B9B00CC9B9B00D0A4A400DDBEBE00E9D5
      D500F3E8E800EFE2E200BFA7A700383030006B3B3B00BEA9A800FCFCFC00FCFA
      F700FCF7EE00FCF3E400FCEFDA006B3B3B00BEA9A800FCFCFC00FCFAF700FCF7
      EE00FCF3E400FCEFDA006B3B3B00000000000000000000000000000000000000
      000000000000000000001E759F0070D1EC0066DEFC0030AAD5002077A0000000
      0000C3C5C7001F75A10010AAD7000C7BAB000000000000000000000000004864
      890072AEC700E6FBFC00E4FCFC00D8FCFC00BEFAFC009AEDFC007EE8FC002A98
      BE00546D90000000000000000000000000000000000000000000000000000000
      000000000000676565007B5A5A00EFE2E200E5D0D000CC9B9B00D6B1B100E0C4
      C400E5CFCF00E4CCCC00B29797003B3333006B3B3B00BEA9A900BEA8A800BEA8
      A700BEA8A600BEA7A400BEA6A2006B3B3B00BEA9A900BEA8A800BEA8A700BEA8
      A600BEA7A400BEA6A2006B3B3B00000000000000000000000000000000000000
      000000000000000000003F85A80063BDDB0067DFFC002CA7D90019729F00BFC3
      C70000000000C3C5C7001F75A100106E9D000000000000000000677E9B001B74
      9C00B4EDF800C6F5FC00B5E9F7004E99B9004A9FBF0085E3F80073E4FC0053D7
      F7000B5885007488A30000000000000000000000000000000000000000000000
      00000000000096969600503E3E00DBBFBF00EFE1E100D9B7B700D0A4A400D5AD
      AD00D8B5B500D7B3B3008E6D6D00494444006B3B3B00DD8D3D00D8863100D47E
      2700D1761B00CE711300CC6C0C006B3B3B00DD8D3D00D8863100D47E2700D176
      1B00CE711300CC6C0C006B3B3B00000000000000000000000000000000000000
      00000000000000000000A2B6BF002A86AE0072D8F30052D6FA001B93CC001C74
      A000BFC3C70000000000C3C5C7006999B20000000000BEC0C400315880002882
      A8009EE9F900B5F8FC00358AAC00546B8D00456185002B93B8006DEBFC004AD6
      F7001174A1004064860000000000000000000000000000000000000000000000
      000000000000000000003632320086646400E4CCCC00ECDCDC00DEBFBF00CC9B
      9B00CC9B9B00AE858500433737009D9D9D006B3B3B00DC8E3E00D9863200D57E
      2700D1771C00CF711400CC6C0C006B3B3B00DC8E3E00D9863200D57E2700D177
      1C00CF711400CC6C0C006B3B3B00000000000000000000000000000000000000
      00000000000000000000000000006999B2002D89B20062C8E4004FD9FB0021A8
      D9001C74A000BFC3C70000000000000000000000000000000000BDC0C300506F
      8E0010618D0044A0C000114E7A00C1C3C500B0B6BD000B5382002599BF000C5A
      880059769300C1C3C50000000000000000000000000000000000000000000000
      00000000000000000000ADADAD00332E2E007A5D5D00B4949400D0AAAA00B38A
      8A00936F6F0046393900706F6F00000000006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B00000000000000000000000000000000000000
      0000000000000000000000000000000000008BAABA002076A1001375A400107A
      AC00106E9D006697B10000000000000000000000000000000000000000000000
      000095A2B0004E6C8D0050738F000000000000000000486B8D0052708E009AA6
      B200000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000B8B8B8004E4D4D003C3636003B3333003A34
      34003E3A3A009493930000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A00000000000A0A
      0A000A0A0A000A0A0A000A0A0A000A0A0A000000000000000000000000000000
      00008699A900758AA000929FAE00415E83003DA4C80086EEFC0068D1ED002D95
      BC002A98BF004FCFF1004CE2FC001993BF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000AB4F0A00A94D
      0A00A74B0A000A0A0A00121212000B0B0B000A0A0A000A0A0A00A0400A000A0A
      0A0015151500222222000A0A0A000A0A0A006B3B3B006B3B3B006B3B3B006B3B
      3B002D5982001778A300146F98003593B9008EE5F7007DD1E800114E7B005B75
      910056728F000E517F004FD0F00041D3F6000000000000000000AB4F0A00A94D
      0A00A74B0A00A64A0A00A4480A00A3450A00A2430A00A1420A00A0400A009E3E
      0A009D3D0A009C3C0A0000000000000000006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B000000000000000000AC510A00FCF7
      EF00FBF6EB007549490074444000EBC8A3009F674D0070414000FBEBD1007549
      4900A0725E00EFE1D2009F674D00704140006B3B3B00BDA6A200FAF5EB00FAF3
      E8001A527E0068D7F5008CECFC009FEEFC00B3F5FC003A8BAE006F839C00F9E7
      C900F9E6C5005F7893002491B90057E3FC000000000000000000AC510A00FCF7
      EF00FBF6EB00FBF4E700FCF2E300FBF0DE00FBEFDA00FBEDD500FBEBD100FBE9
      CD00FBE7C8009D3E0A0000000000000000006B3B3B00BDA6A200FAF5EB00FAF3
      E800F9F2E4006B3B3B00BCA09600F9ECD900F9EBD500FAEAD000FAE8CD00F9E7
      C900F9E6C500F9E4C200FBE4BF006B3B3B000000000000000000AE540A00FCF8
      F300FCF7EF008461610074444000EAC5A000865043007D565500FCEDD6008461
      610085554C00F5E5D400865043007D5655006B3B3B00BEA7A300FCF7EF00FBF6
      EB0018527D0078DEF700A0F2FC00B6F4FC00CCF8FC003C87A8007C8EA200FCE9
      CC00FBE8C8006A809900238BB20062E4FC000000000000000000AE540A00FCF8
      F300FCF7EF00FCF6EC00FCF5E700FCF2E400FCF1E000FCEFDA00FCEDD600FBEB
      D100FBEACE009E3F0A0000000000000000006B3B3B00BEA7A300FCF7EF00FBF6
      EB00FCF4E8006B3B3B00BDA29900FCEFDC00FBEED800FBECD300FBEAD000FCE9
      CC00FBE8C800FBE6C400FBE5C1006B3B3B000000000000000000AF550A00FCFA
      F700FCF8F4009A82820074444000E1B488007443400093777700AA4F0A009A82
      820074444000F5E4D30074433E00937777006B3B3B00BEA7A400FCF7F100FBF6
      EE00275780003393B800358AAC0068AFCB00D9F7FB00AFD1E0001B4D79007A8C
      A10073879E00154D7A0065CDE80062DFF9000000000000000000AF550A00FCFA
      F700FCF8F400B75F0A00B45C0A00B1580A00AF540A00AC510A00AA4F0A00FCED
      D600FBEBD1009F410A0000000000000000006B3B3B00BEA7A400FCF7F100FBF6
      EE00FBF6EA006B3B3B00BEA39A00FBF1DF00FBEFDA00FBEED600FCEBD100FBE9
      CE00FCE9CB00FBE7C600FBE5C3006B3B3B000000000000000000B1580A00FCFB
      F900FCFAF700B7AEAE006E3E3E006B3B3B006B3B3B000B0B0B000A0A0A000E0D
      0D006C3C3C006B3B3B006C3B3B00000000006B3B3B00BEA8A600FCF8F400FBF7
      F000748BA2005673900073889E0035557E0087BAD000FCFCFC00AED0DE003A81
      A4003384A70075CAE30087EEFC0034A1C7000000000000000000B1580A00FCFB
      F900FCFAF700FCF8F400FBF7F100FCF6EC00FBF5E800FBF3E400FCF1E000FBEF
      DB00FBEDD700A1430A0000000000000000006B3B3B00BEA8A600FCF8F400FBF7
      F000FBF7EC006B3B3B00BEA49B00BDA39900BEA29700BEA09500BEA09200BD9F
      9000BD9E8E00BE9D8B00BE9C8A006B3B3B000000000000000000B35A0A00FCFB
      FC00FCFBF900FCF9F7006C3B3B006B3B3B006B3B3B00141010000A0A0A002316
      14006C3B3B006C3B3B006C3B3B00000000006B3B3B00BEA8A600FCF9F600FCF8
      F200FBF7EF006B3B3B006B3B3B004864890072AEC700E6FBFC00E4FCFC00D8FC
      FC00BEFAFC009AEDFC007EE8FC002A98BE000000000000000000B35A0A00FCFB
      FC00FCFBF900FCF9F700FCF9F500FCF7F100FCF6EC00FBF5E900FCF4E400FBF1
      E100F8E6D000A2450A0000000000000000006B3B3B00BEA8A600FCF9F600FCF8
      F200FBF7EF006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B000000000000000000B55C0A00FCFC
      FC00FCFCFC00C06A0A000A0A0A00C4C4C400696969000A0A0A00B3590A000A0A
      0A00C4C4C400696969000A0A0A00000000006B3B3B00BEA8A700FCFAF700FCF9
      F400FCF8F2006B3B3B00677E9B001B749C00B4EDF800C6F5FC00B5E9F7004E99
      B9004A9FBF0085E3F80073E4FC0053D7F7000000000000000000B55C0A00FCFC
      FC00FCFCFC00C06A0A00BD670A00BB640A00B8610A00B65D0A00B3590A00F6E2
      CC00F3DAC300A4480A0000000000000000006B3B3B00BEA8A700FCFAF700FCF9
      F400FCF8F2006B3B3B00BDA59E00FCF4E500FCF2E300FCF0DF00FCEFDA00FCED
      D600FCECD100FBEACE00FBE9CA006B3B3B000000000000000000B65E0A00FCFC
      FC00FCFCFC00FCFCFC000A0A0A000A0A0A000A0A0A001D1D1D00F3DAC3000A0A
      0A000A0A0A000A0A0A001D1D1D00000000006B3B3B00BEA8A800FCFBF800FCF9
      F700FCF8F300BEC0C400315880002882A8009EE9F900B5F8FC00358AAC00546B
      8D00456185002B93B8006DEBFC004AD6F7000000000000000000B65E0A00FCFC
      FC00FCFCFC00FCFCFC00FCFBF900FCFAF700F8EFE400F6E5D300F3DAC300F0D1
      B500F0D1B500A64A0A0000000000000000006B3B3B00BEA8A800FCFBF800FCF9
      F700FCF8F3006B3B3B00BEA5A000FCF4E900FBF4E400FCF2E100FCF0DD00FCEE
      D900FCEDD400FBEBD100FCE9CD006B3B3B000000000000000000B7600A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00AF560A00AE530A00AC510A00AB4F
      0A00AA4E0A00A84C0A0000000000000000006B3B3B00BEA9A800FCFBFA00FCFA
      F700FCF9F5006B3B3B00BDC0C300506F8E0010618D0044A0C000114E7A00C1C3
      C500B0B6BD000B5382002599BF000C5A88000000000000000000B7600A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00AF560A00AE530A00AC510A00AB4F
      0A00AA4E0A00A84C0A0000000000000000006B3B3B00BEA9A800FCFBFA00FCFA
      F700FCF9F5006B3B3B00BDA6A100FCF6EB00FCF4E700FCF2E400FCF1DF00FBEF
      DB00FBEED700FCECD200FBEBCF006B3B3B000000000000000000B9620A00FCFC
      FC00FCFCFC00C8740A00C6720A00C3700A00B1570A00FCFBF800FCF4EB00F7D9
      BD00AB4F0A000000000000000000000000006B3B3B00BEA9A900BEA8A800BEA8
      A700BEA8A6006B3B3B00BEA6A200BEA6A00095A2B0004E6C8D0050738F00BDA2
      9800BDA19600486B8D0052708E009AA6B2000000000000000000B9620A00FCFC
      FC00FCFCFC00C8740A00C6720A00C3700A00B1570A00FCFBF800FCF4EB00F7D9
      BD00AB4F0A000000000000000000000000006B3B3B00BEA9A900BEA8A800BEA8
      A700BEA8A6006B3B3B00BEA6A200BEA6A000BEA49E00BEA49C00BEA39A00BDA2
      9800BDA19600BEA09300BE9F90006B3B3B000000000000000000BA630A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00B25A0A00FCF4EB00F7D9BD00AD53
      0A00000000000000000000000000000000006B3B3B00FACA9900F8C49100F6BF
      8700F2B77D00EEAF7200E9A76500E59F5800E1964B00DD8D3D00D8863100D47E
      2700D1761B00CE711300CC6C0C006B3B3B000000000000000000BA630A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00B25A0A00FCF4EB00F7D9BD00AD53
      0A00000000000000000000000000000000006B3B3B00FACA9900F8C49100F6BF
      8700F2B77D00EEAF7200E9A76500E59F5800E1964B00DD8D3D00D8863100D47E
      2700D1761B00CE711300CC6C0C006B3B3B000000000000000000BB650A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00B45C0A00F7D9BD00B1590A000000
      0000000000000000000000000000000000006B3B3B00FAC99900F8C59200F6BF
      8900F2B87E00EEB07400EAA86600E69F5900E1974C00DC8E3E00D9863200D57E
      2700D1771C00CF711400CC6C0C006B3B3B000000000000000000BB650A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00B45C0A00F7D9BD00B1590A000000
      0000000000000000000000000000000000006B3B3B00FAC99900F8C59200F6BF
      8900F2B87E00EEB07400EAA86600E69F5900E1974C00DC8E3E00D9863200D57E
      2700D1771C00CF711400CC6C0C006B3B3B000000000000000000BC660A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00B65E0A00B55D0A00000000000000
      0000000000000000000000000000000000006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B000000000000000000BC660A00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00B65E0A00B55D0A00000000000000
      0000000000000000000000000000000000006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B3B006B3B
      3B006B3B3B006B3B3B006B3B3B006B3B3B000000000000000000BD670A00BC66
      0A00BC650A00BA640A00B9620A00B8620A00B7600A0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BD670A00BC66
      0A00BC650A00BA640A00B9620A00B8620A00B7600A0000000000000000000000
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
      0000000000000000000000000000000000006B3B3B0000000000000000000000
      000000000000000000009B3B0A009B3B0A009B3B0A009B3B0A00000000000000
      00000000000000000000000000006B3B3B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A00000000000A0A
      0A000A0A0A000A0A0A000A0A0A000A0A0A000000000000000000000000000000
      000000000000000000009B3B0A00DD9B3600DE9F3C009B3B0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000A0A9A000000
      0000000000000000000000000000000000000000000000000000B25D1300AF59
      1200AD561200AC531100AA4F1000A84E0F00A54A0E00A4480D00A1440D00A042
      0C009F3F0C009D3E0B0000000000000000000000000000000000B25D1300AF59
      1200AD5612000A0A0A00121212000B0B0B000A0A0A000A0A0A00A1440D000A0A
      0A0015151500222222000A0A0A000A0A0A006B3B3B0000000000000000000000
      000000000000000000009B3B0A00DFA03E00E0A446009B3B0A00000000000000
      00000000000000000000000000006B3B3B000000000000000000000000000000
      0000000000009B3B0A009B3B0A009B3B0A00993B0D000A0A9A000A2FE4000A0A
      9A00000000000000000000000000000000000000000000000000B5611400FCF7
      EF00FBF6EB00FBF4E700FCF2E300FBF0DE00FBEFDA00FBEDD500FBEBD100FBE9
      CD00FBE7C8009E400B0000000000000000000000000000000000B5611400FCF7
      EF00FBF6EB007549490074444000EBC8A3009F674D0070414000FBEBD1007549
      4900A0725E00EFE1D2009F674D00704140000000000000000000000000000000
      000000000000000000009B3B0A00E0A54800E1A84F009B3B0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009B3B0A00FAEAC200E9B171000A0A9A000A31E7000A30E5000A2F
      E4000A0A9A000000000000000000000000000000000000000000B8651600FCF8
      F300FCF7EF00FCF6EC00FCF5E700FCF2E400FCF1E000FCEFDA00FCEDD600FBEB
      D100FBEACE00A1430C0000000000000000000000000000000000B8651600FCF8
      F300FCF7EF008461610074444000EAC5A000865043007D565500FCEDD6008461
      610085554C00F5E5D400865043007D5655006B3B3B0000000000000000000000
      000000000000000000009B3B0A00E2A95100E3AC58009B3B0A00000000000000
      00000000000000000000000000006B3B3B000000000000000000000000000000
      0000000000009B3B0A00FAE9C0000A0A9A000A32E9000A31E8000A31E7000A30
      E5000A2FE4000A0A9A0000000000000000000000000000000000BB691600FCFA
      F700FCF8F400FCF7F000FCF7EC00FCF5E700FCF3E400FCF1DF00FBEFDB00FCED
      D600FBEBD100A3470D0000000000000000000000000000000000BB691600FCFA
      F700FCF8F4009A82820074444000E1B488007443400093777700FBEFDB009A82
      820074444000F5E4D30074433E00937777000000000000000000000000000000
      000000000000000000009B3B0A00E3AD5A00E4B162009B3B0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009B3B0A000A0A9A000A33EC000A33EB000A32E9000A31E8000A30
      E6000A30E5000A2FE4000A0A9A00000000000000000000000000BE6D1700FCFB
      F900FCFAF700FCF8F400FBF7F100FCF6EC00FBF5E800FBF3E400FCF1E000FBEF
      DB00FBEDD700A64B0E0000000000000000000000000000000000BE6D1700FCFB
      F900FCFAF700B7AEAE006E3E3E006B3B3B006B3B3B000B0B0B000A0A0A000E0D
      0D006C3C3C006B3B3B006C3B3B00B2A7A7006B3B3B0000000000000000000000
      000000000000000000009B3B0A00E4B26300E5B56A009B3B0A00000000000000
      00000000000000000000000000006B3B3B000000000000000000000000000000
      0000C3B6B0000A0A9A000A0A9A000A0A9A000A0A9A000A32EA000A32E9000A31
      E8000A0A9A000A0A9A000A0A9A000A0A9A000000000000000000C0721700FCFB
      FC0035AC4B0031A645002DA03F002A9A3A0027953400238F2E001F8929001B85
      2400FCEFDC00A94F0F0000000000000000000000000000000000C0721700FCFB
      FC0035AC4B0031A645006C3B3B006B3B3B006B3B3B00141010000A0A0A002316
      14006C3B3B006C3B3B006C3B3B000000000000000000000000006B3B3B000000
      00006B3B3B00000000009B3B0A00E5B66C00E6BA74009B3B0A00000000006B3B
      3B00000000006B3B3B0000000000000000000000000000000000000000000000
      0000A8644100C5835500FADEB100F7D6A5000A0A9A000A33EC000A32EA000A32
      E9000A0A9A000000000000000000000000000000000000000000C3751900FCFC
      FC005EEA89004CCD6C0045C463004FD3730053D877004FD272004CCD6C0048C7
      6600FCF2E200AC51100000000000000000000000000000000000C3751900FCFC
      FC005EEA89004CCD6C000A0A0A00C4C4C400696969000A0A0A004CCD6C000A0A
      0A00C4C4C400696969000A0A0A00000000006B3B3B00000000006B3B3B006B3B
      3B006B3B3B006B3B3B009B3B0A00E7BB7500E8BF7D009B3B0A006B3B3B006B3B
      3B006B3B3B006B3B3B00000000006B3B3B00000000000000000000000000B897
      8700A54E2000F6D4A800FBE2B700F6D19D000A0A9A000A34ED000A33EB000A32
      EA000A0A9A000000000000000000000000000000000000000000C5791900FCFC
      FC00A2B98C007FCF870085B97D009D9E7700A0B3870075E18D006BFC9B0079CF
      8100FBF3E500AD56110000000000000000000000000000000000C5791900FCFC
      FC00A2B98C007FCF87000A0A0A000A0A0A000A0A0A001D1D1D006BFC9B000A0A
      0A000A0A0A000A0A0A001D1D1D000000000000000000000000006B3B3B000000
      00006B3B3B00000000009B3B0A00E8BF7F00E9C286009B3B0A00000000006B3B
      3B00000000006B3B3B0000000000000000000000000000000000C5BEBB00A049
      1D00DDA87600F9E3C200F9DBAD00F4CB96000A0A9A000A34EE000A34ED000A33
      EB000A0A9A000000000000000000000000000000000000000000C77C1A00FCFC
      FC00E1AAA400E1ABAB00E1ABAB00E1ABAB00C8937300B1805500B3815200CF8D
      3200FBF6EA00B05A120000000000000000000000000000000000C77C1A00FCFC
      FC00E1AAA400E1ABAB00E1ABAB00E1ABAB00C8937300B1805500B3815200CF8D
      3200FBF6EA00B05A120000000000000000006B3B3B0000000000000000000000
      000000000000000000009B3B0A00EAC38700EBC78F009B3B0A00000000000000
      00000000000000000000000000006B3B3B000000000000000000AE755900B86F
      4000F6D6AC00FBE9CD00F7D5A400F2C68F000A0A9A000A0A9A000A0A9A000A0A
      9A000A0A9A000000000000000000000000000000000000000000C97F1C00FCFC
      FC00D2872700E8C3AC00EFD5D500DDA56700CF7E0F00D69A4B00D0831900CE7B
      0A00FCF7EF00B35E130000000000000000000000000000000000C97F1C00FCFC
      FC00D2872700E8C3AC00EFD5D500DDA56700CF7E0F00D69A4B00D0831900CE7B
      0A00FCF7EF00B35E130000000000000000000000000000000000000000000000
      000000000000000000009B3B0A00EBC89100ECCB98009B3B0A00000000000000
      00000000000000000000000000000000000000000000BDA79B009F451600EBBC
      8400FAE9D100FBE8CB00F6D09C00EFC18700E9B27200D4975800A7653C009B44
      1900C5BEBB000000000000000000000000000000000000000000CC821C00FCFC
      FC00BE660A00BF6A1000CA853B00BE660A00BE660A00BE660A00BE660A00BE66
      0A00FCF8F300B662140000000000000000000000000000000000CC821C00FCFC
      FC00BE660A00BF6A1000CA853B00BE660A00BE660A00BE660A00BE660A00BE66
      0A00FCF8F300B66214000000000000000000CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A009B3B0A009B3B0A00EDCC9900EED0A1009B3B0A009B3B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00C7C4C300A4532B00CD8E5B00F5D5
      AA00FBF5E900FAE2BE00F3CB9500EDBC8000E7AD6A00DF9C5500B8743D00924D
      2B00AE7254000000000000000000000000000000000000000000CE851D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFB
      F900FCFAF700B966150000000000000000000000000000000000CE851D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFBFB00FCFB
      F900FCFAF700B96615000000000000000000CC6B0A0000000000000000000000
      0000000000009B3B0A009B3B0A00EED1A300F0D4AB009B3B0A009B3B0A000000
      0000000000000000000000000000CC6B0A00B3856F00AC5E3000EFC18700FAEE
      DE00FCF9F500F7D6A900F1C58D00EBB77800E4A86200DF994E00C17939009B58
      2E0093411B00C0ADA40000000000000000000000000000000000CF861D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FCFBF800BC6A160000000000000000000000000000000000CF861D00FCFC
      FC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FB00FCFBF800BC6A16000000000000000000CC6B0A0000000000000000000000
      0000000000009B3B0A009B3B0A00F0D5AC00F1D9B3009B3B0A009B3B0A000000
      0000000000000000000000000000CC6B0A009D3E0F009B3B0A009B3B0A009B3B
      0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009A3B0B00983B
      0E00973B0F00A65B360000000000000000000000000000000000CF871D00CF87
      1D00CE861D00CC831C00CC821C00CA801B00C87D1B00C67A1A00C4771900C374
      1900C1721700BF6F170000000000000000000000000000000000CF871D00CF87
      1D00CE861D00CC831C00CC821C00CA801B00C87D1B00C67A1A00C4771900C374
      1900C1721700BF6F17000000000000000000CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C5C4
      C400AA9B9B008D6C66007D5149006B3B3B006B3B3B0070423F00855F5C00AEA0
      A000000000000000000000000000000000000000000000000000000000000000
      0000C2C4C500BDC0C400277E2600C3C4C600A4B6A400458A4600127113000A6B
      0A000A6B0A001A751B0060976200BBC1BB006B3B3B0000000000000000000000
      000000000000000000009B3B0A009B3B0A009B3B0A009B3B0A00000000000000
      00000000000000000000000000006B3B3B006B3B3B0000000000000000000000
      00008699A900758AA000929FAE00415E83003DA4C80086EEFC0068D1ED002D95
      BC002A98BF004FCFF1004CE2FC001993BF00000000000000000000000000967A
      7600824F3C00AE702F00C6812A00DA8E1A00D5860A00C17714009F6023007645
      3D00967B7A0000000000000000000000000000000000BEC2C3007EA3AA005094
      A8003C96B4007FBED700277E260018761B001374170025A2350032BF45002CB8
      3E001C972500117B14000A6B0A00137213000000000000000000000000000000
      000000000000000000009B3B0A00DD9B3600DE9F3C009B3B0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00002D5982001778A300146F98003593B9008EE5F7007DD1E800114E7B005B75
      910056728F000E517F004FD0F00041D3F6000000000000000000000000008762
      5B00BF813D00E6A54A00E5A34600E29C3700DC912100D4850B00C47A1200AD6A
      1D006E3F3D00C5C3C3000000000000000000A4ADB4004E96A50077E0E6006CF0
      FC004CE8FC0087EBFC00277E260054E579003CCA57003DCF5700269D33001270
      1300569256007CA37C006A996A00237A23006B3B3B0000000000000000000000
      000000000000000000009B3B0A00DFA03E00E0A446009B3B0A00000000000000
      00000000000000000000000000006B3B3B006B3B3B0000000000000000000000
      00001A527E0068D7F5008CECFC009FEEFC00B3F5FC003A8BAE006F839C000000
      0000000000005F7893002491B90057E3FC000000000000000000000000008359
      5400CE935400F0B46B00EEB26500E8A85000DD97330084503B00995F2B00B972
      17006F3F3D00C3C0C0000000000000000000417B950084F1F900A1FCFC007DEF
      FC0060E4FC0098EAFC00277E260054E5790046D763002AA63A002A822D00B3C5
      C500C5C5C6000000000000000000000000000000000000000000000000000000
      000000000000000000009B3B0A00E0A54800E1A84F009B3B0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000018527D0078DEF700A0F2FC00B6F4FC00CCF8FC003C87A8007C8EA2000000
      0000000000006A809900238BB20062E4FC00000000000000000000000000855D
      5700CF976200F7C38A00F5BE7E00E8AC5F0088564300875E580088543A00BC74
      16006D3D3C000000000000000000000000003F94AD0099F7FC0097ECF9006BDE
      F7004BD3F6008AE1F800277E260054E5790054E5790054E57900247E2800277E
      2600277E2600277E2600277E2600277E26006B3B3B0000000000000000000000
      000000000000000000009B3B0A00E2A95100E3AC58009B3B0A00000000000000
      00000000000000000000000000006B3B3B006B3B3B0000000000000000000000
      0000275780003393B800358AAC0068AFCB00D9F7FB00AFD1E0001B4D79007A8C
      A10073879E00154D7A0065CDE80062DFF9000000000000000000000000009376
      7500AC785700F7C28700F2BB7B008F5E4D00A3838100E9DED50077463D00AB67
      1E007A4F4A000000000000000000000000004B9DB20087E9F70083EBF70066E7
      FA0045DFFB006CE2FC00277E2600277E2600277E2600277E2600277E26001273
      130054E5790054E5790054E57900277E26000000000000000000000000000000
      000000000000000000009B3B0A00E3AD5A00E4B162009B3B0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000748BA2005673900073889E0035557E0087BAD000FCFCFC00AED0DE003A81
      A4003384A70075CAE30087EEFC0034A1C700000000000000000000000000BBB4
      B40074464200BB8F6100405B70000E4D7C000A4B7B0046769A0050414F008952
      3300998180000000000000000000000000003B8BA70082EFF90096FBFC0078EF
      FC005BE5FC0068E3FC00A6E8F700BEEEFA00AFE6F600C7E9F400CBE3DC00277E
      2B003AB34F0054E5790054E57900277E26006B3B3B0000000000000000000000
      000000000000000000009B3B0A00E4B26300E5B56A009B3B0A00000000000000
      00000000000000000000000000006B3B3B006B3B3B0000000000000000000000
      000000000000000000009B3B0A004864890072AEC700E6FBFC00E4FCFC00D8FC
      FC00BEFAFC009AEDFC007EE8FC002A98BE000000000000000000000000000000
      0000A49DA000154F7C003782B1005BB6E60058B2E3003A88B80017507D003947
      6100C1BEBE000000000000000000000000003D8FA90096F6FC009EF1FA0073E2
      F70052D6F70074DBF800237E280071AC7B008EBF9A00549C5C00157517003DB7
      55005FF0880052DF750054E57900277E26000000000000000000000000006B3B
      3B00000000006B3B3B009B3B0A00E5B66C00E6BA74009B3B0A006B3B3B000000
      00006B3B3B000000000000000000000000000000000000000000000000000000
      00000000000000000000677E9B001B749C00B4EDF800C6F5FC00B5E9F7004E99
      B9004A9FBF0085E3F80073E4FC0053D7F700000000000000000000000000BBBF
      C20019578500317DAD0074CEFC0074CFFC0070CDFC0067C7F7004FA5D5001B55
      8100859CAD000000000000000000000000004C9DB2008CECF90080E6F60064E3
      F80043DBF90065DFFB001A791E000A6B0A001C87260044C2620063F08F005EE9
      87003DB656001575170019751A00277E26006B3B3B00000000006B3B3B006B3B
      3B006B3B3B006B3B3B009B3B0A00E7BB7500E8BF7D009B3B0A006B3B3B006B3B
      3B006B3B3B006B3B3B00000000006B3B3B006B3B3B0000000000000000000000
      000000000000BEC0C400315880002882A8009EE9F900B5F8FC00358AAC00546B
      8D00456185002B93B8006DEBFC004AD6F7000000000000000000000000007291
      A7000A4B7B00418BBB0081D1FC0082D2FC007CD1FC0074CEFC0066C5F6003F8C
      B90031658B000000000000000000000000003C8FAA0080ECF8008FFAFC0072EE
      FC0058E4FC0052DFFC007FDFF00077B3860027812A000A6B0A000A6B0A001775
      1A004B8E4E00A6B7A60000000000277E26000000000000000000000000006B3B
      3B00000000006B3B3B009B3B0A00E8BF7F00E9C286009B3B0A006B3B3B000000
      00006B3B3B000000000000000000000000000000000000000000000000000000
      00000000000000000000BDC0C300506F8E0010618D0044A0C000114E7A00C1C3
      C500B0B6BD000B5382002599BF000C5A88000000000000000000000000004172
      95000A5485001A5E8D002B709E00195E8D00195E8D00276E9D003A88B8004397
      C7000F4F7E000000000000000000000000003A8BA60092F5FB00B4FBFC009AF7
      FC0085F2FC0072EDFC006AE8FC0073E6FB007FE4F9007FDAF20077CDE7006C92
      AF00BDBDC0000000000000000000000000006B3B3B0000000000000000000000
      000000000000000000009B3B0A00EAC38700EBC78F009B3B0A00000000000000
      00000000000000000000000000006B3B3B006B3B3B0000000000000000000000
      000000000000000000009B3B0A00EAC3870095A2B0004E6C8D0050738F000000
      000000000000486B8D0052708E009AA6B2000000000000000000000000003C6F
      92000A6999000E5F8F000A6C9C000A76A7000A72A2000A6394000B5B8B000D50
      8100135180000000000000000000000000004F9DB000ADFCFC00A0FCFC008AF7
      FC007AF1FC006BECFC005BE7FC004CE1FC003CDEFC002CDAFC0018D2F9001867
      9500BBBBBE000000000000000000000000000000000000000000000000000000
      000000000000000000009B3B0A00EBC89100ECCB98009B3B0A00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000009B3B0A00EBC89100ECCB98009B3B0A00000000000000
      0000000000000000000000000000000000000000000000000000000000006185
      A0000A6394000A8ABB000A8FBF000A8BBC000A82B2000A77A8000A6C9C000A63
      9400185683000000000000000000000000005DB1BB00A6FCFC0099FBFC008BF7
      FC007BF1FC006BECFC005BE7FC004BE1FC003BDCFC002AD7FC0019DFFC001685
      B200BBBBBE00000000000000000000000000CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A009B3B0A009B3B0A00EDCC9900EED0A1009B3B0A009B3B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A009B3B0A009B3B0A00EDCC9900EED0A1009B3B0A009B3B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00000000000000000000000000A9B3
      BC00105180000A87B8000A9BCC000A90C0000A85B5000A79AA000A6E9E000D55
      85006C8BA3000000000000000000000000005497A4009FFCFB00A0FCFC008CF8
      FC007BF1FC006BECFC005BE7FC004BE1FC003BDDFC002BDEFC0019D9FC003070
      9500C3C4C400000000000000000000000000CC6B0A0000000000000000000000
      0000000000009B3B0A009B3B0A00EED1A300F0D4AB009B3B0A009B3B0A000000
      0000000000000000000000000000CC6B0A00CC6B0A0000000000000000000000
      0000000000009B3B0A009B3B0A00EED1A300F0D4AB009B3B0A009B3B0A000000
      0000000000000000000000000000CC6B0A000000000000000000000000000000
      00006F8FA500115583000A76A7000A86B6000A82B2000A6C9C000F5685003568
      8E00C3C5C600000000000000000000000000AAB6BB0057AAAD0084E3E3008CF8
      FB0081F7FC0071F5FC0060F0FC004EE8FC003BDFFC0024BFE20032789F00A5A8
      AF0000000000000000000000000000000000CC6B0A0000000000000000000000
      0000000000009B3B0A009B3B0A00F0D5AC00F1D9B3009B3B0A009B3B0A000000
      0000000000000000000000000000CC6B0A00CC6B0A0000000000000000000000
      0000000000009B3B0A009B3B0A00F0D5AC00F1D9B3009B3B0A009B3B0A000000
      0000000000000000000000000000CC6B0A000000000000000000000000000000
      0000000000009BAAB6003C6F9200125280000A4B7B00235D87007491A6000000
      00000000000000000000000000000000000000000000C2C5C6008CB2B3005CA7
      AE004EAAB80045ADC2003EA7C2003F97B4005189A4008194A500C0C1C3000000
      000000000000000000000000000000000000CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00CC6B
      0A00CC6B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A009B3B0A00CC6B
      0A00CC6B0A00CC6B0A00CC6B0A00CC6B0A00424D3E000000000000003E000000
      2800000040000000900000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF009E7F0000000000000003000000000000
      8003000000000000C003000000000000C003000000000000C003000000000000
      80030000000000008003000000000000C003000000000000C003000000000000
      C003000000000000C003000000000000C003000000000000C003000000000000
      C003000000000000FFFF000000000000700FFFFFFFFFFFFF0003C003FFDFFFFF
      0001C003FF8F83C10071C003DF07018001F9C003CE03018001FFC003C4030180
      00FFC003C003018000FFC003C0030000FF00C003C0038000FF80C003C003C3FE
      FFC0C003C003E1FE9F80C003C003F0E68600C003C003FC668000C003C003FE0E
      C000C003C003FF0FF01CFFFFFFFFFFFFFE017FFF7FFFFFFFFE0130003F000000
      FE0110001F000000F001800080000000F001C000C0000000F001C000C0008000
      8001C000C000C0008001C000C000C0008001C000C000E000800FC000C000E000
      800FE000C007F000800FF000C007F000807FF000C007F000807FF000C03FF000
      807FF000C03FF000FFFFFFFFC03FFFFFFFFFFFFFFF9F0FFFC003C003C0030003
      C003C003C0030003C003C003C0030003C003C003C0038003C003C003C003C003
      C003C003C003C003C003C003C001C003C003C003C001C003C003C003C000C003
      C003C003C002C003C003C003C002C003C003C003C003C003C003C003C003C003
      C003C003C003C003FFFFFFFFFFFFFFFF700F87F0F7F7C000000383E0E3E3C000
      000183C0C1C1C000007181808080C00001F98001E3E3000001FFC003E3E30000
      00FFE007F7F7000000FFF00FF0070000FF00F00FF7FF0000FF80E007F7FFC000
      FFC0C003E3FFC0009F808001C1FFC0008600808080FFC000800081C0E3FFC000
      C00083E0E3FFC000F01C87F9F7FFC0000BFFF18F1FFF000105FFE1070FFF0001
      02FF800307FF0001017F800303FF000180BFE00781FF0001C05F0000C0870001
      E0030000E0010001F0010180F0010001F8000180F8000001FC000000F8000001
      FC000000F8000001FC10E007F8000001FC08C003F8000001FC048003FC000001
      FE03C003FC010001FF03F18FFE03FFFFF820F000FFFFFFFFC0000000C0030000
      C0000000C0030000C0000000C0030000C0000000C0030000C0010000C0030000
      C0010000C0030000C0010000C0030000C0010000C0030000C0030000C0030000
      C0070000C0070000C00F0000C00F0000C01F0000C01F0000C03F0000C03F0000
      C07FFFFFC07FFFFFFFFFFFFFFFFFFFFF7C3EFFFFFFFFF820FC3FFFDFC003C000
      7C3EF80FC003C000FC3FF807C003C0007C3EF803C003C000FC3FF801C003C000
      7C3EF000C003C001D42BF007C003C0014002E007C003C001D42BC007C003C003
      7C3EC007C003C003FC3F8007C003C00300000007C003C003781E0003C003C003
      781E0003C003C0030000FFFFFFFFFFFFE00FF0007C3E7000E0078000FC3FF000
      E00300007C3E7018E0030007FC3FF018E00700007C3E7000E0070000FC3FF000
      E00700007C3E7C00F0070000E817FC00E007000040027800E0070002E817FC00
      E00700077C3E7C18E0070007FC3FFC3FE007000700000000E0070007781E781E
      F007000F781E781EF81F801F0000000000000000000000000000000000000000
      000000000000}
  end
  object ilMain24u: TImageList
    Height = 24
    Width = 24
    Left = 944
    Top = 268
    Bitmap = {
      494C01010C000E00040018001800FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000600000006000000001002000000000000090
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
      0000000000006969690069696900696969006969690069696900000000006969
      6900696969006969690069696900696969000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C1C1C100ADADAD00AEAEAE000000000000000000A7A7A700ACACAC00C2C2
      C200000000000000000000000000000000000000000000000000000000009D9D
      9D009D9D9D009C9C9C009B9B9B009B9B9B009A9A9A009A9A9A00999999009999
      990099999900696969006E6E6E006A6A6A006969690069696900979797006969
      6900707070007777770069696900696969000000000095959500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000095959500000000000000000095959500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000095959500000000000000000095959500000000000000
      000000000000000000000000000000000000000000000000000000000000ABAB
      AB008E8E8E00989898008D8D8D0000000000C3C3C3008B8B8B00989898008E8E
      8E00ADADAD000000000095959500000000000000000000000000000000009F9F
      9F00F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4F400F3F3F300F2F2
      F200F1F1F1009A9A9A0099999900DCDCDC00ABABAB0097979700EBEBEB009A9A
      9A00B0B0B000E9E9E900ABABAB00979797000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C6009E9E9E009696
      9600B2B2B200BCBCBC0099999900ABABAB00A4A4A4009A9A9A00B3B3B300ABAB
      AB0093939300A3A3A30000000000000000000000000000000000000000009F9F
      9F00F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4F400F3F3
      F300F2F2F200A3A3A30099999900DADADA00A0A0A0009F9F9F00EBEBEB00A3A3
      A300A2A2A200EEEEEE00A0A0A0009F9F9F000000000095959500000000000000
      0000000000000000000000000000000000000000000000000000959595009595
      9500959595009595950000000000000000000000000000000000000000000000
      0000000000000000000095959500000000000000000095959500000000000000
      0000000000000000000000000000000000000000000000000000959595009595
      9500959595009595950000000000000000000000000000000000000000000000
      0000000000000000000095959500000000000000000095959500000000000000
      00000000000000000000000000000000000000000000C6C6C6009C9C9C009A9A
      9A00C3C3C300C4C4C400B9B9B900989898009A9A9A00B7B7B700B8B8B800B3B3
      B30097979700A2A2A2009595950000000000000000000000000000000000A0A0
      A000F9F9F900F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4
      F400F3F3F300AFAFAF0099999900D0D0D00099999900ABABAB00EDEDED00AFAF
      AF0099999900EDEDED0099999900ABABAB000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095959500BEBE
      BE00C1C1C1009595950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095959500BEBE
      BE00C1C1C1009595950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000959595009797
      9700B2B2B200CDCDCD00CDCDCD00CDCDCD00CACACA00C3C3C300BFBFBF00A6A6
      A6009A9A9A00000000000000000000000000000000000000000000000000A0A0
      A000FAFAFA00F9F9F900F8F8F800A9A9A900A8A8A800A7A7A700A6A6A600A5A5
      A500A3A3A300BFBFBF009898980095959500959595006A6A6A00696969006B6B
      6B00969696009595950096969600BCBCBC000000000095959500000000000000
      000000000000000000000000000000000000000000000000000095959500C0C0
      C000C3C3C3009595950000000000000000000000000000000000000000000000
      0000000000000000000095959500000000000000000095959500000000000000
      000000000000000000000000000000000000000000000000000095959500C0C0
      C000C3C3C3009595950000000000000000000000000000000000000000000000
      0000000000000000000095959500000000000000000095959500000000000000
      000000000000000000000000000000000000B2B2B200ABABAB00B6B6B6009999
      9900B2B2B200D8D8D800CBCBCB00AAAAAA00A9A9A900C3C3C300C6C6C600A5A5
      A5009B9B9B00B5B5B500AAAAAA00B7B7B700000000000000000000000000A1A1
      A100FAFAFA00FAFAFA00F8F8F800ABABAB00AAAAAA00A9A9A900A8A8A800A6A6
      A600A5A5A500A4A4A4009696960095959500959595006E6E6E00696969007474
      7400969696009696960096969600000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095959500C2C2
      C200C5C5C5009595950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095959500C2C2
      C200C5C5C5009595950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000949494009B9B9B0097979700ABAB
      AB00D9D9D900D0D0D0008D8D8D00A2A2A200A0A0A0008D8D8D00C3C3C300C1C1
      C100A0A0A000959595009898980099999900000000000000000000000000A2A2
      A200FAFAFA00FAFAFA00F9F9F900F8F8F800F8F8F800F7F7F700F7F7F700F6F6
      F600F6F6F600F4F4F40069696900DADADA00A3A3A30069696900F0F0F0006969
      6900DADADA00A3A3A30069696900000000000000000095959500000000000000
      000000000000000000000000000000000000000000000000000095959500C4C4
      C400C8C8C8009595950000000000000000000000000000000000000000000000
      0000000000000000000095959500000000000000000095959500000000000000
      000000000000000000000000000000000000000000000000000095959500C4C4
      C400C8C8C8009595950000000000000000000000000000000000000000000000
      0000000000000000000095959500000000000000000095959500000000000000
      0000000000000000000000000000000000008F8F8F00CDCDCD00DADADA00E0E0
      E000E5E5E500A9A9A900A9A9A9000000000000000000A3A3A300A6A6A600CACA
      CA00C0C0C000B8B8B800ACACAC0095959500000000000000000000000000A3A3
      A300FBFBFB00FAFAFA00FAFAFA00FAFAFA00F8F8F800F8F8F800F7F7F700F7F7
      F700F6F6F600F6F6F60069696900696969006969690074747400F0F0F0006969
      6900696969006969690074747400000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095959500C6C6
      C600CACACA009595950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095959500C6C6
      C600CACACA009595950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008F8F8F00D2D2D200E0E0E000E7E7
      E700EDEDED00A8A8A800ADADAD000000000000000000A7A7A700A3A3A300CECE
      CE00C4C4C400BCBCBC00ACACAC0095959500000000000000000000000000A3A3
      A300FBFBFB00FBFBFB00FAFAFA00AFAFAF00AEAEAE00ADADAD00ACACAC00ABAB
      AB00AAAAAA00A9A9A900A8A8A800A6A6A600A5A5A500F2F2F200F1F1F100F0F0
      F000999999000000000000000000000000000000000095959500000000000000
      000000000000000000009595950000000000000000000000000095959500C8C8
      C800CCCCCC009595950000000000000000000000000095959500000000000000
      0000000000000000000095959500000000000000000095959500000000000000
      000000000000959595000000000000000000000000000000000095959500C8C8
      C800CCCCCC009595950000000000000000000000000000000000959595000000
      0000000000000000000095959500000000000000000095959500000000000000
      00000000000000000000000000000000000092929200ABABAB00A8A8A800C0C0
      C000F1F1F100DCDCDC008E8E8E00ADADAD00AAAAAA008D8D8D00C8C8C800CDCD
      CD00A9A9A9009C9C9C009D9D9D0097979700000000000000000000000000A4A4
      A400FCFCFC00FBFBFB00FBFBFB00B1B1B100B0B0B000AFAFAF00ADADAD00ACAC
      AC00ABABAB00ABABAB00A9A9A900A8A8A800A6A6A600F3F3F300F3F3F300F1F1
      F1009A9A9A000000000000000000000000000000000000000000000000000000
      000000000000000000009595950095959500000000000000000095959500CBCB
      CB00CECECE009595950000000000000000009595950095959500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000095959500959595000000000000000000000000000000000095959500CBCB
      CB00CECECE009595950000000000000000000000000000000000959595009595
      9500000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ACACAC00A1A1A100AAAAAA009494
      9400CBCBCB00FCFCFC00DBDBDB00A6A6A600A5A5A500CBCBCB00D8D8D800AFAF
      AF0097979700AAAAAA009F9F9F00B2B2B200000000000000000000000000A5A5
      A500FCFCFC00FCFCFC00FBFBFB00FBFBFB00FAFAFA00FAFAFA00F9F9F900F8F8
      F800F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F3F3F300F2F2
      F2009B9B9B000000000000000000000000000000000095959500000000009595
      950095959500959595009595950095959500959595000000000095959500CDCD
      CD00D0D0D0009595950000000000959595009595950095959500959595009595
      9500959595000000000095959500000000000000000095959500000000009595
      950095959500959595009595950095959500959595000000000095959500CDCD
      CD00D0D0D0009595950000000000959595009595950095959500959595009595
      9500959595000000000095959500000000000000000095959500000000000000
      0000000000000000000000000000000000000000000000000000959595009C9C
      9C00C2C2C200F6F6F600F5F5F500F1F1F100E9E9E900DEDEDE00D5D5D500A9A9
      A900A1A1A100000000009595950000000000000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00FBFBFB00FBFBFB00FBFBFB00FAFAFA00F9F9
      F900F8F8F800F8F8F800F7F7F700F7F7F700F6F6F600F5F5F500F4F4F400EBEB
      EB009B9B9B000000000000000000000000000000000000000000000000009595
      950095959500959595009595950095959500959595009595950095959500CFCF
      CF00D1D1D1009595950095959500959595009595950095959500959595009595
      9500959595000000000000000000000000000000000000000000959595009595
      950095959500959595009595950095959500959595000000000095959500CFCF
      CF00D1D1D1009595950000000000959595009595950095959500959595009595
      9500959595009595950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000A7A7A7009A9A
      9A00E5E5E500EBEBEB00E4E4E400B2B2B200B3B3B300D6D6D600D2D2D200C7C7
      C7008E8E8E00ACACAC000000000000000000000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00B5B5B500B5B5B500B3B3B300B2B2B200B1B1
      B100B0B0B000AFAFAF00ADADAD00ACACAC00ABABAB00EFEFEF00E7E7E700DCDC
      DC009C9C9C000000000000000000000000000000000095959500000000009595
      950095959500959595009595950095959500959595000000000095959500D1D1
      D100D3D3D3009595950000000000959595009595950095959500959595009595
      9500959595000000000095959500000000000000000095959500000000009595
      950095959500959595009595950095959500959595000000000095959500D1D1
      D100D3D3D3009595950000000000959595009595950095959500959595009595
      9500959595000000000095959500000000000000000095959500000000000000
      00000000000000000000000000000000000000000000C5C5C50095959500A2A2
      A200DFDFDF00E6E6E600A8A8A8009F9F9F009A9A9A00A8A8A800D1D1D100C4C4
      C40099999900999999009595950000000000000000000000000000000000A7A7
      A700FCFCFC00FCFCFC00FCFCFC00B6B6B600B6B6B600B5B5B500B4B4B400B2B2
      B200B2B2B200AFAFAF00ADADAD00ACACAC00ABABAB00DCDCDC00DCDCDC00DCDC
      DC009D9D9D000000000000000000000000000000000000000000000000000000
      000000000000000000009595950095959500000000000000000095959500D2D2
      D200D6D6D6009595950000000000000000009595950095959500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000095959500959595000000000000000000000000000000000095959500D2D2
      D200D6D6D6009595950000000000000000000000000000000000959595009595
      9500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C4C4C4009F9F
      9F0093939300B2B2B2008D8D8D00C6C6C600C0C0C0008D8D8D00A8A8A8009090
      9000A2A2A200C6C6C6000000000000000000000000000000000000000000A8A8
      A800FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FBFBFB00FBFB
      FB00FAFAFA00A2A2A200A1A1A100A1A1A100A0A0A000A0A0A0009F9F9F009E9E
      9E009D9D9D000000000000000000000000000000000095959500000000000000
      000000000000000000009595950000000000000000000000000095959500D4D4
      D400D8D8D8009595950000000000000000000000000095959500000000000000
      0000000000000000000095959500000000000000000095959500000000000000
      000000000000959595000000000000000000000000000000000095959500D4D4
      D400D8D8D8009595950000000000000000000000000000000000959595000000
      0000000000000000000095959500000000000000000095959500000000000000
      000000000000000000000000000000000000000000000000000095959500D4D4
      D400B7B7B7009E9E9E009F9F9F0000000000000000009D9D9D009F9F9F00B8B8
      B80000000000000000009595950000000000000000000000000000000000A8A8
      A800FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FBFBFB00FBFB
      FB00FBFBFB00A3A3A300FCFCFC00F8F8F800F4F4F400EFEFEF00EAEAEA009F9F
      9F00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095959500D6D6
      D600DADADA009595950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095959500D6D6
      D600DADADA009595950000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000095959500D6D6
      D600DADADA009595950000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A9A9
      A900FCFCFC00FCFCFC00FCFCFC00BABABA00B9B9B900B8B8B800B8B8B800B7B7
      B700B6B6B600A3A3A300F8F8F800F4F4F400EFEFEF00EAEAEA00A0A0A0000000
      00000000000000000000000000000000000000000000A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A400959595009595950095959500D8D8
      D800DCDCDC00959595009595950095959500A4A4A400A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A4000000000000000000A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A400959595009595950095959500D8D8
      D800DCDCDC00959595009595950095959500A4A4A400A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A4000000000000000000A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A400959595009595950095959500D8D8
      D800DCDCDC00959595009595950095959500A4A4A400A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A40000000000000000000000000000000000A9A9
      A900FCFCFC00FCFCFC00FCFCFC00BBBBBB00BABABA00B9B9B900B9B9B900B8B8
      B800B7B7B700A4A4A400F4F4F400EFEFEF00EAEAEA00A2A2A200000000000000
      00000000000000000000000000000000000000000000A4A4A400000000000000
      00000000000000000000000000000000000095959500D6D6D60095959500DBDB
      DB00DEDEDE0095959500BFBFBF00959595000000000000000000000000000000
      00000000000000000000A4A4A4000000000000000000A4A4A400000000000000
      00000000000000000000000000000000000095959500D6D6D60095959500DBDB
      DB00DEDEDE0095959500BFBFBF00959595000000000000000000000000000000
      00000000000000000000A4A4A4000000000000000000A4A4A400000000000000
      00000000000000000000000000000000000095959500D6D6D60095959500DBDB
      DB00DEDEDE0095959500BFBFBF00959595000000000000000000000000000000
      00000000000000000000A4A4A40000000000000000000000000000000000A9A9
      A900FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00A5A5A500EFEFEF00EAEAEA00A3A3A30000000000000000000000
      00000000000000000000000000000000000000000000A4A4A400000000000000
      00000000000000000000000000000000000095959500DBDBDB0095959500DDDD
      DD00E0E0E00095959500C3C3C300959595000000000000000000000000000000
      00000000000000000000A4A4A4000000000000000000A4A4A400000000000000
      00000000000000000000000000000000000095959500DBDBDB0095959500DDDD
      DD00E0E0E00095959500C3C3C300959595000000000000000000000000000000
      00000000000000000000A4A4A4000000000000000000A4A4A400000000000000
      00000000000000000000000000000000000095959500DBDBDB0095959500DDDD
      DD00E0E0E00095959500C3C3C300959595000000000000000000000000000000
      00000000000000000000A4A4A40000000000000000000000000000000000AAAA
      AA00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00A6A6A600EAEAEA00A4A4A4000000000000000000000000000000
      00000000000000000000000000000000000000000000A4A4A400000000000000
      00000000000000000000000000000000000095959500E0E0E00095959500DFDF
      DF00E3E3E30095959500C8C8C800959595000000000000000000000000000000
      00000000000000000000A4A4A4000000000000000000A4A4A400000000000000
      00000000000000000000000000000000000095959500E0E0E00095959500DFDF
      DF00E3E3E30095959500C8C8C800959595000000000000000000000000000000
      00000000000000000000A4A4A4000000000000000000A4A4A400000000000000
      00000000000000000000000000000000000095959500E0E0E00095959500DFDF
      DF00E3E3E30095959500C8C8C800959595000000000000000000000000000000
      00000000000000000000A4A4A40000000000000000000000000000000000ABAB
      AB00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00A6A6A600A6A6A600000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A4009595950095959500959595009595
      950095959500959595009595950095959500A4A4A400A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A4000000000000000000A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A4009595950095959500959595009595
      950095959500959595009595950095959500A4A4A400A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A4000000000000000000A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A400A4A4A4009595950095959500959595009595
      950095959500959595009595950095959500A4A4A400A4A4A400A4A4A400A4A4
      A400A4A4A400A4A4A400A4A4A40000000000000000000000000000000000ABAB
      AB00ABABAB00ABABAB00AAAAAA00A9A9A900A9A9A900A9A9A900A8A8A800A8A8
      A800A8A8A800A6A6A60000000000000000000000000000000000000000000000
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
      000000000000000000000000000000000000000000000000000000000000ABAB
      AB008E8E8E00989898008D8D8D0000000000C3C3C3008B8B8B00989898008E8E
      8E00ADADAD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006969690069696900696969006969690069696900000000006969
      6900696969006969690069696900696969000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C6009E9E9E009696
      9600B2B2B200BCBCBC0099999900ABABAB00A4A4A4009A9A9A00B3B3B300ABAB
      AB0093939300A3A3A30000000000000000000000000000000000000000009C9C
      9C009B9B9B009B9B9B009A9A9A009A9A9A009A9A9A0099999900999999009999
      9900999999009898980098989800989898009797970096969600969696009696
      9600969696000000000000000000000000000000000000000000000000009D9D
      9D009D9D9D009C9C9C009B9B9B009B9B9B009A9A9A009A9A9A00999999009999
      9900999999009999990098989800989898009797970097979700979797009696
      9600969696000000000000000000000000000000000000000000000000009C9C
      9C009B9B9B009B9B9B009A9A9A009A9A9A009A9A9A0099999900999999009999
      990099999900696969006E6E6E006A6A6A006969690069696900969696006969
      6900707070007777770069696900696969009595950095959500959595009595
      95009595950095959500959595009595950095959500C6C6C6009C9C9C009A9A
      9A00C3C3C300C4C4C400B9B9B900989898009A9A9A00B7B7B700B8B8B800B3B3
      B30097979700A2A2A20095959500959595000000000000000000000000009D9D
      9D00F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4F400F3F3F300F2F2
      F200F1F1F100F0F0F000EFEFEF00EEEEEE00EDEDED00ECECEC00EBEBEB00EAEA
      EA00969696000000000000000000000000000000000000000000000000009F9F
      9F00F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4F400F3F3F300F2F2
      F200F1F1F100F0F0F000EFEFEF00EEEEEE00EDEDED00ECECEC00EBEBEB00EAEA
      EA00969696000000000000000000000000000000000000000000000000009D9D
      9D00F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4F400F3F3F300F2F2
      F200F1F1F1009A9A9A0099999900DCDCDC00ABABAB0097979700EBEBEB009A9A
      9A00B0B0B000E9E9E900ABABAB009797970095959500CECECE00F7F7F700F7F7
      F700F7F7F700F6F6F600F5F5F50095959500CBCBCB00F3F3F300F2F2F2009797
      9700B2B2B200CDCDCD00CDCDCD00CDCDCD00CACACA00C3C3C300BFBFBF00A6A6
      A6009A9A9A00E9E9E900E8E8E800959595000000000000000000000000009D9D
      9D00F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4F400F3F3
      F300F2F2F200F1F1F100F0F0F000EEEEEE00EEEEEE00EDEDED00EBEBEB00EBEB
      EB00969696000000000000000000000000000000000000000000000000009F9F
      9F00F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4F400F3F3
      F300F2F2F200F1F1F100F0F0F000EEEEEE00EEEEEE00EDEDED00EBEBEB00EBEB
      EB00969696000000000000000000000000000000000000000000000000009D9D
      9D00F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4F400F3F3
      F300F2F2F200A3A3A30099999900DADADA00A0A0A0009F9F9F00EBEBEB00A3A3
      A300A2A2A200EEEEEE00A0A0A0009F9F9F0095959500CECECE00F8F8F800F8F8
      F800F7F7F700F7F7F700F6F6F60095959500B2B2B200ABABAB00B6B6B6009999
      9900B2B2B200D8D8D800CBCBCB00AAAAAA00A9A9A900C3C3C300C6C6C600A5A5
      A5009B9B9B00B5B5B500AAAAAA00B7B7B7000000000000000000000000009E9E
      9E00F9F9F900F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4
      F400F3F3F300F1F1F100F1F1F100F0F0F000EFEFEF00EDEDED00EDEDED00EBEB
      EB0097979700000000000000000000000000000000000000000000000000A0A0
      A000F9F9F900F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4
      F400F3F3F300F1F1F100F1F1F100F0F0F000EFEFEF00EDEDED00EDEDED00EBEB
      EB00979797000000000000000000000000000000000000000000000000009E9E
      9E00F9F9F900F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F4F4
      F400F3F3F300AFAFAF0099999900D0D0D00099999900ABABAB00EDEDED00AFAF
      AF0099999900EDEDED0099999900ABABAB0095959500CECECE00F8F8F800F8F8
      F800F7F7F700F7F7F700F7F7F70095959500949494009B9B9B0097979700ABAB
      AB00D9D9D900D0D0D0008D8D8D00A2A2A200A0A0A0008D8D8D00C3C3C300C1C1
      C100A0A0A0009595950098989800999999000000000000000000000000009F9F
      9F00FAFAFA00F9F9F900F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4
      F400F4F4F400F3F3F300F1F1F100F1F1F100F0F0F000EFEFEF00EEEEEE00EDED
      ED0097979700000000000000000000000000000000000000000000000000A0A0
      A000FAFAFA00F9F9F900F8F8F800A9A9A900A8A8A800A7A7A700A6A6A600A5A5
      A500A3A3A300A3A3A300A2A2A200A1A1A100A0A0A000EFEFEF00EEEEEE00EDED
      ED00989898000000000000000000000000000000000000000000000000009F9F
      9F00FAFAFA00F9F9F900F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4
      F400F4F4F400BFBFBF009898980095959500959595006A6A6A00696969006B6B
      6B00969696009595950096969600BCBCBC0095959500CECECE00F9F9F900F8F8
      F800F7F7F700F7F7F700F7F7F700959595008F8F8F00CDCDCD00DADADA00E0E0
      E000E5E5E500A9A9A900A9A9A900F0F0F000EEEEEE00A3A3A300A6A6A600CACA
      CA00C0C0C000B8B8B800ACACAC00959595000000000000000000000000009F9F
      9F00FAFAFA00FAFAFA00F8F8F800F8F8F800F7F7F700F7F7F700F6F6F600F5F5
      F500F4F4F400F4F4F400F3F3F300F2F2F200F1F1F100F0F0F000EFEFEF00EDED
      ED0098989800000000000000000000000000000000000000000000000000A1A1
      A100FAFAFA00FAFAFA00F8F8F800ABABAB00AAAAAA00A9A9A900A8A8A800A6A6
      A600A5A5A500A4A4A400A3A3A300A2A2A200A1A1A100F0F0F000EFEFEF00EDED
      ED00989898000000000000000000000000000000000000000000000000009F9F
      9F00FAFAFA00FAFAFA00F8F8F800F8F8F800F7F7F700F7F7F700F6F6F600F5F5
      F500F4F4F400F4F4F4009696960095959500959595006E6E6E00696969007474
      74009696960096969600969696000000000095959500CFCFCF00FAFAFA00F9F9
      F900F8F8F800F7F7F700F7F7F700959595008F8F8F00D2D2D200E0E0E000E7E7
      E700EDEDED00A8A8A800ADADAD00C8C8C800C8C8C800A7A7A700A3A3A300CECE
      CE00C4C4C400BCBCBC00ACACAC0095959500000000000000000000000000A0A0
      A000FAFAFA00FAFAFA00F9F9F900F8F8F800F8F8F800F7F7F700F7F7F700F6F6
      F600F6F6F600F4F4F400F4F4F400F3F3F300F1F1F100F1F1F100F0F0F000EEEE
      EE0098989800000000000000000000000000000000000000000000000000A2A2
      A200FAFAFA00FAFAFA00F9F9F900F8F8F800F8F8F800F7F7F700F7F7F700F6F6
      F600F6F6F600F4F4F400F4F4F400F3F3F300F1F1F100F1F1F100F0F0F000EEEE
      EE0099999900000000000000000000000000000000000000000000000000A0A0
      A000FAFAFA00FAFAFA00F9F9F900F8F8F800F8F8F800F7F7F700F7F7F700F6F6
      F600F6F6F600F4F4F40069696900DADADA00A3A3A30069696900F0F0F0006969
      6900DADADA00A3A3A300696969000000000095959500CFCFCF00FAFAFA00FAFA
      FA00F9F9F900F8F8F800F7F7F7009595950092929200ABABAB00A8A8A800C0C0
      C000F1F1F100DCDCDC008E8E8E00ADADAD00AAAAAA008D8D8D00C8C8C800CDCD
      CD00A9A9A9009C9C9C009D9D9D0097979700000000000000000000000000A0A0
      A000FBFBFB00FAFAFA00AFAFAF00ADADAD00ACACAC00AAAAAA00A9A9A900A7A7
      A700A5A5A500A3A3A300A2A2A200A0A0A0009F9F9F009D9D9D00F0F0F000F0F0
      F00099999900000000000000000000000000000000000000000000000000A3A3
      A300FBFBFB00FAFAFA00FAFAFA00FAFAFA00F8F8F800F8F8F800F7F7F700F7F7
      F700F6F6F600F6F6F600F4F4F400F4F4F400F3F3F300F1F1F100F0F0F000F0F0
      F00099999900000000000000000000000000000000000000000000000000A0A0
      A000FBFBFB00FAFAFA00AFAFAF00ADADAD00ACACAC00AAAAAA00A9A9A900A7A7
      A700A5A5A500A3A3A30069696900696969006969690074747400F0F0F0006969
      69006969690069696900747474000000000095959500CFCFCF00FAFAFA00FAFA
      FA00F9F9F900F8F8F800F7F7F70095959500ACACAC00A1A1A100AAAAAA009494
      9400CBCBCB00FCFCFC00DBDBDB00A6A6A600A5A5A500CBCBCB00D8D8D800AFAF
      AF0097979700AAAAAA009F9F9F00B2B2B200000000000000000000000000A1A1
      A100FBFBFB00FBFBFB00C2C2C200C0C0C000B8B8B800B3B3B300B6B6B600BBBB
      BB00B9B9B900B7B7B700B5B5B500B3B3B300B2B2B200B0B0B000F1F1F100F0F0
      F00099999900000000000000000000000000000000000000000000000000A3A3
      A300FBFBFB00FBFBFB00FAFAFA00AFAFAF00AEAEAE00ADADAD00ACACAC00ABAB
      AB00AAAAAA00A9A9A900A8A8A800A6A6A600A5A5A500F2F2F200F1F1F100F0F0
      F00099999900000000000000000000000000000000000000000000000000A1A1
      A100FBFBFB00FBFBFB00C2C2C200C0C0C000B8B8B800B3B3B300B6B6B600BBBB
      BB00B9B9B900B7B7B700B5B5B500B3B3B300B2B2B200B0B0B000F1F1F100F0F0
      F0009999990000000000000000000000000095959500D0D0D000FBFBFB00FAFA
      FA00FAFAFA00F9F9F900F8F8F80095959500CDCDCD00F7F7F700F6F6F6009C9C
      9C00C2C2C200F6F6F600F5F5F500F1F1F100E9E9E900DEDEDE00D5D5D500A9A9
      A900A1A1A100EDEDED00ECECEC0095959500000000000000000000000000A2A2
      A200FCFCFC00FBFBFB00CECECE00BFBFBF00B7B7B700B3B3B300AEAEAE00B1B1
      B100C0C0C000CBCBCB00C9C9C900C7C7C700C5C5C500C4C4C400F3F3F300F1F1
      F10099999900000000000000000000000000000000000000000000000000A4A4
      A400FCFCFC00FBFBFB00FBFBFB00B1B1B100B0B0B000AFAFAF00ADADAD00ACAC
      AC00ABABAB00ABABAB00A9A9A900A8A8A800A6A6A600F3F3F300F3F3F300F1F1
      F1009A9A9A00000000000000000000000000000000000000000000000000A2A2
      A200FCFCFC00FBFBFB00CECECE00BFBFBF00B7B7B700B3B3B300AEAEAE00B1B1
      B100C0C0C000CBCBCB00C9C9C900C7C7C700C5C5C500C4C4C400F3F3F300F1F1
      F1009999990000000000000000000000000095959500D0D0D000FBFBFB00FBFB
      FB00FAFAFA00F9F9F900F9F9F90095959500CDCDCD00F7F7F700A7A7A7009A9A
      9A00E5E5E500EBEBEB00E4E4E400B2B2B200B3B3B300D6D6D600D2D2D200C7C7
      C7008E8E8E00ACACAC00EDEDED0095959500000000000000000000000000A2A2
      A200FCFCFC00FCFCFC00C1C1C100CACACA00C6C6C600C2C2C200BFBFBF00BBBB
      BB00B8B8B800C0C0C000CECECE00D0D0D000D0D0D000D0D0D000F3F3F300F2F2
      F2009A9A9A00000000000000000000000000000000000000000000000000A5A5
      A500FCFCFC00FCFCFC00FBFBFB00FBFBFB00FAFAFA00FAFAFA00F9F9F900F8F8
      F800F8F8F800F7F7F700F7F7F700F6F6F600F6F6F600F4F4F400F3F3F300F2F2
      F2009B9B9B00000000000000000000000000000000000000000000000000A2A2
      A200FCFCFC00FCFCFC00C1C1C100CACACA00C6C6C600C2C2C200BFBFBF00BBBB
      BB00B8B8B800C0C0C000CECECE00D0D0D000D0D0D000D0D0D000F3F3F300F2F2
      F2009A9A9A0000000000000000000000000095959500D0D0D000FBFBFB00FBFB
      FB00FAFAFA00FAFAFA00F9F9F90095959500CDCDCD00C5C5C50095959500A2A2
      A200DFDFDF00E6E6E600A8A8A8009F9F9F009A9A9A00A8A8A800D1D1D100C4C4
      C4009999990099999900EDEDED0095959500000000000000000000000000A3A3
      A300FCFCFC00FCFCFC00D2D2D200D2D2D200D2D2D200D2D2D200D2D2D200D2D2
      D200D2D2D200D2D2D200B5B5B500A5A5A500B0B0B000B0B0B000F4F4F400F3F3
      F3009A9A9A00000000000000000000000000000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00FBFBFB00FBFBFB00FBFBFB00FAFAFA00F9F9
      F900F8F8F800F8F8F800F7F7F700F7F7F700F6F6F600F5F5F500F4F4F400EBEB
      EB009B9B9B00000000000000000000000000000000000000000000000000A3A3
      A300FCFCFC00FCFCFC00D2D2D200D2D2D200D2D2D200D2D2D200D2D2D200D2D2
      D200D2D2D200D2D2D200B5B5B500A5A5A500B0B0B000B0B0B000F4F4F400F3F3
      F3009A9A9A0000000000000000000000000095959500D0D0D000FBFBFB00FBFB
      FB00FAFAFA00FAFAFA00FAFAFA0095959500CECECE00F8F8F800C4C4C4009F9F
      9F0093939300B2B2B2008D8D8D00C6C6C600C0C0C0008D8D8D00A8A8A8009090
      9000A2A2A200C6C6C600EDEDED0095959500000000000000000000000000A3A3
      A300FCFCFC00FCFCFC00DBDBDB00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDC
      DC00DCDCDC00CDCDCD00B4B4B400B4B4B400B4B4B400B4B4B400F5F5F500F4F4
      F4009B9B9B00000000000000000000000000000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00B5B5B500B5B5B500B3B3B300B2B2B200B1B1
      B100B0B0B000AFAFAF00ADADAD00ACACAC00ABABAB00EFEFEF00E7E7E700DCDC
      DC009C9C9C00000000000000000000000000000000000000000000000000A3A3
      A300FCFCFC00FCFCFC00DBDBDB00DCDCDC00DCDCDC00DCDCDC00DCDCDC00DCDC
      DC00DCDCDC00CDCDCD00B4B4B400B4B4B400B4B4B400B4B4B400F5F5F500F4F4
      F4009B9B9B0000000000000000000000000095959500D0D0D000FBFBFB00FBFB
      FB00FBFBFB00FAFAFA00FAFAFA0095959500CECECE00F8F8F800F7F7F700F7F7
      F700B7B7B7009E9E9E009F9F9F00F4F4F400F3F3F3009D9D9D009F9F9F00B8B8
      B800EFEFEF00EEEEEE00EEEEEE0095959500000000000000000000000000A3A3
      A300FCFCFC00FCFCFC00B0B0B000DBDBDB00E5E5E500E5E5E500E5E5E500E5E5
      E500D1D1D100A8A8A800B6B6B600C6C6C600C3C3C300ACACAC00F6F6F600F5F5
      F5009B9B9B00000000000000000000000000000000000000000000000000A7A7
      A700FCFCFC00FCFCFC00FCFCFC00B6B6B600B6B6B600B5B5B500B4B4B400B2B2
      B200B2B2B200AFAFAF00ADADAD00ACACAC00ABABAB00DCDCDC00DCDCDC00DCDC
      DC009D9D9D00000000000000000000000000000000000000000000000000A3A3
      A300FCFCFC00FCFCFC00B0B0B000DBDBDB00E5E5E500E5E5E500E5E5E500E5E5
      E500D1D1D100A8A8A800B6B6B600C6C6C600C3C3C300ACACAC00F6F6F600F5F5
      F5009B9B9B0000000000000000000000000095959500D0D0D000FCFCFC00FBFB
      FB00FBFBFB00FBFBFB00FAFAFA0095959500CECECE00F8F8F800F8F8F800F7F7
      F700F7F7F700F6F6F600F5F5F500F4F4F400F4F4F400F2F2F200F1F1F100F1F1
      F100F0F0F000EFEFEF00EEEEEE0095959500000000000000000000000000A4A4
      A400FCFCFC00FCFCFC00A3A3A300A6A6A600D1D1D100F0F0F000F0F0F000D3D3
      D300A5A5A500A3A3A300A3A3A300ADADAD00A9A9A900A3A3A300F7F7F700F6F6
      F6009C9C9C00000000000000000000000000000000000000000000000000A8A8
      A800FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FBFBFB00FBFB
      FB00FAFAFA00A2A2A200A1A1A100A1A1A100A0A0A000A0A0A0009F9F9F009E9E
      9E009D9D9D00000000000000000000000000000000000000000000000000A4A4
      A400FCFCFC00FCFCFC00A3A3A300A6A6A600D1D1D100F0F0F000F0F0F000D3D3
      D300A5A5A500A3A3A300A3A3A300ADADAD00A9A9A900A3A3A300F7F7F700F6F6
      F6009C9C9C0000000000000000000000000095959500D0D0D000D0D0D000D0D0
      D000D0D0D000D0D0D000D0D0D00095959500CECECE00CECECE00CECECE00CDCD
      CD00CDCDCD00CDCDCD00CCCCCC00CBCBCB00CBCBCB00CBCBCB00CACACA00CACA
      CA00C9C9C900C9C9C900C8C8C80095959500000000000000000000000000A5A5
      A500FCFCFC00FCFCFC00A0A0A000A0A0A000A0A0A000BDBDBD00C3C3C300A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000F7F7F700F7F7
      F7009D9D9D00000000000000000000000000000000000000000000000000A8A8
      A800FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FBFBFB00FBFB
      FB00FBFBFB00A3A3A300FCFCFC00F8F8F800F4F4F400EFEFEF00EAEAEA009F9F
      9F0000000000000000000000000000000000000000000000000000000000A5A5
      A500FCFCFC00FCFCFC00A0A0A000A0A0A000A0A0A000BDBDBD00C3C3C300A0A0
      A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000A0A0A000F7F7F700F7F7
      F7009D9D9D0000000000000000000000000095959500DEDEDE00DDDDDD00DBDB
      DB00D9D9D900D5D5D500D3D3D300D0D0D000CDCDCD00CACACA00C6C6C600C2C2
      C200BFBFBF00BBBBBB00B8B8B800B5B5B500B1B1B100AEAEAE00ACACAC00A9A9
      A900A6A6A600A5A5A500A4A4A40095959500000000000000000000000000A5A5
      A500FCFCFC00FCFCFC009D9D9D009D9D9D009D9D9D009D9D9D009D9D9D009D9D
      9D009D9D9D009D9D9D009D9D9D009D9D9D009D9D9D009D9D9D00F8F8F800F7F7
      F7009D9D9D00000000000000000000000000000000000000000000000000A9A9
      A900FCFCFC00FCFCFC00FCFCFC00BABABA00B9B9B900B8B8B800B8B8B800B7B7
      B700B6B6B600A3A3A300F8F8F800F4F4F400EFEFEF00EAEAEA00A0A0A0000000
      000000000000000000000000000000000000000000000000000000000000A5A5
      A500FCFCFC00FCFCFC009D9D9D009D9D9D009D9D9D009D9D9D009D9D9D009D9D
      9D009D9D9D009D9D9D009D9D9D009D9D9D009D9D9D009D9D9D00F8F8F800F7F7
      F7009D9D9D0000000000000000000000000095959500DEDEDE00DDDDDD00DBDB
      DB00D9D9D900D6D6D600D3D3D300D1D1D100CDCDCD00CACACA00C6C6C600C2C2
      C200BFBFBF00BBBBBB00B8B8B800B5B5B500B2B2B200AEAEAE00ACACAC00A9A9
      A900A8A8A800A5A5A500A4A4A40095959500000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FBFBFB00FBFBFB00FAFAFA00FAFAFA00F9F9F900F8F8F800F8F8
      F8009E9E9E00000000000000000000000000000000000000000000000000A9A9
      A900FCFCFC00FCFCFC00FCFCFC00BBBBBB00BABABA00B9B9B900B9B9B900B8B8
      B800B7B7B700A4A4A400F4F4F400EFEFEF00EAEAEA00A2A2A200000000000000
      000000000000000000000000000000000000000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FBFBFB00FBFBFB00FAFAFA00FAFAFA00F9F9F900F8F8F800F8F8
      F8009E9E9E0000000000000000000000000095959500DEDEDE00DDDDDD00DBDB
      DB00D9D9D900D6D6D600D3D3D300D1D1D100CECECE00CACACA00C6C6C600C3C3
      C300BFBFBF00BCBCBC00B8B8B800B5B5B500B2B2B200AFAFAF00ACACAC00A9A9
      A900A7A7A700A5A5A500A4A4A40095959500000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FBFBFB00FBFBFB00FAFAFA00FAFAFA00F8F8F800F8F8
      F8009F9F9F00000000000000000000000000000000000000000000000000A9A9
      A900FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00A5A5A500EFEFEF00EAEAEA00A3A3A30000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FBFBFB00FBFBFB00FAFAFA00FAFAFA00F8F8F800F8F8
      F8009F9F9F000000000000000000000000009595950095959500959595009595
      9500959595009595950095959500959595009595950095959500959595009595
      9500959595009595950095959500959595009595950095959500959595009595
      950095959500959595009595950095959500000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FBFBFB00FBFBFB00FBFBFB00FAFAFA00F9F9F900F9F9
      F9009F9F9F00000000000000000000000000000000000000000000000000AAAA
      AA00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00A6A6A600EAEAEA00A4A4A4000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FBFBFB00FBFBFB00FBFBFB00FAFAFA00F9F9F900F9F9
      F9009F9F9F000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FBFBFB00FBFBFB00FBFBFB00FAFAFA00F9F9F900F9F9
      F900A0A0A000000000000000000000000000000000000000000000000000ABAB
      AB00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00A6A6A600A6A6A600000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A6A6
      A600FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFCFC00FCFC
      FC00FCFCFC00FCFCFC00FBFBFB00FBFBFB00FBFBFB00FAFAFA00F9F9F900F9F9
      F900A0A0A0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A7A7
      A700A6A6A600A6A6A600A6A6A600A6A6A600A6A6A600A5A5A500A5A5A500A5A5
      A500A4A4A400A4A4A400A3A3A300A3A3A300A2A2A200A2A2A200A2A2A200A1A1
      A100A0A0A000000000000000000000000000000000000000000000000000ABAB
      AB00ABABAB00ABABAB00AAAAAA00A9A9A900A9A9A900A9A9A900A8A8A800A8A8
      A800A8A8A800A6A6A60000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A7A7
      A700A6A6A600A6A6A600A6A6A600A6A6A600A6A6A600A5A5A500A5A5A500A5A5
      A500A4A4A400A4A4A400A3A3A300A3A3A300A2A2A200A2A2A200A2A2A200A1A1
      A100A0A0A0000000000000000000000000000000000000000000000000000000
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
      00009595950000000000BBBBBB009C9C9C008A8A8A0087878700878787008D8D
      8D00A5A5A500C3C3C30000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009595950095959500959595009595
      9500959595009595950095959500959595009595950095959500959595009595
      9500959595009595950095959500959595009595950095959500959595009595
      9500959595009595950095959500000000000000000000000000000000000000
      00000000000000000000C7C7C700B9B9B900ABABAB009F9F9F00999999009595
      95009595950098989800A0A0A000B0B0B000C5C5C50000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000959595008C8C8C008B8B8B00A0A0A000ACACAC00A8A8A800999999008D8D
      8D00878787008A8A8A00B8B8B800000000000000000000000000000000000000
      0000000000000000000000000000000000009595950095959500959595009595
      9500959595009595950000000000000000000000000000000000000000000000
      00000000000000000000000000000000000095959500CECECE00F7F7F700F6F6
      F600F4F4F400F2F2F200F1F1F100EFEFEF00EDEDED00EBEBEB00EBEBEB009595
      9500CECECE00F7F7F700F6F6F600F4F4F400F2F2F200F1F1F100EFEFEF00EDED
      ED00EBEBEB00EBEBEB0095959500000000000000000000000000000000000000
      000000000000B7B7B700989898009E9E9E00A3A3A300A8A8A800A9A9A900A8A8
      A800A6A6A600A3A3A3009F9F9F009C9C9C0098989800B6B6B600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C5C5C500C4C4C400C4C4C400C6C6
      C60095959500B9B9B900B2B2B200B4B4B4009E9E9E008A8A8A00A1A1A100AEAE
      AE00A7A7A7008F8F8F0088888800BCBCBC000000000000000000000000000000
      00000000000000000000000000000000000095959500DDDDDD00EBEBEB00D0D0
      D000B5B5B5009595950000000000000000000000000000000000000000000000
      00000000000000000000000000000000000095959500CECECE00F7F7F700F6F6
      F600F5F5F500F3F3F300F1F1F100F0F0F000EEEEEE00EDEDED00EBEBEB009595
      9500CECECE00F7F7F700F6F6F600F5F5F500F3F3F300F1F1F100F0F0F000EEEE
      EE00EDEDED00EBEBEB0095959500000000000000000000000000000000000000
      000000000000A5A5A500ABABAB00B9B9B900B9B9B900B8B8B800B5B5B500AFAF
      AF00AAAAAA00A6A6A600A4A4A400A2A2A2009E9E9E0098989800BCBCBC000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B6B6B600AAAAAA00A8A8A800A7A7A700A5A5A500A2A2A200C4C4
      C40095959500BDBDBD00B9B9B900A2A2A20091919100C1C1C100000000000000
      00000000000000000000A5A5A500A7A7A7000000000000000000000000000000
      00000000000000000000000000000000000095959500DDDDDD00EBEBEB00D1D1
      D100B5B5B5009595950000000000000000009595950000000000000000000000
      00000000000000000000000000000000000095959500CFCFCF00F8F8F800F7F7
      F700F6F6F600F4F4F400F3F3F300F1F1F100F0F0F000EEEEEE00ECECEC009595
      9500CFCFCF00F8F8F800F7F7F700F6F6F600F4F4F400F3F3F300F1F1F100F0F0
      F000EEEEEE00ECECEC0095959500000000000000000000000000000000000000
      000000000000A0A0A000B5B5B500C2C2C200C2C2C200C0C0C000BDBDBD00B6B6
      B600AFAFAF00A8A8A800A5A5A500A3A3A300A1A1A10099999900AFAFAF000000
      000000000000000000000000000000000000000000000000000000000000B7B7
      B700ABABAB00C3C3C300CECECE00CACACA00C2C2C200BABABA00B3B3B300D3D3
      D30095959500BFBFBF00BBBBBB00B9B9B9008F8F8F0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000095959500DCDCDC00ECECEC00D1D1
      D100B6B6B6009595950000000000959595009E9E9E0095959500000000000000
      00000000000000000000000000000000000095959500D0D0D000F8F8F800F8F8
      F800F7F7F700F5F5F500F3F3F300F2F2F200F1F1F100EFEFEF00EDEDED009595
      9500D0D0D000F8F8F800F8F8F800F7F7F700F5F5F500F3F3F300F2F2F200F1F1
      F100EFEFEF00EDEDED0095959500000000000000000000000000000000000000
      0000000000009D9D9D00BEBEBE00CBCBCB00CDCDCD00C9C9C900C3C3C300BCBC
      BC00B4B4B400A6A6A60099999900A3A3A300A2A2A2009A9A9A00ABABAB000000
      0000000000000000000000000000000000000000000000000000B5B5B500AEAE
      AE00DDDDDD00DBDBDB00D1D1D100CACACA00C2C2C200BBBBBB00B3B3B300CACA
      CA00959595009595950095959500959595009595950095959500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000095959500DBDBDB00EDEDED00D2D2
      D200B6B6B6009595950095959500ABABAB00ABABAB009E9E9E00959595000000
      00000000000000000000000000000000000095959500D0D0D000FAFAFA00F8F8
      F800F7F7F700F6F6F600F4F4F400F3F3F300F2F2F200F0F0F000EEEEEE009595
      9500D0D0D000FAFAFA00F8F8F800F7F7F700F6F6F600F4F4F400F3F3F300F2F2
      F200F0F0F000EEEEEE0095959500000000000000000000000000000000000000
      0000000000009E9E9E00C2C2C200D3D3D300D5D5D500D1D1D100C8C8C800BFBF
      BF00AFAFAF00999999009A9A9A00A2A2A200A2A2A2009B9B9B00AEAEAE000000
      00000000000000000000000000000000000000000000C7C7C700A0A0A000CFCF
      CF00DDDDDD00DEDEDE00D8D8D800D2D2D200CDCDCD00C6C6C600C2C2C200C5C5
      C500D0D0D000D3D3D300CFCFCF00CCCCCC00CBCBCB00C4C4C400959595009595
      9500959595009595950095959500959595000000000000000000000000000000
      00000000000000000000000000000000000095959500DBDBDB00EDEDED00D2D2
      D200B7B7B70095959500ABABAB00ABABAB00ABABAB00ABABAB009E9E9E009595
      95000000000000000000000000000000000095959500D0D0D000FAFAFA00F9F9
      F900F8F8F800F7F7F700F6F6F600F4F4F400F3F3F300F1F1F100F0F0F0009595
      9500D0D0D000FAFAFA00F9F9F900F8F8F800F7F7F700F6F6F600F4F4F400F3F3
      F300F1F1F100F0F0F00095959500000000000000000000000000000000000000
      000000000000A2A2A200BFBFBF00D8D8D800DDDDDD00D3D3D300CACACA00B7B7
      B7009A9A9A00DBDBDB00ADADAD009F9F9F00A2A2A2009A9A9A00B3B3B3000000
      00000000000000000000000000000000000000000000C3C3C300A4A4A400D3D3
      D300E4E4E400DEDEDE00D0D0D000C8C8C800C0C0C000B9B9B900B4B4B400B7B7
      B700C0C0C000C1C1C100B9B9B900AEAEAE00A6A6A6009D9D9D00C5C5C5009292
      9200C2C2C200BFBFBF00BCBCBC00959595000000000000000000000000000000
      00000000000000000000000000000000000095959500DADADA00EDEDED00D3D3
      D30095959500ABABAB00ACACAC00ABABAB00ABABAB00ABABAB00ABABAB009E9E
      9E009595950000000000000000000000000095959500D0D0D000D0D0D000D0D0
      D000D0D0D000D0D0D000CFCFCF00CFCFCF00CECECE00CECECE00CECECE009595
      9500D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000CFCFCF00CFCFCF00CECE
      CE00CECECE00CECECE0095959500000000000000000000000000000000000000
      000000000000ADADAD00ADADAD00D3D3D300D5D5D500D1D1D100C1C1C1009D9D
      9D00E1E1E100F8F8F800BFBFBF009D9D9D00A2A2A20098989800BFBFBF000000
      00000000000000000000000000000000000000000000C3C3C300ABABAB00DBDB
      DB00D5D5D500D1D1D100CDCDCD00C7C7C700BFBFBF00B8B8B800B2B2B200B9B9
      B900AAAAAA00ADADAD00D0D0D000C0C0C000C1C1C100B4B4B400BDBDBD009191
      9100ABABAB00C2C2C200BFBFBF00959595000000000000000000000000000000
      00000000000000000000000000000000000095959500D5D5D500E8E8E8009595
      9500ABABAB00ACACAC00ACACAC00ACACAC00ACACAC00ABABAB00ABABAB00ABAB
      AB009E9E9E0095959500000000000000000095959500D0D0D000CACACA00C5C5
      C500BFBFBF00BABABA00B4B4B400AFAFAF00ABABAB00A7A7A700A5A5A5009595
      9500D0D0D000CACACA00C5C5C500BFBFBF00BABABA00B4B4B400AFAFAF00ABAB
      AB00A7A7A700A5A5A50095959500000000000000000000000000000000000000
      000000000000C2C2C20098989800C0C0C000CDCDCD00C6C6C6009F9F9F00D8D8
      D800FCFCFC00FAFAFA00D3D3D3009E9E9E009F9F9F009A9A9A00000000000000
      00000000000000000000000000000000000000000000C3C3C300ADADAD00CECE
      CE00D8D8D800DADADA00D1D1D100C9C9C900C0C0C000B9B9B900B2B2B200B6B6
      B600C3C3C3008C8C8C0094949400B9B9B900C7C7C700A9A9A9008B8B8B00ADAD
      AD00C8C8C800BFBFBF00C2C2C200959595000000000000000000000000000000
      0000000000000000000000000000B9B9B900959595009595950095959500D2D2
      D200D2D2D200D2D2D200D2D2D200ACACAC00ACACAC00ACACAC009E9E9E009E9E
      9E009E9E9E009E9E9E00959595000000000095959500D0D0D000CBCBCB00C5C5
      C500BFBFBF00BABABA00B5B5B500AFAFAF00ACACAC00A8A8A800A5A5A5009595
      9500D0D0D000CBCBCB00C5C5C500BFBFBF00BABABA00B5B5B500AFAFAF00ACAC
      AC00A8A8A800A5A5A50095959500000000000000000000000000000000000000
      00000000000000000000B8B8B80099999900B2B2B2009C9C9C00919191008B8B
      8B008B8B8B009C9C9C00B8B8B8009D9D9D009B9B9B00B1B1B100000000000000
      00000000000000000000000000000000000000000000C5C5C500A3A3A300CECE
      CE00DBDBDB00DBDBDB00D5D5D500D0D0D000CACACA00C4C4C400BFBFBF00BBBB
      BB00C1C1C100CACACA00909090008787870095959500B2B2B200CACACA00C6C6
      C600ADADAD008C8C8C008D8D8D00959595000000000000000000000000000000
      00000000000000000000C7C7C7009C9C9C00C5C5C50095959500959595009595
      95009595950095959500D2D2D200ACACAC00ACACAC00ACACAC009E9E9E009595
      95009595950095959500959595009595950095959500D0D0D000CBCBCB00C5C5
      C500BFBFBF00BBBBBB00B5B5B500B0B0B000ACACAC00A8A8A800A5A5A5009595
      9500D0D0D000CBCBCB00C5C5C500BFBFBF00BBBBBB00B5B5B500B0B0B000ACAC
      AC00A8A8A800A5A5A50095959500000000000000000000000000000000000000
      0000000000000000000000000000ADADAD008F8F8F00ACACAC00C6C6C600CDCD
      CD00C6C6C600B2B2B200999999008F8F8F0099999900C7C7C700000000000000
      00000000000000000000000000000000000000000000C4C4C400A4A4A400D0D0
      D000E3E3E300E3E3E300D5D5D500CCCCCC00C4C4C400BFBFBF00BBBBBB00B9B9
      B900B9B9B900C2C2C200D1D1D100BDBDBD009696960087878700878787008C8C
      8C00A0A0A000BCBCBC0000000000959595000000000000000000000000000000
      00000000000000000000ADADAD00A8A8A800DDDDDD00E3E3E300E6E6E600E3E3
      E300D8D8D80095959500D2D2D200ADADAD00ACACAC00ACACAC009E9E9E009595
      9500000000000000000000000000000000009595950095959500959595009595
      9500959595009595950095959500959595009595950095959500959595009595
      9500959595009595950095959500959595009595950095959500959595009595
      9500959595009595950095959500000000000000000000000000000000000000
      000000000000C5C5C5009797970090909000C4C4C400D2D2D200D2D2D200D2D2
      D200D1D1D100CECECE00C3C3C300A6A6A60091919100C5C5C500000000000000
      00000000000000000000000000000000000000000000C3C3C300A8A8A800DBDB
      DB00DADADA00D1D1D100CBCBCB00C5C5C500BFBFBF00B7B7B700B1B1B100AEAE
      AE00ABABAB00A9A9A900AFAFAF00BFBFBF00CBCBCB00BEBEBE00C4C4C4000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C1C1C10098989800CFCFCF00E2E2E200E4E4E400E5E5E500E0E0
      E000DADADA0095959500D2D2D200ADADAD00ADADAD00ACACAC009E9E9E009595
      95000000000000000000000000000000000095959500CECECE00F7F7F700F6F6
      F600F4F4F400F2F2F200F1F1F100EFEFEF00EDEDED00EBEBEB00EBEBEB009595
      9500CECECE00F7F7F700F6F6F600F4F4F400F2F2F200F1F1F100EFEFEF00EDED
      ED00EBEBEB00EBEBEB0095959500000000000000000000000000000000000000
      000000000000B2B2B2008B8B8B009A9A9A00D4D4D400D5D5D500D5D5D500D5D5
      D500D3D3D300D2D2D200CFCFCF00C1C1C1009C9C9C00A8A8A800000000000000
      00000000000000000000000000000000000000000000C3C3C300AEAEAE00D1D1
      D100D5D5D500D8D8D800D1D1D100C9C9C900C0C0C000B8B8B800B2B2B200AFAF
      AF00ACACAC00AAAAAA00A6A6A600A2A2A200A9A9A90098989800C2C2C2000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000A4A4A400B7B7B700DCDCDC00E7E7E700E5E5E500E4E4E400DEDE
      DE00D9D9D90095959500D2D2D200ADADAD00ADADAD00ADADAD009E9E9E009595
      95000000000000000000000000000000000095959500CECECE00F7F7F700F6F6
      F600F5F5F500F3F3F300F1F1F100F0F0F000EEEEEE00EDEDED00EBEBEB009595
      9500CECECE00F7F7F700F6F6F600F5F5F500F3F3F300F1F1F100F0F0F000EEEE
      EE00EDEDED00EBEBEB0095959500000000000000000000000000000000000000
      000000000000A1A1A1008F8F8F0091919100D2D2D200D8D8D800D2D2D200D0D0
      D000D0D0D000D0D0D000D0D0D000C9C9C900B1B1B10093939300000000000000
      00000000000000000000000000000000000000000000C4C4C400A4A4A400CDCD
      CD00DBDBDB00D9D9D900D2D2D200CECECE00C8C8C800C2C2C200BBBBBB00B6B6
      B600B0B0B000ABABAB00A7A7A700A4A4A400A2A2A20092929200C3C3C3000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000B9B9B9009D9D9D00D5D5D500E3E3E300EAEAEA00E6E6E600E1E1E100DDDD
      DD00D7D7D70095959500D2D2D200AEAEAE00ADADAD00ADADAD009E9E9E009595
      95000000000000000000000000000000000095959500CFCFCF00F8F8F800F7F7
      F700F6F6F600F4F4F400F3F3F300F1F1F100F0F0F000EEEEEE00ECECEC009595
      9500CFCFCF00F8F8F800F7F7F700F6F6F600F4F4F400F3F3F300F1F1F100F0F0
      F000EEEEEE00ECECEC0095959500000000000000000000000000000000000000
      000000000000989898009494940090909000B1B1B100ACACAC009D9D9D009696
      960098989800A0A0A000AAAAAA00B6B6B600B9B9B9008C8C8C00000000000000
      00000000000000000000000000000000000000000000C4C4C400A3A3A300CECE
      CE00E0E0E000E6E6E600E1E1E100DBDBDB00D6D6D600D2D2D200CECECE00CACA
      CA00C3C3C300BDBDBD00B2B2B200A7A7A700A3A3A30091919100C3C3C3000000
      000000000000000000000000000000000000000000000000000000000000C7C7
      C7009C9C9C00C1C1C100DADADA00EBEBEB00EBEBEB00E4E4E400E0E0E000DBDB
      DB00D5D5D50095959500D2D2D200D2D2D200D2D2D200D2D2D200D2D2D2009595
      95000000000000000000000000000000000095959500D0D0D000F8F8F800F8F8
      F800F7F7F700F5F5F500F3F3F300F2F2F200F1F1F100EFEFEF00EDEDED009595
      9500D0D0D000F8F8F800F8F8F800F7F7F700F5F5F500F3F3F300F2F2F200F1F1
      F100EFEFEF00EDEDED0095959500000000000000000000000000000000000000
      0000000000009696960096969600969696008B8B8B0094949400969696009898
      98009696960092929200919191008F8F8F008F8F8F008D8D8D00000000000000
      00000000000000000000000000000000000000000000C3C3C300A5A5A500DBDB
      DB00E8E8E800E3E3E300DBDBDB00D6D6D600D2D2D200D0D0D000CCCCCC00C8C8
      C800C4C4C400C1C1C100BEBEBE00B7B7B700ABABAB0091919100C2C2C2000000
      000000000000000000000000000000000000000000000000000000000000AEAE
      AE00A6A6A600D5D5D500E3E3E300EFEFEF00EBEBEB00E3E3E300DEDEDE00D8D8
      D800D3D3D3009595950095959500959595009595950095959500959595009595
      95000000000000000000000000000000000095959500D0D0D000FAFAFA00F8F8
      F800F7F7F700F6F6F600F4F4F400F3F3F300F2F2F200F0F0F000EEEEEE009595
      9500D0D0D000FAFAFA00F8F8F800F7F7F700F6F6F600F4F4F400F3F3F300F2F2
      F200F0F0F000EEEEEE0095959500000000000000000000000000000000000000
      0000000000009C9C9C00969696009D9D9D009E9E9E009F9F9F009E9E9E009C9C
      9C009A9A9A00999999009696960095959500939393008C8C8C00BCBCBC000000
      00000000000000000000000000000000000000000000C3C3C300AFAFAF00E3E3
      E300DEDEDE00DDDDDD00DADADA00D6D6D600D2D2D200D0D0D000CCCCCC00C8C8
      C800C4C4C400C0C0C000BDBDBD00B9B9B900B5B5B50097979700C2C2C2000000
      0000000000000000000000000000000000000000000000000000C1C1C1009898
      9800CACACA00D8D8D800EDEDED00F1F1F100EAEAEA00E1E1E100DCDCDC00D6D6
      D600D1D1D100CDCDCD00C5C5C500B8B8B800ACACAC00A3A3A3009B9B9B00C7C7
      C7000000000000000000000000000000000095959500D0D0D000FAFAFA00F9F9
      F900F8F8F800F7F7F700F6F6F600F4F4F400F3F3F300F1F1F100F0F0F0009595
      9500D0D0D000FAFAFA00F9F9F900F8F8F800F7F7F700F6F6F600F4F4F400F3F3
      F300F1F1F100F0F0F00095959500000000000000000000000000000000000000
      000000000000ACACAC00929292009E9E9E00A0A0A000A1A1A100A0A0A0009E9E
      9E009B9B9B00999999009797970095959500959595008D8D8D00C1C1C1000000
      00000000000000000000000000000000000000000000C3C3C300B4B4B400E2E2
      E200DFDFDF00DEDEDE00DADADA00D6D6D600D2D2D200D0D0D000CCCCCC00C8C8
      C800C4C4C400C0C0C000BDBDBD00B9B9B900B5B5B5009C9C9C00C2C2C2000000
      0000000000000000000000000000000000000000000000000000A4A4A400B3B3
      B300D4D4D400E1E1E100F3F3F300F4F4F400E5E5E500DFDFDF00DADADA00D5D5
      D500D0D0D000CBCBCB00C5C5C500B9B9B900ADADAD00A5A5A5009C9C9C00B0B0
      B0000000000000000000000000000000000095959500D0D0D000D0D0D000D0D0
      D000D0D0D000D0D0D000CFCFCF00CFCFCF00CECECE00CECECE00CECECE009595
      9500D0D0D000D0D0D000D0D0D000D0D0D000D0D0D000CFCFCF00CFCFCF00CECE
      CE00CECECE00CECECE0095959500000000000000000000000000000000000000
      000000000000C2C2C2008E8E8E009D9D9D00A2A2A200A3A3A300A1A1A1009F9F
      9F009B9B9B009999990097979700959595009292920095959500000000000000
      0000000000000000000000000000000000000000000000000000A8A8A800E1E1
      E100E0E0E000DEDEDE00DADADA00D6D6D600D2D2D200D0D0D000CCCCCC00C8C8
      C800C4C4C400C0C0C000BDBDBD00B9B9B900B5B5B50099999900C6C6C6000000
      00000000000000000000000000000000000000000000B9B9B9009D9D9D00D0D0
      D000D6D6D600EDEDED00F6F6F600F4F4F400E3E3E300DDDDDD00D8D8D800D3D3
      D300CECECE00C9C9C900C3C3C300BBBBBB00AFAFAF00A6A6A6009F9F9F009898
      9800C4C4C40000000000000000000000000095959500D0D0D000CACACA00C5C5
      C500BFBFBF00BABABA00B4B4B400AFAFAF00ABABAB00A7A7A700A5A5A5009595
      9500D0D0D000CACACA00C5C5C500BFBFBF00BABABA00B4B4B400AFAFAF00ABAB
      AB00A7A7A700A5A5A50095959500000000000000000000000000000000000000
      00000000000000000000ACACAC00909090009F9F9F00A2A2A200A0A0A0009E9E
      9E009B9B9B009999990097979700939393008E8E8E00BCBCBC00000000000000
      0000000000000000000000000000000000000000000000000000B8B8B800B6B6
      B600E0E0E000E0E0E000DBDBDB00D6D6D600D2D2D200D0D0D000CCCCCC00C8C8
      C800C4C4C400C0C0C000BEBEBE00B9B9B9009F9F9F00B3B3B300000000000000
      000000000000000000000000000000000000C7C7C7009C9C9C00BDBDBD00D3D3
      D300DDDDDD00F8F8F800F8F8F800F0F0F000E1E1E100DBDBDB00D6D6D600D1D1
      D100CDCDCD00C7C7C700C2C2C200BBBBBB00B0B0B000A7A7A7009F9F9F009A9A
      9A00A9A9A90000000000000000000000000095959500D0D0D000CBCBCB00C5C5
      C500BFBFBF00BABABA00B5B5B500AFAFAF00ACACAC00A8A8A800A5A5A5009595
      9500D0D0D000CBCBCB00C5C5C500BFBFBF00BABABA00B5B5B500AFAFAF00ACAC
      AC00A8A8A800A5A5A50095959500000000000000000000000000000000000000
      0000000000000000000000000000ABABAB008E8E8E0095959500999999009C9C
      9C009A9A9A0095959500929292008F8F8F00B8B8B80000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BBBB
      BB00B0B0B000C7C7C700D5D5D500D7D7D700D4D4D400D1D1D100CDCDCD00C9C9
      C900C4C4C400BEBEBE00ACACAC009F9F9F00B6B6B60000000000000000000000
      000000000000000000000000000000000000AFAFAF00A5A5A500D0D0D000D5D5
      D500ECECEC00FBFBFB00FAFAFA00EBEBEB00DFDFDF00DADADA00D4D4D400D0D0
      D000CACACA00C5C5C500C0C0C000BBBBBB00B1B1B100A8A8A800A0A0A0009A9A
      9A0097979700BEBEBE00000000000000000095959500D0D0D000CBCBCB00C5C5
      C500BFBFBF00BBBBBB00B5B5B500B0B0B000ACACAC00A8A8A800A5A5A5009595
      9500D0D0D000CBCBCB00C5C5C500BFBFBF00BBBBBB00B5B5B500B0B0B000ACAC
      AC00A8A8A800A5A5A50095959500000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C000A5A5A500959595008B8B
      8B008B8B8B0095959500AAAAAA00C4C4C4000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000BBBBBB00AEAEAE00ADADAD00AFAFAF00B0B0B000AFAFAF00AAAA
      AA00A6A6A600A8A8A800B7B7B700000000000000000000000000000000000000
      0000000000000000000000000000000000009696960095959500959595009595
      9500959595009595950095959500959595009595950095959500959595009595
      9500959595009595950095959500959595009595950095959500959595009595
      950095959500A1A1A10000000000000000009595950095959500959595009595
      9500959595009595950095959500959595009595950095959500959595009595
      9500959595009595950095959500959595009595950095959500959595009595
      9500959595009595950095959500000000000000000000000000000000000000
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
      2800000060000000600000000100010000000000800400000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFF820FFFFFFFFFFFFFFF18FE00000BF
      FFFDBFFFFDBFE105E00000FFFFFFFFFFFFFF8003E00000BFC3FDBFC3FDBF8001
      E00000FFC3FFFFC3FFFFC007E00000BFC3FDBFC3FDBF0000E00001FFC3FFFFC3
      FFFF0000E00001BFC3FDBFC3FDBF0180E00001FFC3FFFFC3FFFF0180E00007BD
      C3BDBBC3DDBF0000E00007FCC33FF3C3CFFF0000E00007A04205A04205BFC005
      E00007E00007C04203FFC003E00007A04205A04205BF8001E00007FCC33FF3C3
      CFFFC003E00007BDC3BDBBC3DDBFC18DE0000FFFC3FFFFC3FFFFC3FFE0001F80
      0001800001800001E0003FBF00FDBF00FDBF00FDE0007FBF00FDBF00FDBF00FD
      E000FFBF00FDBF00FDBF00FDE001FF800001800001800001E003FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE107FFFFFFFFFFFFFFF820FF8003E0
      0007E00007E00000000000E00007E00007E00000000000E00007E00007E00000
      000000E00007E00007E00000000000E00007E00007E00000000000E00007E000
      07E00001000000E00007E00007E00001000000E00007E00007E00001000000E0
      0007E00007E00007000000E00007E00007E00007000000E00007E00007E00007
      000000E00007E00007E00007000000E00007E00007E00007000000E00007E000
      07E00007000000E00007E00007E00007000000E00007E0000FE00007000000E0
      0007E0001FE00007000000E00007E0003FE00007000000E00007E0007FE00007
      000000E00007E000FFE00007FFFFFFE00007E001FFE00007FFFFFFE00007E003
      FFE00007FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF403FFFFFF000001FC007FFF
      F001FF03FF000001F8003FFF0000FF03FF000001F8001FF8003CFF037F000001
      F8001FE0007FFF023F000001F8001FC0003FFF001F000001F8001F800000FF00
      0F000001F8001F800000FF0007000001F8001F800000FF0003000001F8003F80
      0000FE0001000001FC003F800000FC0000000001FE003F800002FC000F000001
      F8003F80001FF8000F000001F8003F80001FF8000F000001F8003F80001FF000
      0F000001F8003F80001FE0000F000001F8003F80001FE0000F000001F8001F80
      001FC0000F000001F8001F80001FC0000F000001F8003FC0001F800007000001
      FC003FC0003F000007000001FE007FE0007F000003000001FF00FFF801FF0000
      03000001FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object MagPublisher1: TMagPublisher
    Left = 644
    Top = 260
  end
  object OpenDialogListWin: TOpenDialog
    Left = 252
    Top = 184
  end
  object listwinResizeTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = listwinResizeTimerTimer
    Left = 248
    Top = 412
  end
  object MagSubscriber1: TMagSubscriber
    OnSubscriberUpdate = MagSubscriber1SubscriberUpdate
    Publisher = MagPublisher1
    Left = 640
    Top = 316
  end
  object ColorDialog1: TColorDialog
    Left = 256
    Top = 144
  end
  object popupAbstracts: TPopupMenu
    HelpContext = 10000
    OnPopup = popupAbstractsPopup
    Left = 50
    Top = 100
    object mnuOpen3: TMenuItem
      Caption = 'Open Image'
      OnClick = mnuOpen3Click
    end
    object mnuViewImagein2ndRadiologyWindow3: TMenuItem
      Caption = 'Open Image in 2nd Radiology Window'
      Visible = False
      OnClick = mnuViewImagein2ndRadiologyWindow3Click
    end
    object mnuImageReport3: TMenuItem
      Caption = 'Image Report'
      ImageIndex = 16
      OnClick = mnuImageReport3Click
    end
    object mnuImageDelete3: TMenuItem
      Caption = 'Image Delete...'
      ImageIndex = 44
      Visible = False
      OnClick = mnuImageDelete3Click
    end
    object mnuImageIndexEditAbs3: TMenuItem
      Caption = 'Image Index Edit...'
      OnClick = mnuImageIndexEditAbs3Click
    end
    object mnuImageInformation3: TMenuItem
      Caption = 'Image Information...'
      HelpContext = 10095
      ImageIndex = 43
      OnClick = mnuImageInformation3Click
    end
    object mnuImageInformationAdvanced3: TMenuItem
      Caption = 'Image Information Advanced...'
      OnClick = mnuImageInformationAdvanced3Click
    end
    object mnuCacheGroup3: TMenuItem
      Caption = 'Cache Images'
      OnClick = mnuCacheGroup3Click
    end
    object MenuItem2: TMenuItem
      Caption = '-'
    end
    object mnuRefresh3: TMenuItem
      Caption = 'Refresh'
      ImageIndex = 12
      ShortCut = 16466
    end
    object mnuResizetheAbstracts3: TMenuItem
      Caption = 'Resize the Abstracts...'
      OnClick = mnuResizetheAbstracts3Click
    end
    object MenuItem3: TMenuItem
      Caption = '-'
      Visible = False
    end
    object mnuFontSize3: TMenuItem
      Caption = 'Font Size'
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
    object mnuToolbar3: TMenuItem
      AutoCheck = True
      Caption = 'Toolbar'
      Checked = True
      ShortCut = 16468
      OnClick = mnuToolbar3Click
    end
    object mnuAbsViewerScroll: TMenuItem
      Caption = 'Scroll'
      OnClick = mnuAbsViewerScrollClick
      object mnuAbsViewerScrollHoriz: TMenuItem
        Caption = 'Horizontal'
        OnClick = mnuAbsViewerScrollHorizClick
      end
      object mnuAbsViewerScrollVert: TMenuItem
        Caption = 'Vertical'
        OnClick = mnuAbsViewerScrollVertClick
      end
    end
    object MenuItem12: TMenuItem
      Caption = '-'
    end
  end
  object popupImage: TPopupMenu
    HelpContext = 10087
    OnPopup = popupImagePopup
    Left = 576
    Top = 531
    object mnuZoom4: TMenuItem
      Caption = 'Zoom'
      object ZoomIn4: TMenuItem
        Caption = 'Zoom In         Shift+Ctrl+I'
        OnClick = ZoomIn4Click
      end
      object ZoomOut4: TMenuItem
        Caption = 'Zoom Out      Shift+Ctrl+O'
        OnClick = ZoomOut4Click
      end
      object mnuFitToWidth4: TMenuItem
        Caption = 'Fit to Width'
        ImageIndex = 24
        OnClick = mnuFitToWidth4Click
      end
      object mmuFitToWindow4: TMenuItem
        Caption = 'Fit to Window'
        ImageIndex = 22
        OnClick = mmuFitToWindow4Click
      end
      object mnuActualSize4: TMenuItem
        Caption = 'Actual Size'
        ImageIndex = 29
        OnClick = mnuActualSize4Click
      end
    end
    object mnuMouse4: TMenuItem
      Caption = 'Mouse'
      object mnuMousePan4: TMenuItem
        Caption = 'Pan'
        ImageIndex = 7
        OnClick = mnuMousePan4Click
      end
      object mnuMouseMagnify4: TMenuItem
        Caption = 'Magnify'
        ImageIndex = 9
        OnClick = mnuMouseMagnify4Click
      end
      object mnuMouseZoom4: TMenuItem
        Caption = 'Zoom'
        ImageIndex = 10
        OnClick = mnuMouseZoom4Click
      end
      object mnuMousePointer4: TMenuItem
        Caption = 'Pointer'
        ImageIndex = 40
        OnClick = mnuMousePointer4Click
      end
    end
    object mnuRotate4: TMenuItem
      Caption = 'Rotate'
      object mnuRotateRight4: TMenuItem
        Caption = 'Right'
        ImageIndex = 26
        OnClick = mnuRotateRight4Click
      end
      object mnuRotateLeft4: TMenuItem
        Caption = 'Left'
        ImageIndex = 25
        OnClick = mnuRotateLeft4Click
      end
      object mnuRotate1804: TMenuItem
        Caption = '180'
        ImageIndex = 27
        OnClick = mnuRotate1804Click
      end
      object FlipHorizontal4: TMenuItem
        Caption = 'Flip Horizontal'
        ImageIndex = 31
        OnClick = FlipHorizontal4Click
      end
      object FlipVertical4: TMenuItem
        Caption = 'Flip Vertical'
        ImageIndex = 32
        OnClick = FlipVertical4Click
      end
    end
    object mnuInvert4: TMenuItem
      Caption = 'Invert Image'
      OnClick = mnuInvert4Click
    end
    object mnuReset4: TMenuItem
      Caption = 'Reset Image'
      ShortCut = 24659
      OnClick = mnuReset4Click
    end
    object mnuRemoveImage4: TMenuItem
      Caption = 'Close Selected Image(s)'
      OnClick = mnuRemoveImage4Click
    end
    object N34: TMenuItem
      Caption = '-'
    end
    object mnuVerifyFull4: TMenuItem
      Caption = 'Image Status =>  &QA Reviewed'
      OnClick = mnuVerifyFull4Click
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object mnuImageReport4: TMenuItem
      Caption = 'Image Report'
      ImageIndex = 16
      OnClick = mnuImageReport4Click
    end
    object mnuImageDelete4: TMenuItem
      Caption = 'Image Delete...'
      ImageIndex = 44
      Visible = False
      OnClick = mnuImageDelete4Click
    end
    object mnuImageIndexEditFull4: TMenuItem
      Caption = 'Image Index Edit...'
      OnClick = mnuImageIndexEditFull4Click
    end
    object mnuImageInformation4: TMenuItem
      Caption = 'Image Information...'
      ImageIndex = 43
      OnClick = mnuImageInformation4Click
    end
    object mnuImageInformationAdvanced4: TMenuItem
      Caption = 'Image Information Advanced...'
      OnClick = mnuImageInformationAdvanced4Click
    end
    object MenuItem7: TMenuItem
      Caption = '-'
    end
    object mnuFontSize4: TMenuItem
      Caption = 'Font Size'
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
    object mnuToolbar4: TMenuItem
      AutoCheck = True
      Caption = 'Toolbar'
      Checked = True
      ShortCut = 16468
      OnClick = mnuToolbar4Click
    end
  end
  object PopupTree: TPopupMenu
    OnPopup = PopupTreePopup
    Left = 160
    Top = 145
    object mnuOpenImage6: TMenuItem
      Caption = 'Open Image'
      OnClick = mnuOpenImage6Click
    end
    object mnuOpenin2ndRadWindow6: TMenuItem
      Caption = 'Open in 2nd Rad Window'
      OnClick = mnuOpenin2ndRadWindow6Click
    end
    object mnuImageReport6: TMenuItem
      Caption = 'Image Report'
      OnClick = mnuImageReport6Click
    end
    object mnuImageDelete6: TMenuItem
      Caption = 'Image Delete...'
      OnClick = mnuImageDelete6Click
    end
    object mnuImageIndexEditTree6: TMenuItem
      Caption = 'Image Index Edit...'
      OnClick = mnuImageIndexEditTree6Click
    end
    object mnuImageInformation6: TMenuItem
      Caption = 'Image Information...'
      OnClick = mnuImageInformation6Click
    end
    object mnuImageInformationAdvanced6: TMenuItem
      Caption = 'Image Information Advanced...'
      OnClick = mnuImageInformationAdvanced6Click
    end
    object mnuCacheGroup6: TMenuItem
      Caption = 'Cache Image'
      OnClick = mnuCacheGroup6Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mnuSortButtons6: TMenuItem
      AutoCheck = True
      Caption = 'Sort Buttons'
      OnClick = mnuSortButtons6Click
    end
    object AutoExpandCollapse1: TMenuItem
      AutoCheck = True
      Caption = 'Auto Expand Collapse'
      OnClick = AutoExpandCollapse1Click
    end
    object N29: TMenuItem
      Caption = '-'
    end
    object mnuSorts6: TMenuItem
      Caption = 'Sorts'
      object mnuPackage6: TMenuItem
        Caption = 'Package'
        OnClick = mnuPackage6Click
      end
      object mnuSpecialty6: TMenuItem
        Caption = 'Specialty'
        OnClick = mnuSpecialty6Click
      end
      object mnuEvent6: TMenuItem
        Caption = 'Event'
        Visible = False
        OnClick = mnuEvent6Click
      end
      object mnuType6: TMenuItem
        Caption = 'Type'
        OnClick = mnuType6Click
      end
      object mnuClass6: TMenuItem
        Caption = 'Class'
        OnClick = mnuClass6Click
      end
      object N28: TMenuItem
        Caption = '-'
      end
      object mnuSpecialtyEvent6: TMenuItem
        Caption = 'Specialty - Event'
        OnClick = mnuSpecialtyEvent6Click
      end
      object mnuTypeSpecialty6: TMenuItem
        Caption = 'Type - Specialty'
        OnClick = mnuTypeSpecialty6Click
      end
      object mnuPackageType6: TMenuItem
        Caption = 'Package - Type'
        OnClick = mnuPackageType6Click
      end
      object mnuCustom6: TMenuItem
        Caption = 'Custom...'
        OnClick = mnuCustom6Click
      end
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object mnuExpandAll6: TMenuItem
      Caption = 'Expand All'
      OnClick = mnuExpandAll6Click
    end
    object mnuExpand1level6: TMenuItem
      Caption = 'Expand 1 level'
      OnClick = mnuExpand1level6Click
    end
    object mnuCollapseAll6: TMenuItem
      Caption = 'Collapse All'
      OnClick = mnuCollapseAll6Click
    end
    object mnuAlphabeticSort6: TMenuItem
      Caption = 'Alpha Sort'
      Visible = False
      OnClick = mnuAlphabeticSort6Click
    end
    object N26: TMenuItem
      Caption = '-'
    end
    object mnuRefresh6: TMenuItem
      Caption = 'Refresh'
      OnClick = mnuRefresh6Click
    end
  end
  object MagSubscriber_Msgs: TMagSubscriber
    OnSubscriberUpdate = MagSubscriber_MsgsSubscriberUpdate
    Publisher = MagPublisher1
    Left = 700
    Top = 320
  end
end
