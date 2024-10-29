object frmComponentsAttach: TfrmComponentsAttach
  Left = 395
  Top = 186
  Width = 290
  Height = 205
  Caption = 'Attach Components'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object lstComponents: TListBox
    Left = 0
    Top = 0
    Width = 281
    Height = 137
    ItemHeight = 16
    TabOrder = 0
    OnDblClick = lstComponentsDoubleClick
  end
  object btnOK: TButton
    Left = 40
    Top = 144
    Width = 97
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 144
    Top = 144
    Width = 89
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
