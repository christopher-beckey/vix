object frmDialogSaveAs: TfrmDialogSaveAs
  Left = -2055
  Top = 277
  Width = 270
  Height = 406
  BorderIcons = [biSystemMenu]
  Caption = 'Save As Dialog'
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 270
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    262
    372)
  PixelsPerInch = 96
  TextHeight = 13
  object lbHeader: TLabel
    Left = 10
    Top = 6
    Width = 62
    Height = 13
    Caption = 'Selection list:'
  end
  object lvSaveAs: TListView
    Left = 6
    Top = 30
    Width = 247
    Height = 235
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <>
    TabOrder = 0
    ViewStyle = vsList
    OnSelectItem = lvSaveAsSelectItem
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 271
    Width = 262
    Height = 101
    Align = alBottom
    TabOrder = 1
    object lbprompt: TLabel
      Left = 8
      Top = 2
      Width = 229
      Height = 19
      AutoSize = False
      Caption = 'Name'
    end
    object edtSaveAs: TEdit
      Left = 6
      Top = 20
      Width = 247
      Height = 21
      TabOrder = 0
    end
    object btnSave: TBitBtn
      Left = 32
      Top = 60
      Width = 75
      Height = 25
      Caption = '  &Save'
      Default = True
      TabOrder = 1
      OnClick = btnSaveClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
        00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
        00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
        00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
        0003737FFFFFFFFF7F7330099999999900333777777777777733}
      NumGlyphs = 2
    end
    object btnCancel: TBitBtn
      Left = 151
      Top = 60
      Width = 75
      Height = 25
      Caption = '  Cancel'
      TabOrder = 2
      Kind = bkCancel
    end
  end
end
