object frmCapUtilForm: TfrmCapUtilForm
  Left = 0
  Top = 0
  Caption = 'frmCapUtilForm'
  ClientHeight = 196
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    450
    196)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 8
    Top = 11
    Width = 101
    Height = 25
    Caption = 'EraseTempfiles'
    TabOrder = 0
  end
  object magCapFileListBox1: TFileListBox
    Left = 168
    Top = 57
    Width = 268
    Height = 127
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 1
  end
  object magCapDirectoryListBox1: TDirectoryListBox
    Left = 8
    Top = 57
    Width = 149
    Height = 127
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 16
    TabOrder = 2
  end
end
