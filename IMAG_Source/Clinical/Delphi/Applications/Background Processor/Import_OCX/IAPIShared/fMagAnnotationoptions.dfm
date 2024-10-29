object frmAnnotationOptions: TfrmAnnotationOptions
  Left = 559
  Top = 316
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Measurement Options'
  ClientHeight = 137
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 121
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Measurement Units:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 8
    Top = 72
    Width = 121
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Measurement Color:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 121
    Height = 17
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Line Width:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlCenter
  end
  object cboUnits: TComboBox
    Left = 136
    Top = 40
    Width = 209
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = cboUnitsChange
  end
  object btnOK: TButton
    Left = 136
    Top = 104
    Width = 65
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 288
    Top = 104
    Width = 59
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object btnApply: TButton
    Left = 208
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Apply'
    TabOrder = 4
    OnClick = btnApplyClick
  end
  object ColorBox1: TColorBox
    Left = 136
    Top = 72
    Width = 209
    Height = 22
    ItemHeight = 16
    TabOrder = 2
  end
  object cboLineWidth: TComboBox
    Left = 136
    Top = 8
    Width = 209
    Height = 19
    Style = csOwnerDrawFixed
    ItemHeight = 13
    TabOrder = 0
  end
end
