object frmReleaseOfInfoPrint: TfrmReleaseOfInfoPrint
  Left = 675
  Top = 262
  Caption = 'Process Images for:'
  ClientHeight = 620
  ClientWidth = 745
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 750
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlClient: TPanel
    Left = 0
    Top = 0
    Width = 745
    Height = 620
    Align = alClient
    TabOrder = 0
    object pnlSummary: TPanel
      Left = 1
      Top = 425
      Width = 743
      Height = 194
      Align = alClient
      TabOrder = 0
      object pnlSummaryHeadings: TPanel
        Left = 1
        Top = 1
        Width = 741
        Height = 24
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 5
          Top = 5
          Width = 194
          Height = 16
          Caption = 'Image Processing Summary'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
      object lstSummary: TListBox
        Left = 1
        Top = 25
        Width = 741
        Height = 168
        TabStop = False
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 1
      end
    end
    object pnlImage: TPanel
      Left = 1
      Top = 1
      Width = 743
      Height = 424
      Align = alTop
      TabOrder = 1
      object pnlPatientInfo: TPanel
        Left = 1
        Top = 1
        Width = 420
        Height = 422
        Align = alClient
        BevelInner = bvLowered
        Color = clInfoBk
        ParentBackground = False
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        object lblDOB: TLabel
          Left = 160
          Top = 34
          Width = 29
          Height = 16
          Caption = 'DOB'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblFilter: TLabel
          Left = 10
          Top = 108
          Width = 140
          Height = 16
          Caption = 'Current Image Filter:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          Visible = False
        end
        object lblMatches: TLabel
          Left = 20
          Top = 138
          Width = 186
          Height = 16
          Caption = '0 of 0 Images matches for Filter:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object Label2: TLabel
          Left = 10
          Top = 34
          Width = 37
          Height = 16
          Caption = 'DOB:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label3: TLabel
          Left = 260
          Top = 34
          Width = 36
          Height = 16
          Caption = 'SSN:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label4: TLabel
          Left = 10
          Top = 59
          Width = 136
          Height = 16
          Caption = 'Service Connected:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label5: TLabel
          Left = 10
          Top = 83
          Width = 41
          Height = 16
          Caption = 'Type:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblSSN: TLabel
          Left = 310
          Top = 34
          Width = 28
          Height = 16
          Caption = 'SSN'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblConnected: TLabel
          Left = 160
          Top = 58
          Width = 27
          Height = 16
          Caption = 'YES'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lblType: TLabel
          Left = 160
          Top = 83
          Width = 36
          Height = 16
          Caption = 'TYPE'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object lbdescPatient: TLabel
          Left = 10
          Top = 10
          Width = 53
          Height = 16
          Caption = 'Patient:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          OnMouseDown = lbdescPatientMouseDown
        end
        object lbPatient: TLabel
          Left = 98
          Top = 10
          Width = 54
          Height = 16
          Caption = '<patient>'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
        end
        object pnlButtons: TPanel
          Left = 2
          Top = 176
          Width = 416
          Height = 244
          Align = alBottom
          BevelEdges = []
          BevelOuter = bvNone
          ParentBackground = False
          TabOrder = 0
          object pgROIOutput: TPageControl
            Left = 4
            Top = 8
            Width = 406
            Height = 233
            ActivePage = tsToPrint
            OwnerDraw = True
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnChange = pgROIOutputChange
            OnChanging = pgROIOutputChanging
            OnDrawTab = pgROIOutputDrawTab
            OnMouseMove = pgROIOutputMouseMove
            object tsToPrint: TTabSheet
              Hint = 'Print the disclosure request'
              Caption = 'Print the Disclosure'
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              DesignSize = (
                398
                205)
              object cbSuppress: TCheckBox
                Left = 67
                Top = 68
                Width = 210
                Height = 17
                Caption = 'Supress printing of Print Summary'
                Color = clBtnFace
                ParentColor = False
                TabOrder = 0
              end
              object btnPrint: TBitBtn
                Left = 67
                Top = 120
                Width = 75
                Height = 25
                Anchors = [akTop, akRight]
                Caption = '&Print'
                Default = True
                TabOrder = 1
                OnClick = btnPrintClick
                Glyph.Data = {
                  76010000424D7601000000000000760000002800000020000000100000000100
                  04000000000000010000130B0000130B00001000000000000000000000000000
                  800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
                  00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
                  8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
                  8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
                  8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
                  03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
                  03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
                  33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
                  33333337FFFF7733333333300000033333333337777773333333}
                NumGlyphs = 2
              end
              object btnAbort: TBitBtn
                Left = 174
                Top = 120
                Width = 75
                Height = 25
                Anchors = [akTop, akRight]
                Caption = '&Abort'
                Enabled = False
                TabOrder = 2
                OnClick = btnAbortClick
                Glyph.Data = {
                  DE010000424DDE01000000000000760000002800000024000000120000000100
                  0400000000006801000000000000000000001000000000000000000000000000
                  80000080000000808000800000008000800080800000C0C0C000808080000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                  333333333333333333333333000033338833333333333333333F333333333333
                  0000333911833333983333333388F333333F3333000033391118333911833333
                  38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
                  911118111118333338F3338F833338F3000033333911111111833333338F3338
                  3333F8330000333333911111183333333338F333333F83330000333333311111
                  8333333333338F3333383333000033333339111183333333333338F333833333
                  00003333339111118333333333333833338F3333000033333911181118333333
                  33338333338F333300003333911183911183333333383338F338F33300003333
                  9118333911183333338F33838F338F33000033333913333391113333338FF833
                  38F338F300003333333333333919333333388333338FFF830000333333333333
                  3333333333333333333888330000333333333333333333333333333333333333
                  0000}
                NumGlyphs = 2
              end
              object btnClose: TBitBtn
                Left = 290
                Top = 120
                Width = 75
                Height = 25
                Anchors = [akTop, akRight]
                TabOrder = 3
                Kind = bkClose
              end
            end
            object tsToFile: TTabSheet
              Hint = 'Move ROI request to file and DICOM to CD'
              Caption = 'To File and CD'
              ImageIndex = 1
              ExplicitLeft = 0
              ExplicitTop = 0
              ExplicitWidth = 0
              ExplicitHeight = 0
              DesignSize = (
                398
                205)
              object lbToFileActive: TLabel
                Left = 11
                Top = 3
                Width = 65
                Height = 13
                Caption = 'To File Status'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clMaroon
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object lbRemoteItems: TLabel
                Left = 16
                Top = 189
                Width = 353
                Height = 13
                AutoSize = False
                Caption = 'lbDicomInfo'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clMaroon
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object btnProcessROIRequest: TBitBtn
                Left = 84
                Top = 144
                Width = 145
                Height = 25
                Caption = 'Process ROI Request'
                TabOrder = 0
                OnClick = btnProcessROIRequestClick
                Glyph.Data = {
                  36030000424D3603000000000000360000002800000010000000100000000100
                  18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
                  FF00FFFF00FFFF00FFFF00FFFF00FFAC4D0AA6480AA0420A9B3C0A96370A9233
                  0A8D2F0A8A2B0AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFB1
                  520AFBF0DDFBEDD8FBEBD4FBE9D0FBE7CBFBE5C68D2F0AFF00FFFF00FFFF00FF
                  FF00FFFF00FFFF00FFFF00FFFF00FFB7580AFBF2E4FBF1DFFCEDD9FBECD4FBE9
                  D0FBE7CC92330AFF00FFFF00FFFF00FFFF00FFFF00FF105FCF0E5BCA185AB7BB
                  5D0AFCF5E9FCF4E5FCF0E1FCEEDBFBECD6FBEBD196380AFF00FFFF00FFFF00FF
                  FF00FFFF00FF1262D35EB1FB5A9BE1BF620AFCF7F0FCF6EBFCF4E5FCF1E1FCF0
                  DCFBEDD69A3C0AFF00FFFF00FFFF00FFFF00FFFF00FF1467D86ABBFB64A3E1C4
                  670AFBF8F5FCF7F1FCF6ECFBF4E7FBF1E2FCEEDDA1420AFF00FFFF00FFAC4D0A
                  A6480A9B440F176BDD76C2FB6FACE1C76A0AFCFBF8FCF9F6FCF8F1FCF6EDFBF4
                  E8FCF2E4A6480AFF00FFFF00FFB1520AFBF0DDE9D4C2186FE27FC9FB79B1E1CA
                  6E0AFCFCFCFCFCF9FCF9F6FCF8F2FBF7EDFBF4E8AC4D0AFF00FFFF00FFB7580A
                  FBF2E4E9D8C91A71E487CEFB81B7E1CB6E0ACA6D0AC76A0AC4670ABF620ABC5D
                  0AB6580AB1520AFF00FFFF00FFBB5D0AFCF5E9E9D9CF1C74E889CFFB87BCE183
                  B8E17CB5E174ADE16CA8E11C60BEFF00FFFF00FFFF00FFFF00FFFF00FFBF620A
                  FCF7F0E9DCD21D76EB87CFFB87CFFB89D0FB84CCFB7DC6FB74C0FB1262D1FF00
                  FFFF00FFFF00FFFF00FFFF00FFC4670AFBF8F5E9DDD81C74E81C74E81C74E81A
                  72E5186FE2176CDF1669D91565D6FF00FFFF00FFFF00FFFF00FFFF00FFC76A0A
                  FCFBF8E9E0DCE9DFD8E9DCD4E9D9D1E9D9CCA1490FFF00FFFF00FFFF00FFFF00
                  FFFF00FFFF00FFFF00FFFF00FFCA6E0AFCFCFCFCFCF9FCF9F6FCF8F2FBF7EDFB
                  F4E8AC4D0AFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFCB6E0A
                  CA6D0AC76A0AC4670ABF620ABC5D0AB6580AB1520AFF00FFFF00FFFF00FFFF00
                  FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
                  00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
              end
              object pnlDICOM: TPanel
                Left = 6
                Top = 29
                Width = 384
                Height = 100
                BevelInner = bvLowered
                TabOrder = 1
                object Label6: TLabel
                  Left = 10
                  Top = 51
                  Width = 119
                  Height = 13
                  Caption = 'DICOM CD Writer Queue'
                end
                object lbDicomInfo: TLabel
                  Left = 10
                  Top = 8
                  Width = 353
                  Height = 13
                  AutoSize = False
                  Caption = 'lbDicomInfo'
                end
                object lbDicomInfo2: TLabel
                  Left = 10
                  Top = 26
                  Width = 175
                  Height = 13
                  Caption = 'Select a CD writer queue to proceed.'
                end
                object cbRadiologyCDQueue: TComboBox
                  Left = 10
                  Top = 65
                  Width = 366
                  Height = 21
                  Style = csDropDownList
                  ItemHeight = 0
                  TabOrder = 0
                  OnCloseUp = cbRadiologyCDQueueCloseUp
                end
              end
              object BitBtn1: TBitBtn
                Left = 246
                Top = 144
                Width = 75
                Height = 25
                Anchors = [akTop, akRight]
                TabOrder = 2
                Kind = bkClose
              end
            end
          end
        end
      end
      object Panel1: TPanel
        Left = 421
        Top = 1
        Width = 321
        Height = 422
        Align = alRight
        BevelInner = bvLowered
        Caption = 'Panel1'
        TabOrder = 1
        object ROIMag4Viewer: TMag4Viewer
          Left = 2
          Top = 2
          Width = 317
          Height = 418
          Align = alClient
          DragKind = dkDock
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          AbsWindow = False
          DisplayStyle = MagdsLine
          ViewerStyle = MagvsVirtual
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
            317
            418)
        end
      end
    end
  end
  object PrintDialog1: TPrintDialog
    OnShow = PrintDialogGXShow
    Left = 250
    Top = 120
  end
end
