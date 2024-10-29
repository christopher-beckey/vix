object frmActiveForms: TfrmActiveForms
  Left = 354
  Top = 282
  BorderStyle = bsDialog
  Caption = 'Switch to Imaging window:'
  ClientHeight = 226
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    495
    226)
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 5
    Top = 5
    Width = 486
    Height = 169
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
    OnKeyDown = ListBox1KeyDown
    OnKeyUp = ListBox1KeyUp
    OnMouseUp = ListBox1MouseUp
  end
  object BitBtn1: TBitBtn
    Left = 210
    Top = 190
    Width = 75
    Height = 25
    Anchors = [akBottom]
    TabOrder = 1
    Kind = bkClose
  end
end
