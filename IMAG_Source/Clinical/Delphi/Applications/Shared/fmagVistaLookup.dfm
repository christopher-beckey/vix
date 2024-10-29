object MagLookup: TMagLookup
  Left = 406
  Top = 307
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Lookup Entry'
  ClientHeight = 251
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbprompthelp: TLabel
    Left = 0
    Top = 12
    Width = 112
    Height = 13
    Caption = '  enter a few characters'
  end
  object Panel1: TPanel
    Left = 0
    Top = 37
    Width = 334
    Height = 32
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object lbprompt: TLabel
      Left = 6
      Top = 11
      Width = 40
      Height = 13
      Caption = 'lbprompt'
    end
    object SpeedButton1: TSpeedButton
      Left = 270
      Top = 9
      Width = 46
      Height = 21
      Caption = 'Search'
      OnClick = SpeedButton1Click
    end
    object einput: TEdit
      Left = 74
      Top = 9
      Width = 187
      Height = 21
      TabOrder = 0
      Text = 'einput'
      OnEnter = einputEnter
      OnExit = einputExit
      OnKeyDown = einputKeyDown
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 69
    Width = 334
    Height = 161
    BevelOuter = bvNone
    BevelWidth = 15
    BorderWidth = 5
    TabOrder = 1
    object searchlist: TListBox
      Left = 5
      Top = 5
      Width = 324
      Height = 111
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnClick = searchlistClick
      OnDblClick = searchlistDblClick
    end
    object Panel3: TPanel
      Left = 5
      Top = 116
      Width = 324
      Height = 40
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object btnOK: TBitBtn
        Left = 60
        Top = 12
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        Enabled = False
        ModalResult = 1
        TabOrder = 0
        OnClick = btnOKClick
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000010000000000000000000
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
      object bbCancel: TBitBtn
        Left = 188
        Top = 12
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 230
    Width = 336
    Height = 21
    Panels = <
      item
        Alignment = taCenter
        Width = 50
      end>
  end
end
