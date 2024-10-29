object MagLastImagesForm: TMagLastImagesForm
  Left = 498
  Top = 65
  Width = 338
  Height = 174
  HelpContext = 42
  BorderStyle = bsSizeToolWin
  Caption = 'Patients latest Images'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lvLatest: TListView
    Left = 0
    Top = 29
    Width = 330
    Height = 90
    Align = alClient
    Columns = <
      item
        Caption = 'Image Desc'
        Width = 200
      end
      item
        Caption = 'Procedure'
        Width = 75
      end
      item
        Caption = 'Proc.Date'
        Width = 75
      end
      item
        Caption = 'Captue Dt/Tm'
        Width = 100
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvLatestClick
    OnKeyDown = lvLatestKeyDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 330
    Height = 29
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 205
      Top = 8
      Width = 37
      Height = 13
      Caption = 'Images.'
    end
    object Label2: TLabel
      Left = 14
      Top = 6
      Width = 68
      Height = 13
      Caption = 'List the latest  '
    end
    object eMaxcount: TEdit
      Left = 159
      Top = 4
      Width = 38
      Height = 21
      MaxLength = 3
      TabOrder = 0
      Text = '50'
      OnKeyDown = eMaxcountKeyDown
    end
    object bReload: TBitBtn
      Left = 266
      Top = 4
      Width = 83
      Height = 21
      Caption = 'ReLoad'
      TabOrder = 2
      OnClick = bReloadClick
    end
    object Panel2: TPanel
      Left = 242
      Top = 1
      Width = 87
      Height = 27
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object cbStayOnTop: TCheckBox
        Left = 8
        Top = 6
        Width = 79
        Height = 13
        Caption = 'stay on top'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbStayOnTopClick
      end
    end
    object b50: TBitBtn
      Left = 92
      Top = 4
      Width = 29
      Height = 21
      Caption = '50'
      TabOrder = 3
      OnClick = b50Click
    end
    object b100: TBitBtn
      Left = 124
      Top = 4
      Width = 27
      Height = 21
      Caption = '100'
      TabOrder = 4
      OnClick = b100Click
    end
  end
  object infopanel: TPanel
    Left = 0
    Top = 119
    Width = 330
    Height = 21
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 2
  end
end
