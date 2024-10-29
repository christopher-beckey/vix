object fraImageInfo: TfraImageInfo
  Left = 0
  Top = 0
  Width = 521
  Height = 269
  Constraints.MinHeight = 225
  TabOrder = 0
  DesignSize = (
    521
    269)
  object lbinfo: TLabel
    Left = 15
    Top = 212
    Width = 177
    Height = 38
    AutoSize = False
    Caption = 'UNDER DEVELOPMENT'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object ScrollBox1: TScrollBox
    Left = 200
    Top = 8
    Width = 315
    Height = 244
    HorzScrollBar.Tracking = True
    VertScrollBar.Range = 14
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoScroll = False
    Color = clInfoBk
    ParentColor = False
    TabOrder = 0
    DesignSize = (
      311
      240)
    object lbImageInfo: TLabel
      Left = 0
      Top = 0
      Width = 311
      Height = 14
      Align = alTop
      Color = clInfoBk
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object btnClose: TBitBtn
      Left = 292
      Top = 2
      Width = 19
      Height = 19
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'X'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Lucida Console'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 0
      OnClick = btnCloseClick
      NumGlyphs = 2
    end
  end
  object Panel1: TPanel
    Left = 5
    Top = 5
    Width = 188
    Height = 195
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 1
    object Mag4Vgear1: TMag4Vgear
      Left = 3
      Top = 5
      Width = 414
      Height = 237
      TabOrder = 0
      SelectionWidth = 4
      ShowImageOnly = False
      AbstractImage = False
      ZoomWindow = False
      PanWindow = False
      IsDragAble = False
      IsSizeAble = False
      AutoRedraw = False
      Selected = False
      ListIndex = -1
      PageCount = 0
      Page = 0
      ImageDescription = '<image description>'
      FontSize = 0
      ViewStyle = MagGearViewAbs
      ImageViewState = MagGearImageViewAbs
      ImageLoaded = False
      ShowPixelValues = False
      HistogramWindowLevel = True
      ShowLabels = True
      ImageNumber = 0
      DesignSize = (
        414
        237)
    end
  end
end
