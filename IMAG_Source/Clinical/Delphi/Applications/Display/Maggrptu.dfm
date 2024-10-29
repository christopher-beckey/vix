object maggrptf: Tmaggrptf
  Left = 261
  Top = 322
  HelpContext = 130
  Caption = 'VISTA Health Summary'
  ClientHeight = 221
  ClientWidth = 348
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  Icon.Data = {
    0000010001002020100100000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000010000000000000000000
    00000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000FFFFFFF
    FFFFFF0000FFFFFFFFFFFFFF0FFFFFFFFFFFFF0FF0FFFFFFFFFFFFFF0FFFFFFF
    FFF0000FF0FF00000000FFFF0FFFFFFFFFF0FF0FF0FFFFFFFFFFFFFF0FFFFFFF
    0000FF0FF0FFFFFFFFFFFFFF0FFFFFFF0FF0FF0FF0FF00000000000F0FFFFFFF
    0FF0FF0FF0FFFFFFFFFFFFFF0FFFFFFF0FF0FF0FF0FFFFFFFFFFFFFF0FFFFFFF
    0FF0FF0FF0FF00000000000F0FFFFFFF0FF0FF0FF0FFFFFFFFFFFFFF0FFFFFFF
    0FF0FF0FF0FFFFFFFFFFFFFF0FFFFFFF0FF0FF0FF0FF00000000000F0FFFFFFF
    0FF0FF0FF0FFFFFFFFFFFFFF0FFFFFFF0FF0FF0FF0FFFFFFFFFFFFFF0FFFFFFF
    0FF0FF0FF0FF000000FFFFFF0FFFFFFF0FF0FF0FF0FFFFFFFFFFFFFF0FFFFFFF
    0FF0FF0FF0FFFFFFFFFF00000FFFFFFF0FF0FF0FF0FF000FFFFF0FF0FFFFFFFF
    0FF0FF0FF0FFFFFFFFFF0F0FFFFFFFFF0FF0FF0FF0FFFFFFFFFF00FFFFFFFFFF
    0FF0FF0FF000000000000FFFFFFFFFFF0FF0FF0FFFFFFFFFFF0FFFFFFFFFFFFF
    0FF0FF0000000000000FFFFFFFFFFFFF0FF0FFFFFFFFFFF0FFFFFFFFFFFFFFFF
    0FF0000000000000FFFFFFFFFFFFFFFF0FFFFFFFFFFF0FFFFFFFFFFFFFFFFFFF
    0000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object msg: TPanel
    Left = 0
    Top = 200
    Width = 348
    Height = 21
    Align = alBottom
    Alignment = taLeftJustify
    BevelInner = bvLowered
    TabOrder = 0
  end
  object Notebook1: TNotebook
    Left = 0
    Top = 41
    Width = 348
    Height = 159
    Align = alClient
    TabOrder = 1
    object TPage
      Left = 0
      Top = 0
      Caption = 'Health Summary'
      ExplicitWidth = 0
      ExplicitHeight = 0
      object sbHS: TSpeedButton
        Left = 5
        Top = 5
        Width = 116
        Height = 25
        Caption = 'Open'
        NumGlyphs = 2
        OnClick = sbHSClick
      end
      object hsNameList: TListBox
        Left = 129
        Top = 0
        Width = 219
        Height = 159
        Align = alRight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ItemHeight = 14
        Items.Strings = (
          'Dr bill'#39's report   '
          'Inpatient         '
          'Joe'#39's summary       '
          'Outpatient              ')
        MultiSelect = True
        ParentFont = False
        Sorted = True
        TabOrder = 0
        OnDblClick = sbHSClick
      end
      object hsTypeList: TListBox
        Left = 14
        Top = 76
        Width = 109
        Height = 22
        Color = clGrayText
        ItemHeight = 16
        Sorted = True
        TabOrder = 1
        Visible = False
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 348
    Height = 41
    Align = alTop
    TabOrder = 2
    object PatName: TLabel
      Left = 9
      Top = 2
      Width = 72
      Height = 14
      Caption = 'Patient Name'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object PatDemog: TLabel
      Left = 7
      Top = 20
      Width = 86
      Height = 14
      Caption = 'd.o.b. ssn m/fm'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object PatDFN: TLabel
      Left = 134
      Top = 11
      Width = 20
      Height = 16
      Caption = 'dfn'
      Visible = False
    end
    object edemo: TEdit
      Left = 280
      Top = 8
      Width = 55
      Height = 24
      TabOrder = 0
      Text = 'edemo'
      Visible = False
    end
    object demodir: TEdit
      Left = 190
      Top = 6
      Width = 53
      Height = 24
      TabOrder = 1
      Text = 'demodir'
      Visible = False
    end
    object Panel2: TPanel
      Left = 308
      Top = 1
      Width = 39
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
end
