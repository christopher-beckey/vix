object frmOpenDialog: TfrmOpenDialog
  Left = 240
  Top = 173
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 233
  ClientWidth = 473
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lstFile: TFileListBox
    Left = 240
    Top = 0
    Width = 233
    Height = 169
    ItemHeight = 13
    TabOrder = 0
    OnChange = lstFileChange
    OnDblClick = lstFileDblClick
  end
  object btnOpen: TButton
    Left = 0
    Top = 200
    Width = 241
    Height = 33
    Caption = 'Open'
    Default = True
    TabOrder = 1
    OnClick = btnOpenClick
  end
  object btnCancel: TButton
    Left = 240
    Top = 200
    Width = 233
    Height = 33
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object edtFilename: TEdit
    Left = 0
    Top = 176
    Width = 473
    Height = 24
    AutoSize = False
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object lstDir: TDirectoryListBox
    Left = 0
    Top = 0
    Width = 241
    Height = 169
    ItemHeight = 16
    TabOrder = 4
    OnChange = lstDirChange
  end
  object Edit1: TEdit
    Left = 0
    Top = 0
    Width = 241
    Height = 17
    BorderStyle = bsNone
    Enabled = False
    TabOrder = 5
  end
end
