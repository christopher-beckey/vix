object frmThumbnailMaker: TfrmThumbnailMaker
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Imaging Thumbnail Maker'
  ClientHeight = 371
  ClientWidth = 508
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 196
    Width = 508
    Height = 10
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = 2
    ExplicitTop = 204
    ExplicitWidth = 565
  end
  object Memo1: TMemo
    Left = 26
    Top = 212
    Width = 425
    Height = 132
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 508
    Height = 196
    Align = alTop
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 131
      Top = 1
      Width = 10
      Height = 157
      ExplicitLeft = 158
      ExplicitTop = -1
      ExplicitHeight = 148
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 130
      Height = 157
      Align = alLeft
      BorderWidth = 5
      Caption = 'Panel3'
      TabOrder = 0
      object IGPageViewCtl1Thumb: TIGPageViewCtl
        Left = 6
        Top = 6
        Width = 118
        Height = 145
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 1
        ExplicitTop = 1
        ExplicitWidth = 106
        ExplicitHeight = 111
        ControlData = {
          10070000320C0000FC0E00000B00FFFF00000000000000000000000000000000
          0000000000000000000000000000000000000000000009000000000000000000
          0000000000000000030000000000}
      end
    end
    object Panel4: TPanel
      Left = 141
      Top = 1
      Width = 366
      Height = 157
      Align = alClient
      TabOrder = 1
      object Label1: TLabel
        Left = 6
        Top = 89
        Width = 63
        Height = 13
        Caption = 'Last Image : '
      end
      object lbStatus: TLabel
        Left = 106
        Top = 135
        Width = 39
        Height = 13
        Caption = 'lbStatus'
      end
      object lbFull: TLabel
        Left = 33
        Top = 108
        Width = 24
        Height = 13
        Caption = 'lbFull'
      end
      object Label2: TLabel
        Left = 6
        Top = 135
        Width = 89
        Height = 13
        Caption = 'Thumbnail Status: '
      end
      object Label3: TLabel
        Left = 12
        Top = 18
        Width = 94
        Height = 13
        Caption = 'Processing Image : '
      end
      object lbCurImage: TLabel
        Left = 33
        Top = 40
        Width = 55
        Height = 13
        BiDiMode = bdLeftToRight
        Caption = 'lbCurImage'
        ParentBiDiMode = False
      end
      object Label4: TLabel
        Left = 6
        Top = 66
        Width = 360
        Height = 13
        Caption = 
          '----------------------------------------------------------------' +
          '--------------------------'
      end
    end
    object Panel1: TPanel
      Left = 1
      Top = 158
      Width = 506
      Height = 37
      Align = alBottom
      Alignment = taLeftJustify
      BevelInner = bvLowered
      TabOrder = 2
      object Label5: TLabel
        Left = 6
        Top = 15
        Width = 78
        Height = 13
        Caption = 'Network Share: '
      end
      object lbNetPath: TLabel
        Left = 100
        Top = 15
        Width = 3
        Height = 13
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 81
    Top = 36
    object mnuFile: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object Clearmemo1: TMenuItem
        Caption = 'Clear memo'
        OnClick = Clearmemo1Click
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
      object mnuVersions: TMenuItem
        Caption = 'Versions...'
        OnClick = mnuVersionsClick
      end
    end
  end
end
