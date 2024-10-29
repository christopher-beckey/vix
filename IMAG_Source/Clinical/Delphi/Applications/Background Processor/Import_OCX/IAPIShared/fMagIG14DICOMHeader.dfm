object frmIG14DICOMHeader: TfrmIG14DICOMHeader
  Left = 624
  Top = 366
  Width = 544
  Height = 352
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'DICOM Header'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    536
    318)
  PixelsPerInch = 96
  TextHeight = 13
  object txtTagName: TEdit
    Left = 8
    Top = 293
    Width = 453
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    ReadOnly = True
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 468
    Top = 293
    Width = 65
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object pcHeader: TPageControl
    Left = 0
    Top = 0
    Width = 529
    Height = 281
    ActivePage = tsGroup2
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    OnChange = pcHeaderChange
    object tsHeader: TTabSheet
      Caption = 'Header'
      DesignSize = (
        521
        253)
      object lblHeaderHeader: TLabel
        Left = 46
        Top = 5
        Width = 3
        Height = 13
      end
      object lstHeaders: TListBox
        Left = 3
        Top = 24
        Width = 518
        Height = 225
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnClick = lstHeadersClick
      end
    end
    object tsGroup2: TTabSheet
      Caption = 'Group 2'
      ImageIndex = 1
      DesignSize = (
        521
        253)
      object lblGroup2Header: TLabel
        Left = 46
        Top = 5
        Width = 3
        Height = 13
      end
      object lstGroup2: TListBox
        Left = 3
        Top = 24
        Width = 518
        Height = 225
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 14
        ParentFont = False
        TabOrder = 0
        OnClick = lstGroup2Click
      end
    end
  end
  object Button1: TButton
    Left = 400
    Top = 0
    Width = 81
    Height = 17
    Caption = 'Button1'
    TabOrder = 2
    Visible = False
    OnClick = Button1Click
  end
end
