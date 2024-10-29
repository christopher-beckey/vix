object frmDialogSelection: TfrmDialogSelection
  Left = 528
  Top = 552
  Width = 270
  Height = 303
  BorderIcons = [biSystemMenu]
  Caption = 'Selection Dialog'
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
    269)
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
    Left = 8
    Top = 30
    Width = 245
    Height = 128
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <>
    TabOrder = 0
    ViewStyle = vsList
    OnSelectItem = lvSaveAsSelectItem
  end
  object Panel1: TPanel
    Left = 0
    Top = 165
    Width = 262
    Height = 104
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      262
      104)
    object lbprompt: TLabel
      Left = 8
      Top = 6
      Width = 61
      Height = 19
      AutoSize = False
      Caption = 'Selected'
    end
    object btnOK: TBitBtn
      Left = 31
      Top = 63
      Width = 75
      Height = 25
      TabOrder = 0
      OnClick = btnOKClick
      Kind = bkOK
    end
    object btnCancel: TBitBtn
      Left = 155
      Top = 63
      Width = 75
      Height = 25
      Caption = '  Cancel'
      TabOrder = 1
      Kind = bkCancel
    end
    object edtSelected: TEdit
      Left = 8
      Top = 28
      Width = 245
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Color = clInactiveBorder
      ReadOnly = True
      TabOrder = 2
    end
    object cbApply: TCheckBox
      Left = 152
      Top = 6
      Width = 97
      Height = 17
      Caption = 'Apply selection'
      Checked = True
      State = cbChecked
      TabOrder = 3
      OnClick = cbApplyClick
    end
  end
end
