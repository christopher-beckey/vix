object frmTESTDicomData: TfrmTESTDicomData
  Left = 0
  Top = 0
  Caption = 'Test Dicom Data'
  ClientHeight = 485
  ClientWidth = 803
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDicomTestingData: TPanel
    Left = 14
    Top = 8
    Width = 733
    Height = 407
    BorderWidth = 5
    Caption = 'pnlDicomTestingData'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 381
      Top = 67
      Height = 334
      Align = alRight
      ExplicitLeft = 362
      ExplicitTop = 92
      ExplicitHeight = 100
    end
    object memDicomTest: TMemo
      Left = 10
      Top = 78
      Width = 279
      Height = 321
      Lines.Strings = (
        'memDicomTest')
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object Panel1: TPanel
      Left = 384
      Top = 67
      Width = 343
      Height = 334
      Align = alRight
      Caption = 'Panel1'
      TabOrder = 1
      object memDicom106: TMemo
        Left = 38
        Top = 18
        Width = 185
        Height = 89
        Lines.Strings = (
          'memDicom106')
        TabOrder = 0
      end
    end
    object Panel2: TPanel
      Left = 6
      Top = 6
      Width = 721
      Height = 61
      Align = alTop
      TabOrder = 2
      object Label1: TLabel
        Left = 456
        Top = 42
        Width = 72
        Height = 13
        Caption = '106 DicomData'
      end
      object btnDicomFieldsGetUserData: TButton
        Left = 10
        Top = 10
        Width = 143
        Height = 25
        Caption = 'Get Dicom User Data'
        TabOrder = 0
        OnClick = btnDicomFieldsGetUserDataClick
      end
      object btnDicomMemoClear: TButton
        Left = 354
        Top = 10
        Width = 43
        Height = 25
        Caption = 'Clear'
        TabOrder = 1
        OnClick = btnDicomMemoClearClick
      end
      object btnDicomGetGeneratedData: TButton
        Left = 180
        Top = 10
        Width = 139
        Height = 25
        Caption = 'Get Dicom Generated Data'
        TabOrder = 2
        OnClick = btnDicomGetGeneratedDataClick
      end
    end
  end
end
