object MAGGMCF: TMAGGMCF
  Left = 316
  Top = 401
  HelpContext = 10123
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Medicine Procedure/Subspecialty list'
  ClientHeight = 326
  ClientWidth = 556
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object MSG: TPanel
    Left = 0
    Top = 301
    Width = 556
    Height = 25
    Align = alBottom
    BevelInner = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 57
    Width = 556
    Height = 174
    Align = alBottom
    TabOrder = 2
    object PatName: TLabel
      Left = 159
      Top = 6
      Width = 3
      Height = 14
      Color = clBtnFace
      ParentColor = False
    end
    object Label5: TLabel
      Left = 8
      Top = 32
      Width = 149
      Height = 16
      AutoSize = False
      Caption = 'Procedure/Subspecialty    :'
    end
    object Label6: TLabel
      Left = 8
      Top = 57
      Width = 149
      Height = 16
      AutoSize = False
      Caption = 'Date/Time                             :'
    end
    object psname: TLabel
      Left = 312
      Top = 32
      Width = 4
      Height = 16
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object mcdttm: TLabel
      Left = 159
      Top = 58
      Width = 142
      Height = 17
      AutoSize = False
      Color = clBtnFace
      ParentColor = False
    end
    object mcnew: TLabel
      Left = 312
      Top = 58
      Width = 4
      Height = 16
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object pscode: TLabel
      Left = 159
      Top = 32
      Width = 3
      Height = 14
      Color = clBtnFace
      ParentColor = False
    end
    object Label1: TLabel
      Left = 8
      Top = 6
      Width = 149
      Height = 16
      AutoSize = False
      Caption = 'Patient                                   :'
    end
    object procnewlabel: TLabel
      Left = 8
      Top = 83
      Width = 144
      Height = 14
      Caption = 'Date/Time for New Proc.   :'
    end
    object procnewdttm: TEdit
      Left = 159
      Top = 80
      Width = 144
      Height = 22
      TabOrder = 0
      OnExit = procnewdttmExit
      OnKeyDown = procnewdttmKeyDown
    end
    object GroupBox1: TGroupBox
      Left = 12
      Top = 108
      Width = 409
      Height = 55
      Caption = 'Selection Options'
      TabOrder = 1
      object rbnewproc: TRadioButton
        Left = 6
        Top = 16
        Width = 387
        Height = 17
        Caption = 'Create New procedure for selected subspecialty'
        TabOrder = 0
        OnClick = rbnewprocClick
      end
      object rblistproc: TRadioButton
        Left = 6
        Top = 34
        Width = 393
        Height = 17
        Caption = 'List existing Procedure Date/Times for selected subspecialty'
        TabOrder = 1
        OnClick = rblistprocClick
      end
    end
    object Button1: TButton
      Left = 496
      Top = 124
      Width = 85
      Height = 35
      Caption = 'testnew'
      TabOrder = 2
      Visible = False
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 556
    Height = 57
    Align = alClient
    TabOrder = 0
    OnResize = Panel2Resize
    object Label2: TLabel
      Left = 8
      Top = 5
      Width = 168
      Height = 14
      Caption = 'Select Procedure/Subspecialty'
    end
    object Label3: TLabel
      Left = 232
      Top = 5
      Width = 189
      Height = 14
      Caption = 'Procedure/Subspecialty Date/Time'
    end
    object ListBox1: TListBox
      Left = 10
      Top = 23
      Width = 197
      Height = 132
      ItemHeight = 14
      TabOrder = 0
      OnClick = ListBox1Click
      OnDblClick = ListBox1DblClick
      OnKeyDown = ListBox1KeyDown
    end
    object ListBox2: TListBox
      Left = 224
      Top = 23
      Width = 395
      Height = 132
      ItemHeight = 14
      TabOrder = 1
      OnClick = ListBox2Click
      OnDblClick = ListBox2DblClick
      OnKeyDown = ListBox2KeyDown
    end
  end
  object Panel3: TPanel
    Left = 582
    Top = 96
    Width = 275
    Height = 209
    TabOrder = 4
    Visible = False
    object newname: TLabel
      Left = 18
      Top = 99
      Width = 61
      Height = 16
      AutoSize = False
      Caption = 'newname'
      Color = clBtnShadow
      ParentColor = False
      Visible = False
    end
    object sbMagRpt: TSpeedButton
      Left = 14
      Top = 176
      Width = 91
      Height = 22
      Caption = 'Report'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'System'
      Font.Style = [fsBold]
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555FFFFFFFFFF5555550000000000555557777777777F5555550FFFFFFFF
        0555557F5FFFF557F5555550F0000FFF0555557F77775557F5555550FFFFFFFF
        0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
        0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
        0555557F5FFF5557F5555550F000FFFF0555557F77755FF7F5555550FFFFF000
        0555557F5FF5777755555550F00FF0F05555557F77557F7555555550FFFFF005
        5555557FFFFF7755555555500000005555555577777775555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentFont = False
    end
    object mcien: TLabel
      Left = 156
      Top = 54
      Width = 79
      Height = 16
      AutoSize = False
      Caption = 'mcien'
      Color = clBtnShadow
      ParentColor = False
      Visible = False
    end
    object psien: TLabel
      Left = 162
      Top = 30
      Width = 73
      Height = 16
      AutoSize = False
      Caption = 'psien'
      Color = clBtnShadow
      ParentColor = False
      Visible = False
    end
    object DFN: TLabel
      Left = 162
      Top = 6
      Width = 73
      Height = 16
      AutoSize = False
      Caption = 'DFN'
      Color = clBtnShadow
      ParentColor = False
      Visible = False
    end
    object datastring: TLabel
      Left = 129
      Top = 97
      Width = 118
      Height = 16
      AutoSize = False
      Caption = 'datastring'
      Color = clBtnShadow
      ParentColor = False
      Visible = False
    end
    object lbb2: TListBox
      Left = 19
      Top = 74
      Width = 70
      Height = 19
      ItemHeight = 14
      TabOrder = 0
      Visible = False
    end
    object Button2: TButton
      Left = 13
      Top = 42
      Width = 112
      Height = 25
      Caption = '&Medical Patient'
      TabOrder = 1
      Visible = False
      OnClick = Button2Click
    end
    object lbb1: TListBox
      Left = 7
      Top = 10
      Width = 82
      Height = 25
      ItemHeight = 14
      TabOrder = 2
      Visible = False
    end
    object Button3: TButton
      Left = 8
      Top = 130
      Width = 91
      Height = 25
      Caption = '&Patient'
      TabOrder = 3
      OnClick = Button3Click
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 231
    Width = 556
    Height = 70
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object bbOK: TBitBtn
      Left = 56
      Top = 32
      Width = 89
      Height = 30
      Caption = '&OK'
      TabOrder = 0
      OnClick = bbOKClick
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
        A400000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        03030303030303030303030303030303030303030303FF030303030303030303
        03030303030303040403030303030303030303030303030303F8F8FF03030303
        03030303030303030303040202040303030303030303030303030303F80303F8
        FF030303030303030303030303040202020204030303030303030303030303F8
        03030303F8FF0303030303030303030304020202020202040303030303030303
        0303F8030303030303F8FF030303030303030304020202FA0202020204030303
        0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
        040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
        03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
        FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
        0303030303030303030303FA0202020403030303030303030303030303F8FF03
        03F8FF03030303030303030303030303FA020202040303030303030303030303
        0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
        03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
        030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
        0202040303030303030303030303030303F8FF03F8FF03030303030303030303
        03030303FA0202030303030303030303030303030303F8FFF803030303030303
        030303030303030303FA0303030303030303030303030303030303F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      NumGlyphs = 2
      Style = bsWin31
    end
    object bbCancel: TBitBtn
      Left = 191
      Top = 32
      Width = 89
      Height = 30
      TabOrder = 1
      Kind = bkCancel
      Style = bsWin31
    end
    object bbNew: TBitBtn
      Left = 325
      Top = 32
      Width = 89
      Height = 30
      Caption = '&New'
      TabOrder = 2
      OnClick = bbNewClick
      NumGlyphs = 2
      Style = bsWin31
    end
    object bbHelp: TBitBtn
      Left = 460
      Top = 32
      Width = 89
      Height = 30
      HelpContext = 10123
      TabOrder = 3
      OnClick = bbHelpClick
      Kind = bkHelp
      Style = bsWin31
    end
    object cbMakeProcStub: TCheckBox
      Left = 16
      Top = 4
      Width = 383
      Height = 17
      Caption = 'Create '#39'NEW'#39' procedure now, Don'#39't wait until Image is saved.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
  end
  object MainMenu1: TMainMenu
    Left = 544
    Top = 60
    object File1: TMenuItem
      Caption = '&File'
      object Save1: TMenuItem
        Caption = '&Save'
        Enabled = False
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Op&tions'
      object ReLoadtheProcedureSubspecialtylist1: TMenuItem
        Caption = 'ReLoad the Procedure/Subspecialty list'
        OnClick = ReLoadtheProcedureSubspecialtylist1Click
      end
      object listAllPatientProcedures1: TMenuItem
        Caption = 'List All Procedures for Patient (not available)'
        Enabled = False
      end
      object clearProcedureselection1: TMenuItem
        Caption = 'Clear the Procedure selection'
        OnClick = proclistclearClick
      end
      object ListPatientProcedures1: TMenuItem
        Caption = 'List the existing Procedures for Patient'
        OnClick = ListPatientProcedures1Click
      end
    end
  end
end
