object frmCapPatConsultList: TfrmCapPatConsultList
  Left = 428
  Top = 136
  Width = 471
  Height = 383
  Caption = 'Consult Select'
  Color = clBtnFace
  Constraints.MinHeight = 350
  Constraints.MinWidth = 375
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    463
    349)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 266
    Height = 13
    Caption = 'The Selected Note Title must have a Consult linked to it:'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 52
    Height = 13
    Caption = 'Note Title: '
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 137
    Height = 13
    Caption = 'Select a Consult for Patient : '
  end
  object lbPatient: TLabel
    Left = 168
    Top = 72
    Width = 44
    Height = 13
    Caption = '<patient>'
  end
  object lbTitle: TLabel
    Left = 96
    Top = 40
    Width = 52
    Height = 13
    Caption = '<note title>'
  end
  object MagListView1: TMagListView
    Left = 8
    Top = 112
    Width = 447
    Height = 166
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <>
    TabOrder = 0
    OnSelectItem = MagListView1SelectItem
  end
  object btnOK: TBitBtn
    Left = 96
    Top = 293
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object btnCancel: TBitBtn
    Left = 296
    Top = 293
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    Kind = bkCancel
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 330
    Width = 463
    Height = 19
    Panels = <>
  end
end
