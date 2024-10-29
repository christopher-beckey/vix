object frmAcquisitionSetup: TfrmAcquisitionSetup
  Left = 296
  Top = 250
  Caption = 'Acquisition Site Consult Setup'
  ClientHeight = 632
  ClientWidth = 861
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = AcquisitionMainMenu
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 572
    Width = 861
    Height = 60
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      861
      60)
    object btnAdd: TBitBtn
      Left = 412
      Top = 15
      Width = 90
      Height = 25
      Action = actAdd
      Anchors = [akTop, akRight]
      Caption = '&Add'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C007C007C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        0000000000001F7C1F7C1F7C007C007C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        0000000000001F7C007C007C007C007C007C007C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C007C007C007C007C007C007C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C000000001F7C1F7C1F7C007C007C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C000000001F7C1F7C1F7C007C007C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F001F7C1F7C1F7C1F7C1F7C
        1F7C000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F001F001F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F001F001F001F001F001F001F001F001F001F001F7C007C
        007C1F7C1F7C1F7C1F001F001F001F001F001F001F001F001F001F001F7C007C
        007C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F001F001F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F001F7C1F7C1F7C1F7C1F7C
        0000000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        0000000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
    end
    object btnClose: TBitBtn
      Left = 757
      Top = 15
      Width = 90
      Height = 25
      Action = actClose
      Anchors = [akTop, akRight]
      Caption = '&Close'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C10001F7C1040000000001863FF7FFF7FFF7F
        10001F7C1F7C1F7C1F7C1F7C1F7C100010401F7C10400000FF7FFF7FFF7FFF7F
        10001F7C1F7C1F7C1F7C1F7C1F7C10001F7C10401F7C0000FF7FFF7FFF7FFF7F
        10001F7C1F7C1F7C1F7C1F7C1F7C100010401F7C10400000FF7FFF03FF7FFF03
        10001F7C1F7C1F7C1F7C1F7C1F7C10001F7C10401F7C0000FF7FFF7FFF7FFF7F
        10001F7C1F7C1F7C1F7C1F7C1F7C100010401F7C10400000FF7FFF03FF7FFF03
        10001F7C1F7C1F7C1F7C1F7C1F7C10001F7C10401F7C0000FF7FFF7FFF7FFF7F
        10001F7C1F7C1F7C1F7C1F7C1F7C100010401F7C10400000FF7FFF03FF7FFF03
        10001F7C1F7C1F7C1F7C1F7C1F7C10001F7C10401F7C0000FF03FF7FFF03FF7F
        10001F7C1F7C1F7C1F7C1F7C1F7C100010401F7C10400000FF7FFF03FF7FFF03
        10001F7C1F7C1F7C1F7C1F7C1F7C10001F7C10401F7C0000FF03FF7FFF03FF7F
        10001F7C1F7C1F7C1F7C1F7C1F7C100010001000100010001000100010001000
        10001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000000000000000001F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000E003E003E003E00300001F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000000000000000001F7C
        1F7C1F7C1F7C}
    end
    object btnDelete: TBitBtn
      Left = 642
      Top = 15
      Width = 90
      Height = 25
      Action = actDelete
      Anchors = [akTop, akRight]
      Caption = '&Delete'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        0000000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        0000000000001F7C007C007C007C007C007C007C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C007C007C007C007C007C007C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C000000001F7C1F7C1F7C1F7C1F001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C000000001F7C1F7C1F7C1F001F001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F001F001F001F001F001F001F001F001F001F001F7C007C
        007C1F7C1F7C1F7C1F001F001F001F001F001F001F001F001F001F001F7C007C
        007C1F7C1F7C1F7C1F7C1F7C1F001F001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        0000000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        0000000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
    end
    object btnEdit: TBitBtn
      Left = 527
      Top = 15
      Width = 90
      Height = 25
      Action = actEdit
      Anchors = [akTop, akRight]
      Caption = '&Edit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C0000000000000000000000000000
        0000000000001F7C1F7C1F7C1F7C1F7C1F7C0000FF7FFF7FFF7FFF7FFF7FFF7F
        FF7FFF7F0000000000001F7C00000000000000000000FF7FFF7F0000FF7F0000
        0000FF7F0000FF0300000000E07FFF7FE07FFF7FE07F0000FF7FFF7FFF7FFF7F
        FF7FFF7F0000FF030000E07FFF7FE07FFF7F000000000000FF7FFF7FFF7FFF7F
        0000FF7F0000FF030000FF7FE07FFF7FE07FFF7FE07FFF7F0000FF7F00000000
        FF7FFF7F0000FF030000E07FFF7FE07FFF7F00000000000000000000E07F0000
        FF7FFF7F0000FF030000FF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7F0000FF7F
        FF7FFF7F0000FF030000E07FFF7F0000000000000000000000000000FF7FFF7F
        FF7FFF7F0000000000000000E07FFF7FE07F00000000E07F0000FF7FFF7F0000
        0000FF7F00001F7C1F7C1F7C0000000000000000E07F0000FF7FFF7FFF7FFF7F
        FF7FFF7F00001F7C1F7C1F7C1F7C1F7C0000E07F0000FF7FFF7FFF7FFF7F0000
        0000000000001F7C1F7C1F7C1F7C0000E07F0000FF7FFF7F00000000FF7F0000
        FF7FFF7F00001F7C1F7C1F7C0000E07F00000000FF7FFF7FFF7FFF7FFF7F0000
        FF7F00001F7C1F7C1F7C0000007C00001F7C0000FF7FFF7FFF7FFF7FFF7F0000
        00001F7C1F7C1F7C1F7C1F7C00001F7C1F7C0000000000000000000000000000
        1F7C1F7C1F7C}
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 861
    Height = 572
    ActivePage = tsADicom
    Align = alClient
    TabOrder = 0
    OnChange = PageControl1Change
    object tsConsults: TTabSheet
      Caption = '&TeleReader Unread List'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lblConsults: TLabel
        Left = 0
        Top = 0
        Width = 401
        Height = 16
        Align = alTop
        Caption = 'Consult Types to be added to the TeleReader Unread List'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lvConsultTypes: TListView
        Tag = -1
        Left = 0
        Top = 16
        Width = 853
        Height = 288
        Align = alClient
        Columns = <
          item
            Caption = 'Service Name'
            Width = 80
          end
          item
            Caption = 'Procedure (Optional)'
            Width = 110
          end
          item
            Caption = 'Specialty Index'
            Width = 90
          end
          item
            Caption = 'Procedure/Event Index'
            Width = 130
          end
          item
            Caption = 'Acquisition Site'
            Tag = 150
            Width = 90
          end
          item
            Caption = 'Unread ListTrigger'
            Width = 100
          end
          item
            Caption = 'TIU Note Title'
            Width = 80
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        PopupMenu = popUnreadList
        TabOrder = 1
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
        OnDblClick = ListViewDblClick
        OnSelectItem = lvConsultTypesSelectItem
      end
      object pnlDetail: TPanel
        Left = 0
        Top = 304
        Width = 853
        Height = 240
        Align = alBottom
        BevelInner = bvLowered
        BevelOuter = bvLowered
        TabOrder = 0
        object lblSite1: TLabel
          Left = 10
          Top = 130
          Width = 112
          Height = 16
          Caption = 'Acquisition Site:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblServiceName1: TLabel
          Left = 10
          Top = 10
          Width = 103
          Height = 16
          Caption = 'Service Name:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblProcedure1: TLabel
          Left = 10
          Top = 40
          Width = 149
          Height = 16
          Caption = 'Procedure (Optional):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblSpecialty1: TLabel
          Left = 10
          Top = 70
          Width = 111
          Height = 16
          Caption = 'Specialty Index:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblProcIndex1: TLabel
          Left = 10
          Top = 100
          Width = 162
          Height = 16
          Caption = 'Procedure/Event Index:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblTrigger1: TLabel
          Left = 10
          Top = 160
          Width = 139
          Height = 16
          Caption = 'Unread List Trigger:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblTIU1: TLabel
          Left = 10
          Top = 190
          Width = 102
          Height = 16
          Caption = 'TIU Note Title:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblSiteDetail: TLabel
          Left = 200
          Top = 130
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object lblServiceNameDetail: TLabel
          Left = 200
          Top = 10
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object lblProcedureDetail: TLabel
          Left = 200
          Top = 40
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object lblSpecialtyIndexDetail: TLabel
          Left = 200
          Top = 70
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object lblProcedureIndexDetail: TLabel
          Left = 200
          Top = 100
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object lblTriggerDetail: TLabel
          Left = 200
          Top = 160
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object lblTIUDetail: TLabel
          Left = 200
          Top = 190
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
      end
    end
    object tsADicom: TTabSheet
      Caption = '&Modality Worklist'
      ImageIndex = 1
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 853
        Height = 16
        Align = alTop
        Caption = 'Consult Types for the DICOM Gateway Modality Worklist'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 386
      end
      object lvDICOM: TListView
        Tag = -1
        Left = 0
        Top = 16
        Width = 853
        Height = 280
        Align = alClient
        Columns = <
          item
            Caption = 'Service Name'
            Width = 80
          end
          item
            Caption = 'Procedure (Optional)'
            Width = 110
          end
          item
            Caption = 'Specialty Index'
            Width = 90
          end
          item
            Caption = 'Procedure/Event Index'
            Width = 130
          end
          item
            Caption = 'Acquisition Site'
            Width = 90
          end
          item
            Caption = 'CPT'
            Width = 100
          end
          item
            Caption = 'HL7'
            Width = 100
          end
          item
            Caption = 'Clinic(s)'
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        PopupMenu = popUnreadList
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = ListViewColumnClick
        OnCompare = ListViewCompare
        OnDblClick = ListViewDblClick
        OnSelectItem = lvDICOMSelectItem
      end
      object Panel1: TPanel
        Left = 0
        Top = 296
        Width = 853
        Height = 248
        Align = alBottom
        BevelInner = bvLowered
        BevelOuter = bvLowered
        TabOrder = 1
        object lblSiteDetailMWL: TLabel
          Left = 205
          Top = 129
          Width = 26
          Height = 16
          Caption = 'site'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblServiceNameDetailMWL: TLabel
          Left = 205
          Top = 9
          Width = 75
          Height = 16
          Caption = 'cardiology'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblProcedureDetailMWL: TLabel
          Left = 205
          Top = 39
          Width = 72
          Height = 16
          Caption = 'procedure'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblSpecialtyIndexDetailMWL: TLabel
          Left = 205
          Top = 69
          Width = 64
          Height = 16
          Caption = 'specialty'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblProcedureIndexDetailMWL: TLabel
          Left = 205
          Top = 99
          Width = 115
          Height = 16
          Caption = 'procedure/event'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label9: TLabel
          Left = 15
          Top = 146
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object Label10: TLabel
          Left = 20
          Top = 10
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object Label11: TLabel
          Left = 15
          Top = 56
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object Label12: TLabel
          Left = 15
          Top = 86
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object Label13: TLabel
          Left = 15
          Top = 116
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object Label14: TLabel
          Left = 196
          Top = 99
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object Label15: TLabel
          Left = 201
          Top = 99
          Width = 5
          Height = 16
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ShowAccelChar = False
        end
        object lblCPTCodeDetailMWL: TLabel
          Left = 205
          Top = 159
          Width = 22
          Height = 16
          Caption = 'cpt'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblHL7DetailMWL: TLabel
          Left = 205
          Top = 189
          Width = 21
          Height = 16
          Caption = 'hl7'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblSiteMWL: TLabel
          Left = 10
          Top = 129
          Width = 112
          Height = 16
          Caption = 'Acquisition Site:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblServiceNameMWL: TLabel
          Left = 10
          Top = 9
          Width = 103
          Height = 16
          Caption = 'Service Name:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblProcedurelMWL: TLabel
          Left = 10
          Top = 39
          Width = 149
          Height = 16
          Caption = 'Procedure (Optional):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblSpecialtyIndexMWL: TLabel
          Left = 10
          Top = 69
          Width = 111
          Height = 16
          Caption = 'Specialty Index:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblProcedureIndexMWL: TLabel
          Left = 10
          Top = 99
          Width = 162
          Height = 16
          Caption = 'Procedure/Event Index:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblCPTCodeMWL: TLabel
          Left = 10
          Top = 159
          Width = 76
          Height = 16
          Caption = 'CPT Code:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblHL7MWL: TLabel
          Left = 10
          Top = 189
          Width = 173
          Height = 16
          Caption = 'HL7 HLO Subscriber List:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblClinicsMWL: TLabel
          Left = 10
          Top = 219
          Width = 51
          Height = 16
          Caption = 'Clinics:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblClinicsDetailMWL: TLabel
          Left = 205
          Top = 219
          Width = 45
          Height = 16
          Caption = 'clinics'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
  end
  object popUnreadList: TPopupMenu
    Images = ImageList1
    Left = 121
    Top = 578
    object miAdd: TMenuItem
      Action = actAdd
    end
    object miEdit: TMenuItem
      Action = actEdit
    end
    object miDelete: TMenuItem
      Action = actDelete
    end
  end
  object ActionListAcq: TActionList
    Images = ImageList1
    Left = 8
    Top = 578
    object actAdd: TAction
      Caption = 'Add'
      ImageIndex = 0
      OnExecute = AddRecord
    end
    object actEdit: TAction
      Caption = 'Edit'
      Enabled = False
      ImageIndex = 1
      OnExecute = EditRecord
    end
    object actDelete: TAction
      Caption = 'Delete'
      Enabled = False
      ImageIndex = 2
      OnExecute = DeleteRecord
    end
    object actClose: TAction
      Caption = '&Close'
      ImageIndex = 3
      OnExecute = actCloseExecute
    end
  end
  object AcquisitionMainMenu: TMainMenu
    Images = ImageList1
    Left = 80
    Top = 580
    object mmiFile: TMenuItem
      Caption = 'File'
      ShortCut = 16454
      object mmiAdd: TMenuItem
        Action = actAdd
      end
      object mmiEdit: TMenuItem
        Action = actEdit
      end
      object mmiDelete: TMenuItem
        Action = actDelete
      end
      object mmiClose: TMenuItem
        Action = actClose
      end
    end
    object mmiHelp: TMenuItem
      Caption = 'Help'
      ShortCut = 16456
      object mmiContents: TMenuItem
        Caption = 'Contents'
        OnClick = mmiContentsClick
      end
    end
  end
  object ImageList1: TImageList
    Left = 44
    Top = 580
    Bitmap = {
      494C010104002000200010001000FFFFFFFFFF00FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000FF00FF00840084000000000000000000C6C7C600FFFFFF00FFFF
      FF00FFFFFF008400000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008400000084008400FF00FF008400840000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000FF00FF0084008400FF00FF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00840000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008400000084008400FF00FF008400840000000000FFFFFF00FFFF0000FFFF
      FF00FFFF0000840000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF0000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000FF00FF0084008400FF00FF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000000000FFFFFF000000
      000000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008400000084008400FF00FF008400840000000000FFFFFF00FFFF0000FFFF
      FF00FFFF00008400000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF00000000000000000000000000000000000000000000FF
      FF0000000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000FF00FF0084008400FF00FF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008400000084008400FF00FF008400840000000000FFFFFF00FFFF0000FFFF
      FF00FFFF00008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      000000000000000000000000000000000000FFFF00000000000000FFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084000000FF00FF0084008400FF00FF0000000000FFFF0000FFFFFF00FFFF
      0000FFFFFF008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00000000000000000000FFFF0000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF0000000000000000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008400000084008400FF00FF008400840000000000FFFFFF00FFFF0000FFFF
      FF00FFFF000084000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      000084000000FF00FF0084008400FF00FF0000000000FFFF0000FFFFFF00FFFF
      0000FFFFFF0084000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000840000008400000084000000840000008400000084000000840000008400
      0000840000008400000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000FFFFFF00FFFFFF000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF0000000000000000000000000000000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFC00FFFFF003E7F8FC00FFF8F003
      E7F82000FFF8F00381FF000081FFF00381FC000081FCF003E7FC0000FFFCF003
      E7FF0000FFFFF003FFFC0000FFFCF003FEFC0000F7FCF003FE7F0000E7FFF003
      8013E0008013F0038013F8008013F003FE7FF000E7FFFFFFFEF8E001F7F8FC0F
      FFF8C403FFF8FC0FFFFFEC07FFFFFC0F}
  end
  object amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmAcquisitionSetup'
        'Status = stsDefault'))
  end
end
