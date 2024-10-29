object frmFMSetSelect: TfrmFMSetSelect
  Left = -1198
  Top = 151
  BorderStyle = bsDialog
  Caption = 'Set Selection'
  ClientHeight = 283
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 107
    Top = 248
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 223
    Top = 248
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object pnlSelectLists: TPanel
    Left = 7
    Top = 32
    Width = 389
    Height = 201
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object btnSelAll: TSpeedButton
      Left = 183
      Top = 49
      Width = 23
      Height = 23
      Caption = '>>'
      OnClick = btnSelAllClick
    end
    object btnSelSelected: TSpeedButton
      Left = 183
      Top = 81
      Width = 23
      Height = 23
      Caption = '>'
      OnClick = btnSelSelectedClick
    end
    object btnRemoveSelected: TSpeedButton
      Left = 183
      Top = 113
      Width = 23
      Height = 23
      Caption = '<'
      OnClick = btnRemoveSelectedClick
    end
    object RemoveAll: TSpeedButton
      Left = 183
      Top = 144
      Width = 23
      Height = 23
      Caption = '<<'
      OnClick = RemoveAllClick
    end
    object Label2: TLabel
      Left = 228
      Top = 12
      Width = 77
      Height = 13
      Caption = 'Selected Values'
    end
    object Label1: TLabel
      Left = 28
      Top = 12
      Width = 56
      Height = 13
      Caption = 'Select from:'
    end
    object Label3: TLabel
      Left = 272
      Top = 56
      Width = 32
      Height = 13
      Caption = 'Label3'
    end
    object lstchoice: TListBox
      Left = 26
      Top = 32
      Width = 141
      Height = 153
      DragMode = dmAutomatic
      ItemHeight = 13
      Sorted = True
      TabOrder = 0
      OnDblClick = lstchoiceDblClick
      OnEnter = lstchoiceEnter
      OnKeyDown = lstchoiceKeyDown
    end
    object lstSel: TListBox
      Left = 222
      Top = 32
      Width = 141
      Height = 153
      DragMode = dmAutomatic
      ItemHeight = 13
      Sorted = True
      TabOrder = 1
      OnDblClick = lstSelDblClick
      OnEnter = lstSelEnter
      OnKeyDown = lstSelKeyDown
    end
  end
end
