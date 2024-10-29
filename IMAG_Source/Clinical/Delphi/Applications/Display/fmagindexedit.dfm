object frmIndexEdit: TfrmIndexEdit
  Left = 419
  Top = 391
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Image Index Edit'
  ClientHeight = 354
  ClientWidth = 680
  Color = 14737359
  Constraints.MaxHeight = 408
  Constraints.MaxWidth = 688
  Constraints.MinHeight = 398
  Constraints.MinWidth = 686
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 240
    Top = 208
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object pnlbottom: TPanel
    Left = 0
    Top = 276
    Width = 680
    Height = 78
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lbCtMsg: TLabel
      Left = 48
      Top = 66
      Width = 3
      Height = 13
      Layout = tlCenter
      Visible = False
    end
    object lbImageIENDesc: TLabel
      Left = 12
      Top = 24
      Width = 32
      Height = 13
      Caption = 'Image:'
    end
    object lbImageIEN: TLabel
      Left = 55
      Top = 24
      Width = 402
      Height = 55
      AutoSize = False
      Caption = '<image ien>'
      WordWrap = True
    end
    object lbPatDesc: TLabel
      Left = 12
      Top = 6
      Width = 36
      Height = 13
      Caption = 'Patient:'
    end
    object lbPat: TLabel
      Left = 55
      Top = 6
      Width = 145
      Height = 13
      AutoSize = False
      Caption = '<patient>'
    end
    object btnOK: TBitBtn
      Left = 476
      Top = 7
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
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
      Left = 476
      Top = 43
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object MainMenu1: TMainMenu
    Left = 363
    Top = 10
    object mnuFile: TMenuItem
      Caption = 'File'
      object mnuSave: TMenuItem
        Caption = 'Save'
        OnClick = mnuSaveClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object mnuOptions: TMenuItem
      Caption = 'Options'
      object mnuInitialize: TMenuItem
        Caption = 'Initial Values'
        OnClick = mnuInitializeClick
      end
      object mnuClear: TMenuItem
        Caption = 'Clear Fields'
        OnClick = mnuClearClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuIncludeAll: TMenuItem
        Caption = 'Include All Fields'
        OnClick = mnuIncludeAllClick
      end
      object mnuExcludeAll: TMenuItem
        Caption = 'Exclude All Fields'
        OnClick = mnuExcludeAllClick
      end
      object GenerateIndexValues1: TMenuItem
        Caption = 'Generate Index Values'
        Visible = False
      end
    end
    object mnuHelp: TMenuItem
      Caption = 'Help'
      object mnuIndexEdithelp: TMenuItem
        Caption = 'Index Edit Help'
        OnClick = mnuIndexEdithelpClick
      end
    end
  end
end
