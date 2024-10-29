object frmDICOMEntry: TfrmDICOMEntry
  Left = 218
  Top = 178
  Caption = 'DICOM Header Data Entry'
  ClientHeight = 266
  ClientWidth = 316
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 214
    Width = 316
    Height = 52
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      316
      52)
    object btnCancel: TBitBtn
      Left = 219
      Top = 15
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      OnClick = btnCancelClick
      Kind = bkCancel
    end
    object btnSave: TBitBtn
      Left = 119
      Top = 15
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Save'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = btnSaveClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
    end
    object btnShow: TBitBtn
      Left = 19
      Top = 15
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Show Fields'
      Default = True
      TabOrder = 2
      OnClick = btnShowClick
      NumGlyphs = 2
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 316
    Height = 214
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    TabOrder = 1
  end
end
