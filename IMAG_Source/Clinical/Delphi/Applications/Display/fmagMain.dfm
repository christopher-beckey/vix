object frmMain: TfrmMain
  Left = 241
  Top = 118
  HelpContext = 10071
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'VistA Imaging Display :'
  ClientHeight = 190
  ClientWidth = 508
  Color = clBtnFace
  Constraints.MinHeight = 100
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poOwnerFormCenter
  ShowHint = True
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 406
    Top = 128
    Width = 32
    Height = 14
    Caption = 'Label1'
  end
  object pMain: TPanel
    Left = 0
    Top = 0
    Width = 508
    Height = 90
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    Constraints.MaxHeight = 90
    Constraints.MaxWidth = 2000
    Constraints.MinHeight = 10
    Constraints.MinWidth = 10
    TabOrder = 0
    object Panel2: TPanel
      Left = 85
      Top = 1
      Width = 422
      Height = 88
      Align = alClient
      TabOrder = 0
      object Panel4: TPanel
        Left = 1
        Top = 36
        Width = 420
        Height = 26
        Align = alTop
        BevelInner = bvLowered
        TabOrder = 0
        object lbImagecount: TLabel
          Left = 233
          Top = 2
          Width = 3
          Height = 14
          Align = alLeft
          Caption = ' '
          Color = clBtnFace
          ParentColor = False
          Layout = tlCenter
        end
        object pPatient: TPanel
          Left = 2
          Top = 2
          Width = 231
          Height = 22
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object imgCCOWLink: TImage
            Left = 2
            Top = 2
            Width = 18
            Height = 18
            Picture.Data = {
              07544269746D617036050000424D360500000000000036040000280000001000
              000010000000010008000000000000010000120B0000120B0000000100000000
              000000000000000080000080000000808000800000008000800080800000C0C0
              C000C0DCC000F0CAA6000020400000206000002080000020A0000020C0000020
              E00000400000004020000040400000406000004080000040A0000040C0000040
              E00000600000006020000060400000606000006080000060A0000060C0000060
              E00000800000008020000080400000806000008080000080A0000080C0000080
              E00000A0000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0
              E00000C0000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0
              E00000E0000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0
              E00040000000400020004000400040006000400080004000A0004000C0004000
              E00040200000402020004020400040206000402080004020A0004020C0004020
              E00040400000404020004040400040406000404080004040A0004040C0004040
              E00040600000406020004060400040606000406080004060A0004060C0004060
              E00040800000408020004080400040806000408080004080A0004080C0004080
              E00040A0000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0
              E00040C0000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0
              E00040E0000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0
              E00080000000800020008000400080006000800080008000A0008000C0008000
              E00080200000802020008020400080206000802080008020A0008020C0008020
              E00080400000804020008040400080406000804080008040A0008040C0008040
              E00080600000806020008060400080606000806080008060A0008060C0008060
              E00080800000808020008080400080806000808080008080A0008080C0008080
              E00080A0000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0
              E00080C0000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0
              E00080E0000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0
              E000C0000000C0002000C0004000C0006000C0008000C000A000C000C000C000
              E000C0200000C0202000C0204000C0206000C0208000C020A000C020C000C020
              E000C0400000C0402000C0404000C0406000C0408000C040A000C040C000C040
              E000C0600000C0602000C0604000C0606000C0608000C060A000C060C000C060
              E000C0800000C0802000C0804000C0806000C0808000C080A000C080C000C080
              E000C0A00000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0
              E000C0C00000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0
              A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FD9000000000FD00000000FDFDFDFDFDFD00FFFFFFFF00FFFFFFFF00FDFD
              FDFD00FF000000000000000000FF00FDFDFD00FF00FD00FDFDFD00FD00FF00FD
              FDFD00FF000000000000000000FF00FDFDFD9000FFFFFFFF00FFFFFFFF00FDFD
              FDFD909000000000FD00000000FDFDFDFDFD909090909090FDFDFDFDFDFDFDFD
              FDFD909090909090FDFDFDFDFDFDFDFDFDFD909090909090FDFDFDFDFDFDFDFD
              FDFDFD90909090FDFDFDFDFDFDFDFDFDFDFDFDFD9090FDFDFDFDFDFDFDFDFDFD
              FDFDFD90909090FDFDFDFDFDFDFDFDFDFDFDFD90909090FDFDFDFDFDFDFDFDFD
              FDFDFD91909091FDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFDFD
              FDFD}
            Transparent = True
          end
          object imgCCOWchanging: TImage
            Left = 2
            Top = 2
            Width = 18
            Height = 18
            Picture.Data = {
              07544269746D617036050000424D360500000000000036040000280000001000
              000010000000010008000000000000010000120B0000120B0000000100000000
              000000000000000080000080000000808000800000008000800080800000C0C0
              C000C0DCC000F0CAA6000020400000206000002080000020A0000020C0000020
              E00000400000004020000040400000406000004080000040A0000040C0000040
              E00000600000006020000060400000606000006080000060A0000060C0000060
              E00000800000008020000080400000806000008080000080A0000080C0000080
              E00000A0000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0
              E00000C0000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0
              E00000E0000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0
              E00040000000400020004000400040006000400080004000A0004000C0004000
              E00040200000402020004020400040206000402080004020A0004020C0004020
              E00040400000404020004040400040406000404080004040A0004040C0004040
              E00040600000406020004060400040606000406080004060A0004060C0004060
              E00040800000408020004080400040806000408080004080A0004080C0004080
              E00040A0000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0
              E00040C0000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0
              E00040E0000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0
              E00080000000800020008000400080006000800080008000A0008000C0008000
              E00080200000802020008020400080206000802080008020A0008020C0008020
              E00080400000804020008040400080406000804080008040A0008040C0008040
              E00080600000806020008060400080606000806080008060A0008060C0008060
              E00080800000808020008080400080806000808080008080A0008080C0008080
              E00080A0000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0
              E00080C0000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0
              E00080E0000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0
              E000C0000000C0002000C0004000C0006000C0008000C000A000C000C000C000
              E000C0200000C0202000C0204000C0206000C0208000C020A000C020C000C020
              E000C0400000C0402000C0404000C0406000C0408000C040A000C040C000C040
              E000C0600000C0602000C0604000C0606000C0608000C060A000C060C000C060
              E000C0800000C0802000C0804000C0806000C0808000C080A000C080C000C080
              E000C0A00000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0
              E000C0C00000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0
              A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FD9000000000FD00000000FDFDFDFDFDFD00FFFFFFFF00FFFFFFFF00FDFD
              FDFD00FF000000000000000000FF00FDFDFD00FF00FD00FDFDFD00FD00FF00FD
              FDFD00FF000000000000000000FF00FDFDFD9000FFFFFFFF00FFFFFFFF00FDFD
              FDFD909000000000FD00000000FDFDFDFDFD909090909090FDFDFDFDFD9090FD
              FDFD909090909090FDFDFDFDFD9090FDFDFD909090909090FDFDFDFDFDFDFDFD
              FDFDFD90909090FDFDFDFDFDFD9090FDFDFDFDFD9090FDFDFDFDFDFDFD909090
              FDFDFD90909090FDFDFDFDFDFDFD909090FDFD90909090FDFDFDFDFDFDFDFD90
              90FDFD91909091FDFDFDFDFD9090909090FDFDFDFDFDFDFDFDFDFDFD90909090
              FDFD}
            Transparent = True
          end
          object imgCCOWbroken: TImage
            Left = 2
            Top = 2
            Width = 18
            Height = 18
            Picture.Data = {
              07544269746D617036050000424D360500000000000036040000280000001000
              0000100000000100080000000000000100000000000000000000000100000000
              000000000000000080000080000000808000800000008000800080800000C0C0
              C000C0DCC000F0CAA6000020400000206000002080000020A0000020C0000020
              E00000400000004020000040400000406000004080000040A0000040C0000040
              E00000600000006020000060400000606000006080000060A0000060C0000060
              E00000800000008020000080400000806000008080000080A0000080C0000080
              E00000A0000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0
              E00000C0000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0
              E00000E0000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0
              E00040000000400020004000400040006000400080004000A0004000C0004000
              E00040200000402020004020400040206000402080004020A0004020C0004020
              E00040400000404020004040400040406000404080004040A0004040C0004040
              E00040600000406020004060400040606000406080004060A0004060C0004060
              E00040800000408020004080400040806000408080004080A0004080C0004080
              E00040A0000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0
              E00040C0000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0
              E00040E0000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0
              E00080000000800020008000400080006000800080008000A0008000C0008000
              E00080200000802020008020400080206000802080008020A0008020C0008020
              E00080400000804020008040400080406000804080008040A0008040C0008040
              E00080600000806020008060400080606000806080008060A0008060C0008060
              E00080800000808020008080400080806000808080008080A0008080C0008080
              E00080A0000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0
              E00080C0000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0
              E00080E0000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0
              E000C0000000C0002000C0004000C0006000C0008000C000A000C000C000C000
              E000C0200000C0202000C0204000C0206000C0208000C020A000C020C000C020
              E000C0400000C0402000C0404000C0406000C0408000C040A000C040C000C040
              E000C0600000C0602000C0604000C0606000C0608000C060A000C060C000C060
              E000C0800000C0802000C0804000C0806000C0808000C080A000C080C000C080
              E000C0A00000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0
              E000C0C00000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0
              A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
              FF00FD900000000000FD0C010101FD5200FDFD00FFFFFFFF00FD4C0100000000
              000000FF00000000FDFD5400FFFFFFFF000000FF000700FDFDFD540000000000
              FF0000FF00000000FD0C4CFDFD00FD00FF009000FFFFFFFF000C4C0000000000
              FF00909000000000004C4C00FFFFFFFF0000909090909090FD4C0C0100000000
              0000909090909090FD0C0101010100000000909090909090FDFD010101010000
              0000FD90909090FDFDFDFD0101FDFD000000FDFD9090FDFDFDFD01010101FDFD
              0000FD90909090FDFDFD01010101FD000000FD90909090FDFDFD4C01014CFD00
              0000FD91909091FDFDFDFDFDFDFDFD520000FDFDFDFDFDFDFDFDFDFDFDFDFDFD
              FDFD}
            Transparent = True
          end
          object lbPatient: TLabel
            Left = 30
            Top = 5
            Width = 41
            Height = 14
            Caption = 'Patient:'
            FocusControl = edtPatient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            OnMouseDown = lbPatientMouseDown
          end
          object magObserverLabel1: TMagObserverLabel
            Left = 76
            Top = 5
            Width = 153
            Height = 14
            AutoSize = False
            Caption = '<cprs Patient>'
          end
          object edtPatient: TEdit
            Left = 74
            Top = 0
            Width = 155
            Height = 22
            Hint = 'Patient Lookup '
            HelpContext = 10145
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            OnDblClick = edtPatientDblClick
            OnExit = edtPatientExit
            OnKeyDown = edtPatientKeyDown
          end
        end
      end
      object pToolBar: TPanel
        Left = 1
        Top = 1
        Width = 420
        Height = 35
        HelpContext = 10119
        Align = alTop
        BevelInner = bvLowered
        TabOrder = 1
        object lbVersion: TLabel
          Left = 264
          Top = 8
          Width = 3
          Height = 14
        end
        object pMainToolbar: TPanel
          Left = 2
          Top = 2
          Width = 237
          Height = 31
          HelpContext = 10119
          Align = alLeft
          BevelOuter = bvNone
          TabOrder = 0
          object ToolBar1: TToolBar
            Left = 0
            Top = 0
            Width = 232
            Height = 31
            HelpContext = 10119
            Align = alLeft
            AutoSize = True
            ButtonHeight = 28
            ButtonWidth = 29
            Caption = 'ToolBar1'
            EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
            EdgeInner = esNone
            EdgeOuter = esNone
            Flat = False
            Images = imglstMainToolbar
            TabOrder = 0
            Wrapable = False
            object tbtnImageListWin: TToolButton
              Left = 0
              Top = 0
              Hint = 'Open the Image List window'
              AutoSize = True
              Caption = 'tbtnImageListWin'
              ImageIndex = 0
              OnClick = mnuImageListClick
            end
            object tbtnListFilterWin: TToolButton
              Left = 29
              Top = 0
              Hint = 'Select/Create an Image Filter'
              AutoSize = True
              Caption = 'tbtnListFilterWin'
              ImageIndex = 12
              OnClick = tbtnListFilterWinClick
            end
            object tbtnAbstracts: TToolButton
              Left = 58
              Top = 0
              Hint = 'Open the Abstracts window'
              AutoSize = True
              Caption = 'tbtnAbstracts'
              ImageIndex = 1
              OnClick = tbtnAbstractsClick
            end
            object tbtnDHCPrpt: TToolButton
              Left = 87
              Top = 0
              Hint = 'Open the VistA Health Summary Reports window'
              Caption = 'Patient Profile'
              ImageIndex = 2
              OnClick = tbtnDHCPrptClick
            end
            object tbtnEKG: TToolButton
              Left = 116
              Top = 0
              Hint = 'Open the MUSE EKG viewing window'
              Caption = 'tbtnEKG'
              ImageIndex = 13
              OnClick = tbtnEKGClick
            end
            object tbtnUserPref: TToolButton
              Left = 145
              Top = 0
              Hint = 'Open the User Preferences window'
              Caption = 'tbtnUserPref'
              ImageIndex = 4
              OnClick = tbtnUserPrefClick
            end
            object tbtnPatient: TToolButton
              Left = 174
              Top = 0
              Hint = 'Select a Patient'
              Caption = 'tbtnPatient'
              ImageIndex = 6
              OnClick = tbtnPatientClick
            end
            object tbtnRIVConfigure: TToolButton
              Left = 203
              Top = 0
              Hint = 'Remote Image Views Configuration'
              Caption = 'tbtnRIVConfigure'
              ImageIndex = 17
              OnClick = tbtnRIVConfigureClick
            end
          end
        end
      end
      object pPatInfo: TPanel
        Left = 1
        Top = 61
        Width = 420
        Height = 26
        Align = alBottom
        Alignment = taLeftJustify
        BevelInner = bvLowered
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object pPatinfo2: TPanel
          Left = 2
          Top = 2
          Width = 353
          Height = 22
          Align = alLeft
          Alignment = taLeftJustify
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
    object pnlPatPhoto: TPanel
      Left = 1
      Top = 1
      Width = 84
      Height = 88
      Align = alLeft
      AutoSize = True
      Caption = 'pnlPatPhoto'
      Color = 14737359
      TabOrder = 1
      Visible = False
      object MagPatPhoto1: TMagPatPhoto
        Left = 1
        Top = 1
        Width = 82
        Height = 86
        Align = alClient
        Color = 14737359
        ParentColor = False
        TabOrder = 0
        MagHideWhenNull = False
      end
    end
  end
  object pnlbase: TPanel
    Left = 0
    Top = 90
    Width = 508
    Height = 26
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object pmsg: TPanel
      Left = 63
      Top = 0
      Width = 445
      Height = 26
      Align = alClient
      BevelInner = bvLowered
      Constraints.MaxHeight = 2000
      Constraints.MaxWidth = 2000
      Constraints.MinHeight = 10
      Constraints.MinWidth = 10
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnMouseMove = pmsgMouseMove
    end
    object pnlMsgHistorybtn: TPanel
      Left = 0
      Top = 0
      Width = 23
      Height = 26
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object btnMsgHistory: TBitBtn
        Left = 1
        Top = 1
        Width = 22
        Height = 25
        Hint = 'Show/Hide message window'
        TabOrder = 0
        TabStop = False
        OnClick = btnMsgHistoryClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555500000000
          0555555F7777777775F55500FFFFFFFFF0555577F5FFFFFFF7F550F0FEEEEEEE
          F05557F7F777777757F550F0FFFFFFFFF05557F7F5FFFFFFF7F550F0FEEEEEEE
          F05557F7F777777757F550F0FF777FFFF05557F7F5FFFFFFF7F550F0FEEEEEEE
          F05557F7F777777757F550F0FF7F777FF05557F7F5FFFFFFF7F550F0FEEEEEEE
          F05557F7F777777757F550F0FF77F7FFF05557F7F5FFFFFFF7F550F0FEEEEEEE
          F05557F7F777777757F550F0FFFFFFFFF05557F7FF5F5F5F57F550F00F0F0F0F
          005557F77F7F7F7F77555055070707070555575F7F7F7F7F7F55550507070707
          0555557575757575755555505050505055555557575757575555}
        NumGlyphs = 2
        Style = bsNew
      end
    end
    object pnlSiteCode: TPanel
      Left = 23
      Top = 0
      Width = 40
      Height = 26
      Hint = 'Code for the User'#39's Division'
      Align = alLeft
      BevelInner = bvLowered
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object lstboxCache: TFileListBox
    Left = 292
    Top = 158
    Width = 145
    Height = 97
    ItemHeight = 14
    TabOrder = 2
    Visible = False
  end
  object dirlstboxCache: TDirectoryListBox
    Left = 136
    Top = 167
    Width = 145
    Height = 97
    ItemHeight = 16
    TabOrder = 3
    Visible = False
  end
  object MainMenu1: TMainMenu
    Images = imglstMainMenu
    Left = 31
    Top = 17
    object mnuFile: TMenuItem
      Caption = '&File'
      HelpContext = 10072
      object mnuSelectPatient: TMenuItem
        Caption = 'Select Patient...'
        HelpContext = 10145
        ImageIndex = 4
        OnClick = mnuSelectPatientClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuLogin: TMenuItem
        Caption = 'Log&in'
        HelpContext = 10182
        OnClick = mnuLoginClick
      end
      object mnuLogout: TMenuItem
        Caption = 'Logou&t'
        OnClick = mnuLogoutClick
      end
      object mnuLocal9300: TMenuItem
        Caption = 'Local 9300 Kirin'
        Visible = False
        OnClick = mnuLocal9300Click
      end
      object mnuLocal9400: TMenuItem
        Caption = 'Local 9400 Kirin'
        Visible = False
        OnClick = mnuLocal9400Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuRemoteLogin: TMenuItem
        Caption = '&Remote Login'
        OnClick = mnuRemoteLoginClick
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object mnuContext: TMenuItem
      Caption = '&Context'
      object mnuShowContext: TMenuItem
        Caption = 'Show &Context'
        OnClick = mnuShowContextClick
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object mnuSuspendContext: TMenuItem
        Caption = '&Suspend Context'
        OnClick = mnuSuspendContextClick
      end
      object mnuResumeGetContext: TMenuItem
        Caption = 'Resume &Get Context'
        OnClick = mnuResumeGetContextClick
      end
      object mnuResumeSetContext: TMenuItem
        Caption = 'Resume &Set Context'
        OnClick = mnuResumeSetContextClick
      end
    end
    object Options1: TMenuItem
      Caption = '&Options'
      HelpContext = 10072
      object mnuOpenDirectory: TMenuItem
        Caption = 'Open Di&rectory...'
        Visible = False
        OnClick = mnuOpenDirectoryClick
      end
      object mnuDemoImages: TMenuItem
        Caption = '&Demo Patient Images...'
        Visible = False
        OnClick = mnuDemoImagesClick
      end
      object mnuFakeName: TMenuItem
        Caption = 'Use Fake Name'
        Visible = False
        OnClick = mnuFakeNameClick
      end
      object mnuLocalMuse: TMenuItem
        Caption = 'Use Local Muse Images for Live Demo'
        Visible = False
        OnClick = mnuLocalMuseClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuImagelistFilters: TMenuItem
        Caption = 'Image List Filters...'
        HelpContext = 10093
        ImageIndex = 1
        ShortCut = 16460
        OnClick = mnuImagelistFiltersClick
      end
      object mnuViewPrefercences: TMenuItem
        Caption = '&User Preferences...'
        HelpContext = 10209
        ImageIndex = 3
        OnClick = mnuViewPrefercencesClick
      end
      object mnuRIV: TMenuItem
        Caption = 'Remote Image Views Configuration...'
        ImageIndex = 8
        OnClick = mnuRIVClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuRefreshPatientImages: TMenuItem
        Caption = 'Refresh Patient Images'
        Enabled = False
        ImageIndex = 19
        OnClick = mnuRefreshPatientImagesClick
      end
      object mnuPrefetch: TMenuItem
        Caption = 'PreFetch Patient Images'
        Enabled = False
        OnClick = mnuPrefetchClick
      end
      object mMUSEPatientlookup: TMenuItem
        Caption = 'MUSE Settings'
        Enabled = False
        Visible = False
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mnuSaveSettingsNow: TMenuItem
        Caption = '&Save Settings Now'
        HelpContext = 10174
        OnClick = mnuSaveSettingsNowClick
      end
      object mnuSaveSettingsOnExit: TMenuItem
        AutoCheck = True
        Caption = 'Save Settings On &Exit'
        HelpContext = 10174
        OnClick = mnuSaveSettingsOnExitClick
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object mnuShowHints: TMenuItem
        Caption = 'Show &Hints'
        OnClick = mnuShowHintsClick
        object mnuMainHint: TMenuItem
          Caption = 'Main Imaging Display window'
          Checked = True
          OnClick = mnuMainHintClick
        end
        object N11: TMenuItem
          Caption = '-'
        end
        object mnuTurnHintsOFFforallwindows: TMenuItem
          Caption = 'Turn Hints OFF for all windows'
          OnClick = mnuTurnHintsOFFforallwindowsClick
        end
        object mnuTurnHintsONforallwindows: TMenuItem
          Caption = 'Turn Hints ON for all windows'
          OnClick = mnuTurnHintsONforallwindowsClick
        end
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object mnuCPRSLinkOptions: TMenuItem
        Caption = 'CPRS Link Options...'
        Enabled = False
        OnClick = mnuCPRSLinkOptionsClick
      end
      object mnuIconShortCutKeyLegend: TMenuItem
        Caption = 'ShortCut Key Legend...'
        OnClick = mnuIconShortCutKeyLegendClick
      end
      object mnuMessageLog: TMenuItem
        Caption = 'Message Log...'
        OnClick = mnuMessageLogClick
      end
      object MultiImagePrintROITest1: TMenuItem
        Caption = 'MultiImagePrint ROI Test'
        Visible = False
        OnClick = MultiImagePrintROITest1Click
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      HelpContext = 10072
      OnClick = View1Click
      object mnuImageList: TMenuItem
        Caption = '&Image List...'
        Enabled = False
        HelpContext = 10097
        ImageIndex = 5
        OnClick = mnuImageListClick
      end
      object mnuAbstracts: TMenuItem
        Caption = '&Abstracts...'
        Enabled = False
        HelpContext = 10000
        ImageIndex = 6
        OnClick = mnuAbstractsClick
      end
      object mnuMUSEEKGlist: TMenuItem
        Caption = 'MUSE &EKG Window...'
        Enabled = False
        HelpContext = 7
        ImageIndex = 0
        OnClick = mnuMUSEEKGlistClick
      end
      object mnuGroupWindow: TMenuItem
        Caption = 'Group Window...'
        Enabled = False
        HelpContext = 10000
        OnClick = mnuGroupWindowClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object mnuRadiologyExams: TMenuItem
        Caption = '&Radiology Exams...'
        Enabled = False
        HelpContext = 10161
        OnClick = mnuRadiologyExamsClick
      end
      object mnuMedicineProcedures: TMenuItem
        Caption = '&Medicine Procedures...'
        Enabled = False
        Visible = False
      end
      object mnuLabExams: TMenuItem
        Caption = '&Lab Exams...'
        Enabled = False
        Visible = False
      end
      object mnuSurgicalOperations: TMenuItem
        Caption = '&Surgical Operations...'
        Enabled = False
        Visible = False
      end
      object mnuProgressNotes: TMenuItem
        Caption = 'Progress &Notes...'
        Enabled = False
        HelpContext = 10155
        OnClick = mnuProgressNotesClick
      end
      object mnuClinicalProcedures: TMenuItem
        Caption = 'Clinical Procedures'
        Enabled = False
        Visible = False
        OnClick = mnuClinicalProceduresClick
      end
      object mnuConsults: TMenuItem
        Caption = 'Consults'
        Enabled = False
        Visible = False
        OnClick = mnuConsultsClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object mnuToolbar: TMenuItem
        Caption = '&Toolbar - Main'
        Checked = True
        OnClick = mnuToolbarClick
      end
      object Windows1: TMenuItem
        Caption = 'Active windows...'
        ShortCut = 16471
        OnClick = Windows1Click
      end
      object mnuFullResSpecial: TMenuItem
        Caption = 'Full Res Special'
        OnClick = mnuFullResSpecialClick
      end
    end
    object mnuMainUtilities: TMenuItem
      Caption = '&Utilities'
      Enabled = False
      OnClick = mnuMainUtilitiesClick
      object mnuMainQAReview: TMenuItem
        Caption = '&QA Review...'
        OnClick = mnuMainQAReviewClick
      end
      object mnuMainQAReviewReport: TMenuItem
        Caption = 'QA Review Report...'
        OnClick = mnuMainQAReviewReportClick
      end
    end
    object Reports1: TMenuItem
      Caption = '&Reports'
      HelpContext = 10210
      OnClick = Reports1Click
      object mnuPatientProfile: TMenuItem
        Caption = '&Patient Profile'
        Enabled = False
        HelpContext = 10210
        OnClick = mnuPatientProfileClick
      end
      object mnuHealthSummary: TMenuItem
        Caption = '&Health Summary...'
        Enabled = False
        ImageIndex = 2
        OnClick = mnuHealthSummaryClick
      end
      object mnuDischargeSummaries: TMenuItem
        Caption = 'Discharge Summary...'
        Enabled = False
        OnClick = mnuDischargeSummariesClick
      end
    end
    object mSystemManager: TMenuItem
      Caption = '&System Manager'
      Visible = False
      OnClick = mSystemManagerClick
      object mMagINI: TMenuItem
        Caption = 'Workstation Configuration window...'
        OnClick = mMagINIClick
      end
      object mnuClearPatient: TMenuItem
        Caption = '&Clear Current Patient'
        OnClick = mnuClearPatientClick
      end
      object mSecurityON: TMenuItem
        Caption = 'Image File NetSecurity ON'
        OnClick = mSecurityONClick
      end
      object MagSecMsg: TMenuItem
        Caption = 'Show Messages from last OpenSecureFile Call'
        OnClick = MagSecMsgClick
      end
      object ChangeTimeoutvalue1: TMenuItem
        Caption = 'Change Timeout value'
        OnClick = ChangeTimeoutvalue1Click
      end
      object TestEnableDisable1: TMenuItem
        Caption = 'Patient Lookup/Login Enabled'
        Checked = True
        OnClick = TestEnableDisable1Click
      end
      object SetWorkstationAlternaterVideoViewer1: TMenuItem
        Caption = 'Set Workstation'#39's Alternate Video Viewer'
        OnClick = SetWorkstationAlternaterVideoViewer1Click
      end
    end
    object mnuHelp: TMenuItem
      Caption = '&Help'
      HelpContext = 10072
      OnClick = mnuHelpClick
      object Contents1: TMenuItem
        Caption = '&Contents...'
        OnClick = Contents1Click
      end
      object ImagingDisplayWindow1: TMenuItem
        Caption = '&Imaging Display Window...'
        HelpContext = 10071
        OnClick = ImagingDisplayWindow1Click
      end
      object mImageDeleteHelp: TMenuItem
        Caption = 'Image Delete Help screen...'
        Visible = False
        OnClick = mImageDeleteHelpClick
      end
      object mSysManhelp: TMenuItem
        Caption = 'System Manager help...'
        Visible = False
        OnClick = mSysManhelpClick
      end
      object ErrorCodelookup1: TMenuItem
        Caption = 'Error Code lookup...'
        OnClick = ErrorCodelookup1Click
      end
      object Legal1: TMenuItem
        Caption = 'Legal Notices...'
        OnClick = Legal1Click
      end
      object mnuScreenSettings1: TMenuItem
        Caption = '&ScreenSettings...'
        OnClick = mnuScreenSettings1Click
      end
      object mnuUseInternetExplorerforhelp: TMenuItem
        Caption = 'Use Internet Explorer for help'
        Checked = True
        Enabled = False
        OnClick = mnuUseInternetExplorerforhelpClick
      end
      object mnuAbout: TMenuItem
        Caption = '&About...'
        OnClick = mnuAboutClick
      end
    end
    object mTest1: TMenuItem
      Caption = 'Test'
      Visible = False
      OnClick = mTest1Click
      object testVersionChecking1: TMenuItem
        Caption = 'Test Version Checking'
        OnClick = testVersionChecking1Click
      end
      object SetTimeoutto2seconds1: TMenuItem
        Caption = 'Set Timeout to 5 seconds'
        OnClick = SetTimeoutto2seconds1Click
      end
      object mnuPrototypes: TMenuItem
        Caption = 'Prototypes'
        OnClick = mnuPrototypesClick
        object mnuStickToCPRS: TMenuItem
          AutoCheck = True
          Caption = 'StickToCPRS'
          OnClick = mnuStickToCPRSClick
        end
        object VerifyImages1: TMenuItem
          Caption = 'Verify Images'
          OnClick = VerifyImages1Click
        end
        object mnuDraggingSizing: TMenuItem
          Caption = 'Dragging/Sizing/FullRes for Rad'
          OnClick = mnuDraggingSizingClick
        end
        object mnuEnableDemo: TMenuItem
          Caption = 'Enable Demo'
          OnClick = mnuEnableDemoClick
        end
        object mnuGroupBrowsePlay: TMenuItem
          Caption = 'GroupBrowsePlay'
          OnClick = mnuGroupBrowsePlayClick
        end
        object N12: TMenuItem
          Caption = '-'
        end
        object mnuFullRes: TMenuItem
          Caption = 'open Full Res Window...'
          OnClick = mnuFullResClick
        end
        object OpenImagebyID1: TMenuItem
          Caption = 'Open Image by ID#...'
          OnClick = OpenImagebyID1Click
        end
      end
      object mnuTestPatOnlyLookup1: TMenuItem
        Caption = 'Test PatOnlyLookup'
        OnClick = mnuTestPatOnlyLookup1Click
      end
      object UseOldImageListCallMAG4PATGETIMAGES1: TMenuItem
        AutoCheck = True
        Caption = 'Use Old Image List Call MAG4 PAT GET IMAGES'
        OnClick = UseOldImageListCallMAG4PATGETIMAGES1Click
      end
      object StripLeadTrailComma1: TMenuItem
        Caption = 'StripLeadTrailComma'
        OnClick = StripLeadTrailComma1Click
      end
      object GetFMSetSelections1: TMenuItem
        Caption = 'Get FM Set Selections'
        object ImagePackage1: TMenuItem
          Caption = 'Image Package...'
          OnClick = ImagePackage1Click
        end
        object mnuTESTImageStatus1: TMenuItem
          Caption = 'Image Status...'
          OnClick = mnuTESTImageStatus1Click
        end
        object ImageStatusNoDeleteNoInProgress1: TMenuItem
          Caption = 'ImageStatusNoDeleteNoInProgress'
          OnClick = ImageStatusNoDeleteNoInProgress1Click
        end
      end
      object GetReason1: TMenuItem
        Caption = 'Get Reason Dlg'
        object Print1: TMenuItem
          Caption = 'Print'
          OnClick = Print1Click
        end
        object Copy1: TMenuItem
          Caption = 'Copy'
          OnClick = Copy1Click
        end
        object Delete1: TMenuItem
          Caption = 'Delete'
          OnClick = Delete1Click
        end
        object Status1: TMenuItem
          Caption = 'Status'
          OnClick = Status1Click
        end
      end
      object DreamWeverWebHelpFiles1: TMenuItem
        Caption = 'DreamWever WebHelpFiles'
        OnClick = DreamWeverWebHelpFiles1Click
      end
      object WebHelp1: TMenuItem
        Caption = 'WebHelp'
        OnClick = WebHelp1Click
      end
      object UseOldHelp1: TMenuItem
        Caption = 'Show Old Help'
        OnClick = UseOldHelp1Click
      end
      object ExplorePatientProcedures1: TMenuItem
        Caption = 'Procedure Explorer...'
        OnClick = ExplorePatientProcedures1Click
      end
      object OpenAdobe1: TMenuItem
        Caption = 'Open Adobe'
        OnClick = OpenAdobe1Click
      end
      object MessageSend1: TMenuItem
        Caption = 'Test Windows messaging: send Patient Name'
        OnClick = MessageSend1Click
      end
      object mnuTestSimulateMessageFromCPRS1: TMenuItem
        Caption = 'Test Simulate Message From CPRS'
        OnClick = mnuTestSimulateMessageFromCPRS1Click
      end
      object KernelBrokerDEBUGMode1: TMenuItem
        Caption = 'Kernel Broker DEBUG Mode'
        OnClick = KernelBrokerDEBUGMode1Click
      end
      object mWrksCacheOn: TMenuItem
        Caption = 'Abstract Cache ON'
        OnClick = mWrksCacheOnClick
      end
      object mFormNames: TMenuItem
        Caption = 'List All Open Forms'
        OnClick = mFormNamesClick
      end
      object ListAppOpenForms1: TMenuItem
        Caption = 'List App Visible Open Forms'
        OnClick = ListAppOpenForms1Click
      end
      object showhiddenmenuoptions1: TMenuItem
        Caption = 'show hidden menu options'
        OnClick = showhiddenmenuoptions1Click
      end
      object mnuSecurityKeyAddDelete: TMenuItem
        Caption = 'Security Key Add/Delete'
        OnClick = mnuSecurityKeyAddDeleteClick
        object mnukeyMagSystem: TMenuItem
          AutoCheck = True
          Caption = 'Key : MAG SYSTEM'
          OnClick = mnukeyMagSystemClick
        end
        object mnuKeyMagdispclin: TMenuItem
          AutoCheck = True
          Caption = 'Key : MAGDISP CLIN'
          OnClick = mnuKeyMagdispclinClick
        end
        object mnuKeyMagdispadmin: TMenuItem
          AutoCheck = True
          Caption = 'Key : MAGDISP ADMIN'
          OnClick = mnuKeyMagdispadminClick
        end
        object mnuKeyMagPatPhotoOnly: TMenuItem
          Caption = 'Key : MAG PATIENT PHOTO ONLY'
          OnClick = mnuKeyMagPatPhotoOnlyClick
        end
        object mnuSelectKey: TMenuItem
          Caption = 'Select Key...'
          OnClick = mnuSelectKeyClick
        end
      end
      object GetCTPresets1: TMenuItem
        Caption = 'Get CT Presets'
        OnClick = GetCTPresets1Click
      end
      object SaveCTPresets1: TMenuItem
        Caption = 'Save CT Presets'
        OnClick = SaveCTPresets1Click
      end
      object mnuSetDOSDir: TMenuItem
        Caption = 'set DOS Directory'
        OnClick = mnuSetDOSDirClick
      end
      object chdir1: TMenuItem
        Caption = 'chdir'
        OnClick = chdir1Click
      end
      object ICN1: TMenuItem
        Caption = 'switch to ICN'
        OnClick = ICN1Click
      end
      object RemoteBrokerDetails1: TMenuItem
        Caption = 'Remote Broker Details'
        OnClick = RemoteBrokerDetails1Click
      end
      object ManuallyConnecttoRemoteSite1: TMenuItem
        Caption = 'Manually Connect to Remote Site'
        OnClick = ManuallyConnecttoRemoteSite1Click
      end
      object DemoRemoteSites1: TMenuItem
        Caption = 'Demo Remote Sites'
        OnClick = DemoRemoteSites1Click
      end
      object mnuTestmagpubUnSelectAll: TMenuItem
        Caption = 'magpubUnSelectAll'
        OnClick = mnuTestmagpubUnSelectAllClick
      end
    end
    object mnuTestScript: TMenuItem
      Caption = 'Test-Script'
      Visible = False
      object mnuTestScriptDontUseCCOW: TMenuItem
        AutoCheck = True
        Caption = 'Dont use CCOW'
        OnClick = mnuTestScriptDontUseCCOWClick
      end
    end
  end
  object timerTimeout: TTimer
    Interval = 7200000
    OnTimer = timerTimeoutTimer
    Left = 23
    Top = 122
  end
  object imglstMainToolbar: TImageList
    Height = 22
    Width = 22
    Left = 196
    Top = 129
    Bitmap = {
      494C010115001700040016001600FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      00000000000036000000280000005800000084000000010020000000000080B5
      000000000000000000000000000000000000BD381000CE694A00D6694A00CE61
      4200C6593900C6593900CE614200CE694A00D6694A00D6694A00C6614200D669
      4A00D6694A00D6694A00CE614200B5492900CE614200CE694A00D6694A00B551
      3100CE593900BD38100000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900D6EFF700D6E7EF00DEEF
      F700DEEFF700DEEFF700DEEFF700DEEFF700DEEFF700D6EFEF00CEE7E700D6E7
      EF00DEEFF700DEEFF700DEEFF700DEEFF700DEEFF700DEEFF700D6EFEF00ADB6
      BD00E7BEAD00CE61420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900DEF7F700D6EFEF00ADBE
      BD00BDCFCE00B5C7CE00B5C7C600B5BEC600B5C7C600C6CFD600D6E7E700DEEF
      EF00A5B6B500ADBEBD00BDC7CE00ADBEBD00B5BEC600ADBEBD00C6D7DE00A5B6
      B500FFF7F700C659390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DE6942008C9EA500ADBEC600A5AE
      B500A5B6B500ADBEBD009CAEAD0094A6A500A5B6B5009CAEAD00BDCFCE008C96
      94009CAEAD00A5B6B5009CA6AD009CAEAD009CA6AD00A5B6B500A5B6B500A5B6
      BD00FFFFFF00C659390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6694200BDC7CE00CED7D600CED7
      D600CED7D600D6DFDE00C6CFD600BDC7CE00D6DFDE00C6CFD600CED7DE00BDC7
      C600C6CFD600CEDFDE00C6CFCE00C6CFCE00C6CFCE00D6DFDE00CED7D600A5B6
      B500FFFFFF00CE61420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900FFFFFF00FFFFFF00FFFF
      FF00F7F7F700F7F7F700F7F7F700FFFFFF00FFFFFF00FFFFFF00E7EFEF00FFFF
      FF00FFFFFF00FFFFFF00E7E7E700F7F7F700FFFFFF00FFFFFF00FFFFFF00A5B6
      B500FFFFFF00CE61420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900FFFFFF00FFFFFF00FFFF
      FF00EFEFEF00DEDFDE00E7E7E700E7E7E700FFFFFF00FFFFFF00E7EFEF00FFFF
      FF00FFFFFF00FFFFFF00D6D7D600E7E7E700FFFFFF00FFFFFF00FFFFFF00A5B6
      B500EFEFEF00C659310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900FFFFFF00FFFFFF00FFFF
      FF00EFEFEF009CAEAD00BDC7C600DEDFDE00FFFFFF00FFFFFF00E7EFEF00FFFF
      FF00FFFFFF00FFFFFF009C969400ADBEBD00FFFFFF00FFFFFF00FFFFFF00A5B6
      B500F7CFB500C659390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900D6E7EF00D6E7E700D6E7
      E700D6E7E700D6E7EF00D6E7EF00D6E7E700D6E7E700D6E7E700E7798400E779
      8400E7798400E7798400E7798400E7798400E7798400E7798400E7798400A5B6
      BD00F7F7F700CE61420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900DEEFF700D6EFEF00D6E7
      EF00D6EFEF00D6EFEF00D6EFEF00D6E7EF00D6EFEF00D6EFEF00DE694200DEC7
      C600DEC7C600DEBEC600DEBEC600DEC7C600DEBEC600DEC7C600DEBEC600A5AE
      B500FFFFFF00CE61420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900CEDFE700C6DFDE00ADB6
      BD00A5AEB500ADBEBD00ADBEBD00ADBEBD00ADBEBD00BDCFCE00E7798400C6DF
      DE00A5AEB500A5B6B500A5B6B500B5C7C600B5C7C600B5C7C600C6CFCE00A5AE
      B500FFFFFF00C659390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DE6942008C9694009CAEAD009CAE
      AD00A5AEB500949EA500949EA5009CAEAD00949EA500949EA500CE694A008C96
      94009CA6AD00A5AEB500949EA5009CA6AD008C969400B5C7C600949EA500A5AE
      B500FFFFFF00CE59390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900FFFFFF00FFFFFF00FFFF
      FF00F7F7F700EFEFEF00EFEFEF00FFFFFF00FFFFFF00FFFFFF00F7868400FFFF
      FF00FFFFFF00FFFFFF00DEDFDE00EFEFEF00FFFFFF00FFFFFF00FFFFFF00A5AE
      B500FFFFFF00C659310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900FFFFFF00FFFFFF00FFFF
      FF00F7F7F700EFEFEF00F7F7F700FFFFFF00FFFFFF00FFFFFF00F7868400FFFF
      FF00FFFFFF00FFFFFF00EFEFEF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A5AE
      B500FFFFFF00CE61420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900FFFFFF00FFFFFF00FFFF
      FF00EFEFEF00BDC7C600CECFCE00EFEFEF00FFFFFF00FFFFFF00F7868400FFFF
      FF00FFFFFF00FFFFFF00A5B6B500C6CFD600FFFFFF00FFFFFF00FFFFFF00A5AE
      B500FFF7EF00CE61420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D6613900E7F7F700EFF7F700EFF7
      F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700EFF7F700E7798400F7AE
      AD00F7AEAD00F7AEAD00F7AEAD00F7AEAD00F7AEAD00F7AEAD00F7AEAD00A5B6
      B500EFC7AD00C659390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C65939009CAEAD0094A6AD0094A6
      AD009CAEAD009CAEAD009CAEAD009CAEAD0094A6AD009CAEAD009C9694009C8E
      94009C8E94009C8E94009C9694009C8E94009C8E94009C8E94009C8E9400A5B6
      B500E7BEAD00CE59390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CE59390094A6AD00B5C7CE00B5C7
      CE00A5B6BD00ADC7C6008C9EA5008C96940094A6AD0094A6AD008C969400A5AE
      B500B5C7CE0094A6AD008C9EA500D6EFEF009CAEAD00CEE7E700DEF7F700DEF7
      F700DEF7F700C661420000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CE593900A5AEB500CEBEB500CEBE
      B500CEBEB500CEBEB500CEBEB500CEBEB500CEBEB500CEBEB500CEBEB500CEBE
      B500CEBEB5009C969400CEBEB500CEBEB500A5AEB500CEBEB500D6D7D600F7CF
      B500F7CFB500C651390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E7490000B5492900B5492900F786
      8400E7798400F7868400DE694200DE969400DE694200F7711000DE969400F786
      8400F7711000F7711000F7690800F7868400DE694200DE694200DE6942008C9E
      A50094A6AD00BD38100000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E74900008C9694008C969400F786
      8400E7798400DE694200DE694200DE694200DE694200F7690800DE969400F786
      8400F7690800E7510000E7510000F7868400DE694200F7868400F786840094A6
      AD00ADC7C600BD38100000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F7868400F7690800F7711000F771
      1000F7711000F7711000F7711000F7711000F7711000F7711000F7711000F771
      1000F7711000F7711000F7711000F7711000F7711000F7711000F7711000F771
      1000F7711000E779840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008C510800AD610800AD690800BD710800D6790800E78E
      0800000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000006B410000633810006B411800634118006B41
      1800633810006B41000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CE866300D69E
      8C00D69E8C00D69E8C00D69E8C00D69E8C00D69E8C00D69E8C00D69E8C00D69E
      8C00D69E8C00D69E8C00D69E8C00D69E8C00D69E8C00D69E8C00D69E8C00D69E
      8C00D69E8C00D69E8C00D69E8C00C6715A000000000000000000000000006B41
      0000633810006B411800634118006B411800633810006B41000094590800CE79
      0800E78E08000000000000000000000000000000000000000000000000000000
      000000000000000000006338000084595200C6969400C6969400C6969400C696
      9400C696940084595200633800000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000C69E8C00D6EFEF00D6EFEF00BDCFD600CEDFE700BDD7D600CEDFDE00C6D7
      DE00BDCFD600BDD7D600CEDFE700C6D7DE00C6DFDE00BDD7D600C6D7DE00BDD7
      DE00CEE7EF00D6EFF700D6EFF700D6EFF700D6EFEF00CEA69C00DEBEAD00CEDF
      DE00CEDFE700CEDFDE00D6E7E700D6E7EF00D6E7EF00D6E7EF00D6E7E700D6E7
      E700D6E7EF00D6E7EF00D6E7E700D6E7EF00D6E7EF00CEE7E700D6E7EF00D6E7
      E700D6E7EF00D6E7EF00D6E7EF00D6B6AD000000000000000000633800008459
      5200C6969400C6969400C6969400C6969400C69694008459520063380000A561
      0800DE860800FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000084593900C69E9C00CEBEBD00DECFCE00DEDFDE00DECF
      CE00CEBEBD00C69E9C008459390000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF0000000000000000000000
      0000DE967B00F7D7CE00F7D7C600F7D7C600F7D7C600FFDFCE00F7D7C600F7D7
      C600FFD7C600F7DFCE00F7FFFF00F7FFFF00F7FFFF00F7FFFF00F7FFFF00FFFF
      FF00F7FFFF00F7F7FF00F7F7F700F7F7FF00EFCFBD00CEA69C00DEBEB500A5BE
      AD009CB6A500B5BEC600BDCFD600DEEFEF00BDC7C600949E9C00BDCFCE00CEDF
      DE00DEEFEF00BDCFCE00C6D7D600D6EFEF00DEEFEF00BDAEBD00ADBEC600BDCF
      D600D6E7E700DEEFEF00DEEFEF00D6B6AD00000000000000000084593900C69E
      9C00CEBEBD00DECFCE00DEDFDE00DECFCE00CEBEBD00C69E9C0084593900A561
      0800DE8608000000000000000000000000000000000000000000FF0000000000
      000000000000000000009C694200C68E8C00CE969400D6B6B500DEDFDE00D6B6
      B500CE969400C68E8C009C6942000000000000000000000000000000FF000000
      FF00000000000000000000000000000000000000FF0000000000000000000000
      0000DEAE9400EFF7F700EFEFEF00FFFFFF00FFFFFF00DEDFDE00F7F7FF00FFFF
      FF00FFFFFF00F7FFFF00CED7CE00CECFCE00E7E7E700FFFFFF00D6D7D600CECF
      CE00DEDFDE00D6D7D600FFFFFF00FFFFFF00DEDFE700DEA68C00DEBEAD00CED7
      DE00CEDFDE00CEDFDE00CEDFE700DEEFEF00DEEFEF00DEEFEF00D6E7EF00D6E7
      E700D6E7E700D6E7E700D6E7E700D6E7E700D6E7E700D6E7E700D6E7EF00D6E7
      E700CEDFE700CEE7E700D6E7E700CEB6AD0000000000000000009C694200C68E
      8C00CE969400D6B6B500DEDFDE00D6B6B500CE969400C68E8C009C694200C671
      0800000000000000000000000000000000000000000000000000FF0000000000
      000000000000000000007B49080094595200CE696B00D6969400DEC7C600D696
      9400CE696B00945952007B490800BD7108000000000000000000000000000000
      FF00000000000000000000000000000000000000FF0000000000000000000000
      0000DEAE9400EFF7F700EFEFEF00FFFFFF00FFFFFF00DEDFDE00F7F7F700FFFF
      FF00FFFFFF00F7FFFF00D6D7D600DEDFDE00FFFFFF00FFFFFF00DEDFDE00CECF
      CE00E7E7E700DEDFDE00FFFFFF00FFFFFF00DEE7E700DEAEA500D6B6A500BDCF
      D600C6D7D600B5C7C600D6E7EF00DEEFEF00DEEFEF00D6E7E700C6D7DE00C6D7
      DE00C6D7DE00C6D7DE00C6D7DE00C6D7DE00D6DFDE00DEE7E700DEE7E700DEE7
      E700DEE7E700DEE7E700CED7D600BD9E940000000000000000007B4908009459
      5200CE696B00D6969400DEC7C600D6969400CE696B00945952007B490800BD71
      0800E78E08000000000000000000000000000000000000000000FF0000000000
      00000000000000000000000000006B382100CE797B00CE868400CE868400CE86
      8400CE797B006B38210052300000845108000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000DEAE9400F7F7F700F7F7F700FFFFFF00FFFFFF00DEDFDE00F7F7F700FFFF
      FF00FFFFFF00F7F7FF00D6D7D600D6D7D600EFEFEF00FFFFFF00DEDFDE00CECF
      CE00E7E7E700E7E7E700FFFFFF00FFFFFF00DEDFDE00DEAE9C00CEAE9C00BDCF
      CE00CEDFDE00CED7DE00CEDFDE00CEDFE700CEDFDE00D6E7EF00DEEFEF00DEEF
      EF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00E7EFEF00F7F7F700EFF7F700EFF7
      F700EFEFF700EFEFEF00D6DFDE00C6AE9C000000000000000000000000006B38
      2100CE797B00CE868400CE868400CE868400CE797B006B382100523000008451
      0800CE79080000000000000000008C510800AD610800AD690800FF000000D679
      0800E78E080000000000F7B65200F7B65200F7B65200F7B65200FFB63100FFB6
      3100F7B65200F7B65200CE797B006B3800000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000DEAE9400EFEFEF00E7EFEF00FFFFFF00FFFFFF00DEDFDE00F7F7F700FFFF
      FF00FFFFFF00F7FFFF00D6D7D600D6DFDE00EFEFEF00FFFFFF00DEDFDE00CED7
      D600E7E7E700DEDFDE00FFFFFF00FFFFFF00DEDFDE00DEAE9C00E7BEAD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEEFEF00D6E7EF00D6EF
      EF00D6EFEF00D6EFEF00DEEFEF00DEEFEF00BDCFCE00B5C7CE00BDD7D600BDCF
      CE00CEE7E700D6EFEF00DEEFEF00C6A69C000000000000000000F7B65200F7B6
      5200F7B65200F7B65200FFB63100FFB63100F7B65200F7B65200CE797B006B38
      0000C6710800633810006B411800634118006B41180063381000FF0000009459
      0800CE790800E78E0800C6B69400FF000000FF000000FF000000FF000000FF00
      0000FF00000000860000CE797B006B38000000000000000000006B4100006338
      10006B411800634118006B411800633810006B41000094590800000000000000
      0000DEAE9400EFEFEF00FFFFFF00FFFFFF00FFFFFF00DEDFDE00F7F7F700FFFF
      FF00FFFFFF00F7FFFF00D6D7D600DEDFDE00F7F7F700FFFFFF00DEDFDE00CECF
      CE00E7E7E700DEDFDE00FFFFFF00FFFFFF00DEE7E700DEAE9C00E7BEAD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEE7EF00EFF7F700EFF7
      F700EFF7F700EFF7F700CEDFDE00D6EFEF00EFF7F700EFFFFF00EFF7FF00EFFF
      FF00EFF7F700EFF7F700D6E7E700C6A69C000000000000000000C6B694008441
      0000844100008441000084410000844100008441000084410000CE797B006B38
      0000C6710800C6969400C6969400C6969400C6969400C6969400845952006338
      0000A5610800DE860800C6B69400FFFF0000FFFFFF00FFFF0000FFFFFF000086
      00000086000000860000CE797B006B380000000000006338000084595200C696
      9400C6969400C6969400C6969400C69694008459520063380000A56108000000
      0000DEAE9400EFF7F700FFFFFF00FFFFFF00FFFFFF00D6DFDE00F7F7F700FFFF
      FF00FFFFFF00F7FFFF00CECFCE00D6D7D600F7F7F700FFFFFF00DEDFDE00CECF
      CE00DEDFDE00DEDFDE00FFFFFF00FFFFFF00DEDFDE00DEAE9C00E7BEAD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEE7E700C6CFD600D6E7
      E700D6DFE700D6DFE700CEDFE700DEEFEF00BDC7C600BDC7C600BDCFCE00B5C7
      C600BDC7C600D6DFE700CEDFE700C6A69C000000000000000000C6B694008441
      0000844100008441000084410000844100008441000084410000CE797B006B38
      0000C6710800CEBEBD00DECFCE00DEDFDE00DECFCE00CEBEBD00C69E9C008459
      3900A5610800DE860800C6B69400FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF00FFFF000000860000CE797B006B3800000000000084593900C69E9C00CEBE
      BD00DECFCE00DEDFDE00DECFCE00CEBEBD00C69E9C0084593900A56108000000
      0000DEAE9400EFF7F700FFFFFF00FFFFFF00FFFFFF00DEDFDE00F7F7F700FFFF
      FF00FFFFFF00F7FFFF00D6D7D600D6D7D600F7F7F700FFFFFF00DEDFDE00CED7
      D600DEDFDE00E7E7E700FFFFFF00FFFFFF00DEDFDE00DEAE9C00E7BEAD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEEFEF00DEEFEF00DEEF
      EF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFF700DEEFF700DEEFEF00DEEF
      F700DEEFF700DEEFEF00DEEFEF00C6A69C000000000000000000C6B694008441
      0000844100008441000084410000844100008441000084410000CE797B006B38
      0000C6710800CE969400D6B6B500DEDFDE00D6B6B500CE969400C68E8C009C69
      4200C671080000000000C6B69400FFFF0000C6C7C600C6C7C600FFFFFF00FFFF
      0000FFFFFF00FFFF0000CE797B006B380000000000009C694200C68E8C00CE96
      9400D6B6B500DEDFDE00D6B6B500CE969400C68E8C009C694200C67108000000
      0000DEAE9400EFEFEF00F7FFFF00FFFFFF00FFFFFF00DEDFDE00F7F7F700FFFF
      FF00FFFFFF00F7F7F700CECFCE00CED7D600E7EFEF00FFFFFF00D6DFDE00CECF
      CE00DEDFDE00D6D7D600FFFFFF00FFFFFF00DEDFDE00DE967B00E7BEAD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEEFEF00C6D7D600B5BE
      C600D6EFEF00DEE7EF00D6E7EF00D6E7E700D6E7E700DEEFEF00D6E7E700B5C7
      C600B5C7C600B5BEC600DEEFEF00C6A69C000000000000000000C6B694008441
      0000844100008441000084410000844100008441000084410000CE797B006B38
      0000C6710800CE696B00D6969400DEC7C600D6969400CE696B00945952007B49
      0800BD710800E78E0800C6B69400C6C7C600FFFFFF0000FFFF00C6C7C600FFFF
      FF00FFFF0000FFFFFF00CE797B006B380000000000007B49080094595200CE69
      6B00D6969400DEC7C600D6969400CE696B00945952007B490800BD710800E78E
      0800DEAE9400EFEFEF00F7FFFF00FFFFFF00FFFFFF00DEDFDE00F7F7F700FFFF
      FF00FFFFFF00FFFFFF00F7F7F700F7F7F700FFFFFF00FFFFFF00DEDFDE00CECF
      CE00DEDFDE00D6D7D600FFFFFF00FFFFFF00DEE7E700DE967B00E7BEAD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEEFEF00CEDFE700D6E7
      E700D6EFEF00D6E7E700D6E7EF00D6E7E700D6E7EF00DEEFEF00D6E7E700CEDF
      E700D6E7E700CEDFE700DEEFEF00C6A69C000000000000000000C6B694008441
      0000844100008441000084410000844100008441000084410000CE797B006B38
      0000C6710800CE797B00CE868400CE868400CE868400CE797B006B3821005230
      000084510800CE790800C6B69400C6C7C60000FFFF00FFFFFF00C6C7C600FFFF
      0000FFFFFF00FFFF0000CE797B006B38000000000000000000006B382100CE79
      7B00CE868400CE868400CE868400CE797B006B3821005230000084510800CE79
      0800DEAE9400EFEFEF00FFFFFF00FFFFFF00FFFFFF00DEDFDE00F7F7F700FFFF
      FF00FFFFFF00F7FFFF00CED7D600D6D7D600F7F7F700FFFFFF00DEDFDE00CECF
      CE00DEDFDE00DEDFDE00FFFFFF00FFFFFF00DEE7E700DE967B00E7BEAD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEEFEF00CEDFDE00CEDF
      DE00D6E7EF00D6E7E700D6E7EF00D6E7E700CEDFE700D6E7EF00D6E7E700CEDF
      E700D6EFEF00DEEFEF00DEEFEF00C6A69C000000000000000000C6B694008441
      0000844100008441000084410000844100008441000084410000CE797B006B38
      0000C6710800F7B65200F7B65200FFB63100FFB63100F7B65200F7B65200CE79
      7B006B380000C6710800C6B69400FFFFFF00C6C7C600C6C7C600FFFF0000FFFF
      FF00FFFF0000FFFFFF00CE797B008C51080000000000F7B65200F7B65200F7B6
      5200F7B65200FFB63100FFB63100F7B65200F7B65200CE797B006B380000C671
      0800DEAE9400EFEFEF00FFFFFF00FFFFFF00FFFFFF00DEDFDE00F7F7F700FFFF
      FF00FFFFFF00F7FFFF00D6D7D600D6D7D600F7F7F700FFFFFF00DEDFDE00CECF
      CE00DEDFDE00E7E7E700FFFFFF00FFFFFF00DEE7E700DE967B00DEBEAD00F7F7
      F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEEFEF00D6E7EF00D6E7
      E700D6E7E700CEDFDE00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEF
      EF00DEEFEF00DEEFEF00DEEFEF00C6A69C000000000000000000C6B694008441
      0000844100008441000084410000844100008441000084410000CE797B008C51
      0800CE790800FF000000FF000000FF000000FF000000FF00000000860000CE79
      7B006B380000C6710800CEA68C00CEA68C00CEA68C00CEA68C00CEA68C00CEA6
      8C00CEA68C00CEA68C00CE797B00CE79080000000000C6B69400FF000000FF00
      0000FF000000FF000000FF000000FF00000000860000CE797B006B380000C671
      0800DEA69400C6D7D600CEDFDE00CEDFE700CEDFE700BDC7CE00C6D7DE00CEDF
      E700CEDFE700CED7DE00BDC7CE00BDC7CE00C6D7DE00CEDFDE00BDC7CE00BDC7
      CE00BDC7CE00BDC7CE00CEDFE700CEDFE700BDC7CE00DEA68C00D6AE9C00E7EF
      EF00F7F7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00DEE7EF00D6E7EF00D6E7
      E700D6E7E700D6E7EF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEFEF00DEEF
      EF00DEEFEF00DEEFEF00DEEFEF00C6AE9C000000000000000000CEA68C00CEA6
      8C00CEA68C00CEA68C00CEA68C00CEA68C00CEA68C00CEA68C00CE797B00CE79
      080000000000FFFFFF00FFFF0000FFFFFF00008600000086000000860000CE79
      7B006B380000C671080000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6B69400FFFF0000FFFF
      FF00FFFF0000FFFFFF00008600000086000000860000CE797B006B380000C671
      0800C69E8C00BDC7CE00D6E7E700D6E7E700D6E7E700BDC7CE00CEDFE700D6E7
      E700D6E7E700CED7DE00C6CFD600BDC7CE00DEEFEF00CEDFE700BDC7CE00D6E7
      E700DEEFEF00DEEFEF00D6E7E700D6E7E700BDC7CE00DE967B00D6AE9C00D6DF
      DE00DEE7E700DEE7E700EFF7F700FFFFFF00FFFFFF00D6DFDE00B5BEC600ADBE
      BD00D6DFE700BDCFD600CEDFDE00DEEFEF00B5C7CE00BDCFD600D6DFDE00BDCF
      CE00D6E7E700B5C7CE00DEEFEF00CEB6AD000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6B6
      9400FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF000000860000CE79
      7B006B380000C671080000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6B69400FFFFFF00FFFF
      0000FFFFFF00FFFF0000FFFFFF00FFFF000000860000CE797B006B380000C671
      0800D6AE9C00D6E7E700D6E7E700D6E7E700D6E7E700D6E7E700D6E7E700CED7
      DE00C6CFD600BDCFD600BDC7CE00C6CFD600C6CFD600BDC7CE00CEDFE700CEDF
      E700D6E7E700D6E7E700D6E7E700D6E7E700CEDFE700CEA69C00D6AE9C00D6DF
      DE00E7EFEF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D6E7E700CEDFDE00CED7
      DE00CEDFE700C6D7D600CEDFDE00D6E7E700BDCFCE00C6D7D600CEDFDE00BDCF
      CE00D6E7E700BDCFCE00DEEFEF00CEB6AD000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6B6
      9400FFFF0000C6C7C600C6C7C600FFFFFF00FFFF0000FFFFFF00FFFF0000CE79
      7B006B380000C671080000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6B69400FFFF0000C6C7
      C600C6C7C600FFFFFF00FFFF0000FFFFFF00FFFF0000CE797B006B380000C671
      0800BD967B00BDC7CE00BDC7CE00D6E7E700C6CFD600C6C7C600C6CFD600D6E7
      E700C6CFD600C6D7D600BDC7CE00BDC7CE00BDC7CE00CED7DE00CED7DE00DEEF
      EF00C6D7DE00DEEFEF00DEEFEF00DEEFEF00DEEFEF00D6AE9C00D6AE9C00DEE7
      E700F7F7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00D6DFDE00B5C7C600ADBE
      BD00CED7D600CED7D600FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7F700BDCF
      CE00D6E7EF00DEEFEF00DEEFEF00CEB6AD000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6B6
      9400C6C7C600FFFFFF0000FFFF00C6C7C600FFFFFF00FFFF0000FFFFFF00CE79
      7B006B380000C671080000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6B69400C6C7C600FFFF
      FF0000FFFF00C6C7C600FFFFFF00FFFF0000FFFFFF00CE797B006B380000C671
      0800BD967B00C6A69400B58E7B00DEEFEF00BDC7CE00BD968400C6C7C600D6EF
      EF00BDC7CE00BDC7CE00BDC7CE00C6A69400C6A69400C6CFD600C6C7C600DEEF
      EF00BDCFD600DEEFEF00DEEFEF00DEEFEF00DEEFEF00D6AE9C00D6AE9C00CED7
      D600E7EFEF00FFFFFF00FFFFFF00FFFFFF00F7F7F700D6DFE700CEDFDE00CEE7
      E700CED7D600D6DFDE00DEE7E700DEE7E700DEE7E700DEE7E700DEE7E700CED7
      DE00D6E7EF00D6EFEF00D6EFEF00CEB6AD000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6B6
      9400C6C7C60000FFFF00FFFFFF00C6C7C600FFFF0000FFFFFF00FFFF0000CE79
      7B006B380000C671080000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6B69400C6C7C60000FF
      FF00FFFFFF00C6C7C600FFFF0000FFFFFF00FFFF0000CE797B006B380000C671
      0800C6715A00DEAE9400D6AE9C00CEA69400E7BE9C00CEA69400D6AE9C00BD96
      7B00E7BE9C00E7BE9C00E7BE9C00E7BE9C00E7BE9C00E7BE9C00E7BE9C00E7BE
      9C00E7BE9C00E7BE9C00E7BE9C00E7BE9C00E7BE9C00BD967B00C6A69C00B5C7
      CE00BDCFCE00ADBEC600C6D7DE00BDD7D600DEF7FF00D6EFFF00D6EFFF00D6EF
      FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7FF00DEF7
      FF00D6EFFF00DEF7F700D6EFF700DEBEAD000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6B6
      9400FFFFFF00C6C7C600C6C7C600FFFF0000FFFFFF00FFFF0000FFFFFF00CE79
      7B008C510800CE79080000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6B69400FFFFFF00C6C7
      C600C6C7C600FFFF0000FFFFFF00FFFF0000FFFFFF00CE797B008C510800CE79
      0800EF610000EF690800C6715A00EF690800C6715200C6715A00C6715A00C671
      5A00C6715200EF690800EF690800EF690800EF690800F7510000F7510000F751
      0000F7510000F7510000F7510000C6715200C6715A00C6715200CE866300EF96
      5A00D69E8C00EF965A00EF965A00EF965A00EF965A00EF965A00EF965A00EF96
      5A00EF965A00EF965A00EF965A00EF965A00EF965A00EF965A00EF965A00EF96
      5A00EF965A00EF965A00EF965A00C6715A000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CEA6
      8C00CEA68C00CEA68C00CEA68C00CEA68C00CEA68C00CEA68C00CEA68C00CE79
      7B00CE7908000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CEA68C00CEA68C00CEA6
      8C00CEA68C00CEA68C00CEA68C00CEA68C00CEA68C00CE797B00CE7908000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00EF691000EF61
      0800EF610800EF691000EF691000EF691000EF691000EF610800EF610800EF61
      0800EF610800EF610800EF610800EF610800EF610800EF610800EF610800EF61
      0800EF610800EF691000EF965A00C6715A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B57108007B5108006B4108006B4108006B4108007B490800AD69
      0800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C6969400C6969400C6969400C6969400C6969400523010007B49
      0800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF0000000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000D6969400DEDFDE00E7E7E700DED7D600DECFCE00C6AEAD00B58E84005A30
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000848684008486840084868400000000000000000000000000FFFF
      FF00FFFFFF000000000084868400848684008486840084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000D6969400F7F7F700F7F7F700DEDFDE00DEC7C600CEA6A500C69694005A38
      1800000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6C7C600C6C7C600C6C7C600C6C7C6000000
      0000C6C7C600C6C7C600C6C7C600C6C7C6000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000FF000000FF000000FF000000000000000000000000000000
      FF000000FF00000000000000FF000000FF000000FF0000000000000000000000
      FF0000000000C6969400E7C7C600DEC7C600D6969400CE797B00BD8E8C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000FF0000000000000000000000FF000000000000000000000000000000
      FF00000000000000000000000000000000000000FF000000FF000000FF000000
      FF0000000000AD795200D68E8C00D68E8C00D68E8C00C6616300DEC7C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00000000008486840084868400848684008486840084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000000000000000000000000000FF000000FF0000000000000000000000
      FF0000000000000000000000000000000000000000000000FF000000FF000000
      0000F7B65200F7B65200F7B65200F7B65200F7B65200F7B65200F7B65200F7B6
      5200000000000000000000000000000000000000000000000000000000008C51
      0800AD610800AD690800BD710800D6790800E78E080000000000000000000000
      0000000000000000000000000000C6C7C600C6C7C600C6C7C600C6C7C6000000
      0000C6C7C600C6C7C600C6C7C600C6C7C6000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000C6B69400844100008441000084410000844100008441000084410000CE79
      7B00000000000000000000000000000000006B410000633810006B4118006341
      18006B411800633810006B41000094590800CE790800E78E0800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6B69400844100008441000084410000844100008441000084410000CE79
      7B000000000000000000000000006338000084595200C6969400C6969400C696
      9400C6969400C69694008459520063380000A5610800DE860800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008486840084868400848684008486840000000000000000008486
      8400848684008486840084868400848684008486840084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6B69400844100008441000084410000844100008441000084410000CE79
      7B0000000000000000000000000084593900C69E9C00CEBEBD00DECFCE00DEDF
      DE00DECFCE00CEBEBD00C69E9C0084593900A5610800DE860800000000000000
      0000000000000000000000000000C6C7C600C6C7C600C6C7C600C6C7C6000000
      0000C6C7C600C6C7C600C6C7C600C6C7C6000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6B69400844100008441000084410000844100008441000084410000CE79
      7B000000000000000000000000009C694200C68E8C00CE969400D6B6B500DEDF
      DE00D6B6B500CE969400C68E8C009C694200C671080000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FF000000FF000000FF000000FF000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6B69400844100008441000084410000844100008441000084410000CE79
      7B000000000000000000000000007B49080094595200CE696B00D6969400DEC7
      C600D6969400CE696B00945952007B490800BD710800E78E0800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CEA68C00CEA68C00CEA68C00CEA68C00CEA68C00CEA68C00CEA68C00CE79
      7B00000000000000000000000000000000006B382100CE797B00CE868400CE86
      8400CE868400CE797B006B3821005230000084510800CE790800000000000000
      0000000000000000000000000000C6C7C600C6C7C600C6C7C600C6C7C6000000
      0000C6C7C600C6C7C600C6C7C600C6C7C6000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000F7B65200F7B65200F7B65200F7B65200FFB6
      3100FFB63100F7B65200F7B65200CE797B006B380000C6710800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6B69400FF000000FF000000FF000000FF00
      0000FF000000FF00000000860000CE797B006B380000C6710800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6B69400FFFF0000FFFFFF00FFFF0000FFFF
      FF00008600000086000000860000CE797B006B380000C6710800000000000000
      0000000000000000000000000000C6C7C600C6C7C600C6C7C600C6C7C6000000
      0000C6C7C600C6C7C600C6C7C600C6C7C6000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FF00
      0000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6B69400FFFFFF00FFFF0000FFFFFF00FFFF
      0000FFFFFF00FFFF000000860000CE797B006B380000C6710800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FF00
      0000FF000000FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6B69400FFFF0000C6C7C600C6C7C600FFFF
      FF00FFFF0000FFFFFF00FFFF0000CE797B006B380000C6710800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6B69400C6C7C600FFFFFF0000FFFF00C6C7
      C600FFFFFF00FFFF0000FFFFFF00CE797B006B380000C6710800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6B69400C6C7C60000FFFF00FFFFFF00C6C7
      C600FFFF0000FFFFFF00FFFF0000CE797B006B380000C6710800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C6B69400FFFFFF00C6C7C600C6C7C600FFFF
      0000FFFFFF00FFFF0000FFFFFF00CE797B008C510800CE790800000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000CEA68C00CEA68C00CEA68C00CEA68C00CEA6
      8C00CEA68C00CEA68C00CEA68C00CE797B00CE79080000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7
      C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7
      C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600848684008486840084868400848684008486
      840084868400C6C7C60084868400848684008486840084868400848684008486
      8400C6C7C600848684008486840084868400848684008486840084868400C6C7
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084868400848684008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600848684008486840084868400848684008486
      840084868400C6C7C60084868400848684008486840084868400848684008486
      8400C6C7C600848684000000840084868400848684008486840084868400C6C7
      C600000000008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400848684000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008684000000
      00000000000000000000C6C7C600848684008486840084868400848684008486
      840084868400C6C7C60084868400848684008486840084868400848684008486
      8400C6C7C600000084000000840000008400848684008486840084868400C6C7
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000848684000000000000000000000000000000
      0000000084000000840000008400000084000000840000008400000084000000
      8400000084000000840000008400000084000000840000008400000084000000
      8400000084000000000084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600848684008486840084868400000084008486
      840084868400C6C7C60084868400848684008486840084868400848684008486
      840000008400000084000000840000008400000084008486840084868400C6C7
      C600000000000000BD000000BD000000BD000000BD000000BD000000BD000000
      BD000000BD000000BD000000BD000000BD000000BD000000BD000000BD000000
      BD000000BD000000BD000000BD00000000000000000000000000000000000000
      0000C6C7C6008486840000008400000084000000840000008400000084000000
      8400848684008486840084868400C6C7C6000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600848684008486840000008400000084000000
      840084868400C6C7C60084868400848684008486840084868400848684000000
      840000008400000084000000840000008400000084000000840084868400C6C7
      C600000000000000BD000000BD00000000000000000000000000C6C7C600C6C7
      C60084868400848684000000BD000000BD000000BD000000BD000000BD000000
      BD000000BD0084868400C6C7C600000000000000000000000000000000000000
      0000000000000000000000000000848684000000840000008400000084008486
      840084868400C6C7C60000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600848684000000840000008400000084000000
      840000008400C6C7C60084868400848684008486840084868400000084000000
      840000008400000084000000840000008400000084000000840000008400C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      000000000000C6C7C60084868400848684000000BD000000BD000000BD008486
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600000084000000840000008400000084000000
      84000000840000008400C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7
      C600C6C7C600000084000000840000008400C6C7C600C6C7C600C6C7C600C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      0000000000000000000084868400000000000000000000000000848684000000
      000000FFFF008486840000000000000000000000000000000000000000000000
      0000000000000000000000008400000084000000840000008400000084000000
      8400000084000000840000008400848684008486840084868400848684008486
      8400C6C7C600000084000000840000008400848684008486840084868400C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      0000000000000000000084868400848684008486840084868400848684000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600848684008486840000008400000084000000
      840084868400C6C7C60084868400848684008486840084868400848684008486
      8400C6C7C600000084000000840000008400848684008486840084868400C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      0000000000008486840000000000FFFFFF0000000000FFFFFF00000000008486
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600848684008486840000008400000084000000
      840084868400C6C7C60084868400848684008486840000000000000000000000
      0000C6C7C600000084000000840000008400000000000000000000000000C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000008486
      84008486840000000000FFFFFF0000000000FFFFFF0000000000FFFFFF000000
      0000848684008486840000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600848684008486840000008400000084000000
      840084868400C6C7C60084868400848684000000000000000000000000000000
      0000C6C7C600000084000000840000008400000000000000000000000000C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      000084868400FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00848684000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600848684008486840000008400000084000000
      840000000000C6C7C60000000000000000000000000000000000000000000000
      0000C6C7C600000000000000000000000000000000000000000000000000C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      000084868400000000000000FF000000FF000000FF000000FF000000FF000000
      0000848684000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600000000000000000000008400000084000000
      840000000000C6C7C60000000000000000000000000000000000000000000000
      0000C6C7C600000000000000000000000000000000000000000000000000C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      000084868400FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00848684000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600C6C7C600C6C7C60000008400000084000000
      8400C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7
      C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000008486
      84008486840000000000FFFFFF0000000000FFFFFF0000000000FFFFFF000000
      0000848684008486840000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600000000000000000000008400000084000000
      840000000000C6C7C60000000000000000000000000000000000000000000000
      0000C6C7C600000000000000000000000000000000000000000000000000C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      0000000000008486840000000000FFFFFF0000000000FFFFFF00000000008486
      8400000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600000000000000000000008400000084000000
      840000000000C6C7C60000000000000000000000000000000000000000000000
      0000C6C7C600000000000000000000000000000000000000000000000000C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      0000000000000000000084868400848684008486840084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600000000000000000000008400000084000000
      840000000000C6C7C60000000000000000000000000000000000000000000000
      0000C6C7C600000000000000000000000000000000000000000000000000C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000084000000000084868400000000000000000000000000000000000000
      0000000000000000000084868400000000000000000000000000848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600000000000000000000000000000000000000
      000000000000C6C7C60000000000000000000000000000000000000000000000
      0000C6C7C600000000000000000000000000000000000000000000000000C6C7
      C600000000000000BD000000BD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600000000000000000000000000000000000000
      000000000000C6C7C60000000000000000000000000000000000000000000000
      0000C6C7C600000000000000000000000000000000000000000000000000C6C7
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600000000000000000000000000000000000000
      000000000000C6C7C60000000000000000000000000000000000000000000000
      0000C6C7C600000000000000000000000000000000000000000000000000C6C7
      C600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7
      C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7
      C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7C600C6C7
      C600000000000000000000000000F7FFFF00F7FFFF00F7FFFF00000000000000
      0000F7FFFF000000000000000000000000000000000000000000000000000000
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
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF000000
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
      0000000000000000000000000000000000000000000000000000000000008486
      8400848684000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000848684008486840084868400848684000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000848684008486840084868400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000848684008486840084868400848684008486840084868400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000084868400848684008486840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008486840000000000000000000000
      0000848684000000000000FFFF00848684000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF00000000000000000000000000000000000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008486840084868400848684008486
      840084868400000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000000000000000000000000000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084868400FFFFFF0000000000FFFFFF000000
      0000FFFFFF008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FF
      FF00000000008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008486840084868400FFFFFF0000000000FFFFFF000000FF00FFFF
      FF0000000000FFFFFF0084868400848684000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008486840000000000FFFFFF00000000000000FF000000
      0000FFFFFF000000000084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084868400FFFFFF000000FF000000FF000000FF000000
      FF000000FF00FFFFFF0084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF0000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000008486840000000000FFFFFF00000000000000FF000000
      0000FFFFFF000000000084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008486840084868400FFFFFF0000000000FFFFFF000000FF00FFFF
      FF0000000000FFFFFF0084868400848684000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000084868400FFFFFF0000000000FFFFFF000000
      0000FFFFFF008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008486840084868400848684008486
      8400848684000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008486840000000000000000000000
      0000848684000000000000000000000000000000000000000000000000000000
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
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF0000000000
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
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF00000000000000FF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000FF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000FF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
      0000000000000000FF0000000000000000000000FF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF0000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000FF0000000000000000000000FF0000000000000000000000
      0000000000000000FF000000FF000000FF00000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF00000000000000FF0000000000000000000000FF00000000000000
      0000000000000000FF0000000000000000000000FF0000000000000000000000
      00000000FF0000000000000000000000FF00000000000000000000000000FFFF
      FF00000000008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF0000000000000000000000FF00000000000000
      0000000000000000FF0000000000000000000000FF0000000000000000000000
      FF000000FF00000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      00000000FF000000000000000000000000000000FF000000FF00000000000000
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000FF00000000000000000000000000000000000000FF000000FF000000
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400848684008486840084868400848684000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000FF00000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00848684008486
      84008486840084868400FFFFFF0084868400848684008486840084868400FFFF
      FF0084868400848684008486840084868400FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF00000000000000000000000000000000000000FF000000FF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
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
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000FF000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000058000000840000000100010000000000300600000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FC0FFE03EFF00000
      00000000E007FC01CFF0000000000000C0001C018070000000000000C007DC01
      CF70000000000000C00FDC00EF70000000000000C007DE00FF70000000000000
      E0060400FF70000000000000C0000000C030000000000000C000000080100000
      00000000C00000008010000000000000C00004008010000000000000C0000000
      8000000000000000C0000000C000000000000000C00000008000000000000000
      C00000008000000000000000C00803FF8000000000000000FFE003FF80000000
      00000000FFE003FF8000000000000000FFE003FF8000000000000000FFE003FF
      8000000000000000FFE003FF8000000000000000FFE007FF8010000000000000
      FFFFFFFFFFF80FFFFFFFFF00C0000FFFFFF80FFFFC007F00C0000FFFF3F00FFF
      FC007F00C0000FFEF1F00FFFFC007F00C0000C38E4681FFFFC007F00C0000FD6
      EF081FFFFC007F00C0000FEE6F900FE07C007F00C0000FFF6FF00F003C007F00
      C0000FFF5FF00E003C007F00C0000FFF5FF00E003C007F00C0000FFF5FF00E00
      7C007F00C0000FFF5FF00E003C007F00C0000FFF5FF00F003C007F00C0000FFF
      5FFFFE003C007F00C0000FFF5FFFFE003C007F00C0000FFF5FFFFE003C007F00
      C0000FFF5FFFFE003C007F00C0000FFF1FFFFE003C007F00C0000FFFBFFFFE00
      3C007F00C0000FFFBFFFFE003C007F00C0000FFFFFFFFE003C007F00FFFFFFFF
      FFFFFE007C007F00FFFFFC00000FFFFFFFFFFF00FFFFFC00000FFFFFFC000100
      FFFFFC0000080000F8000100FFFF9C0000000000E0000100FFFF1C0000000000
      E000F100FFFE3C000001C000EE03F100FFFC7C000001F80EEFFFF100FFF8FC00
      0001FFFEEFFFF100FC11FC000001FFFEEFFFF100F803FC000001FFFEEFFFF100
      F2A7FC0070E1FFFEEFFFF100E553FC00F0E1FFFEEFFFF100E2A3FC0BF7E1FFFE
      EFFFF100E413FD8BF7E1FFFEEFFFF100E2A3FC000001FFFEEFFFF100E553FD8B
      F7E1FFFEEFFFF100F2A7FD8BF7E1FFFEEFFFF100F80FFD8BF7E1FFFEEFFFF100
      FC1FFDFBF7E1FFFEE7FF8700FFFFFDFBF7EC3FFDFBF87F00FFFFFDFBF7EFC3FB
      FC07FF00FFFFFC00000E3407FFFFFF00FFF80FFFFFFF8FFFFFFFFF00007BEFFF
      FFFFF7FFFFFFFF007F7BEFFF1FFFFBFFFFFFFF007F7BEFFE0FFFFBFFFFFFEF00
      7F7BEFFF07FFE7FFFFFFC7007F7BEFFE00FFF7FFFFFF8F007F7BEFFE0E3FFBFF
      FFFF1F007F7BEFFE003FC3FFFFFE3F007F7BEFF3047FFBFFFF047F007F7BEFE1
      C3FFFBFFFE00FF007F7BEFE001FFE3FFFC51FF00007BEFF001FFEDFFF888FF00
      007BEFF001FFEDFFF954FF00007BEFF801FFFBFFF800FF00FFFBEFFC03FF3BFF
      F954FF00001BEFFF07FEB7FFF888FF007FDBEFFFFFFF0FFFFC51FF007FDBEFFF
      FFFCEFFFFE03FF007FDBEFFFFFFF0FFFFF07FF0000180FFFFFFFEFFFFFFFFF00
      00180FFFFFFFEFFFFFFFFF0000180FFFFFFFEFFFFFFFFF00FFFFFFFFFFFFFFFF
      FFFFFF00C0000F00003FFFFFFFFFFF00C0000F00003FFC00FFFFFF00C0000F00
      003FF1FEFFFFFF00C0000F00003FC50EFFFEFF00C0000F00003F15FEFFFCFF00
      C0000F00003F5502FFFAFF00C0000F00003F55FEFFFB7F00C0000F00003F5502
      FFFB7F00C0000F00003F55FEFE7B7F00C0000F00003F551EC0000000C0000F00
      003F55F0E5BB7600C0000F00003F5535F1BB6700C0000F00003F55F3FF972F00
      C0000F00003F5407FFD78F00C0000F00003F501FFFD79F00C0000F00003F407F
      FFE79F00C0000F00003F01FFFFFFFF00C0000F00003FFFFFFFFFFF00C0000F00
      003FFFFFFFFFFF00C0000F00003FFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFF00
      00000000000000000000000000000000000000000000}
  end
  object Mag4Menu1: TMag4Menu
    MaxInsert = 0
    ExitItem = False
    Left = 88
    Top = 120
  end
  object ApplicationEvents1: TApplicationEvents
    OnHelp = ApplicationEvents1Help
    Left = 453
    Top = 125
  end
  object imglstMainMenu: TImageList
    Left = 259
    Top = 125
    Bitmap = {
      494C010115001700040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000006000000001002000000000000060
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
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000848684008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000008486840084868400848684000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000848684008486
      8400848684008486840084868400848684000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
      0000848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000008486
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEEFF700BDBEBD007B797B007B79
      7B007B797B007B797B008486840073717B0042414A0042414A0052515A008486
      84007B797B007B797B008C8E8C00E7EFF700FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00000000000000FF00000084000000
      84008486840000000000000000000000000000000000000000000000FF008486
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      000000000000000000000000000000000000BDBEBD0039383900212021002120
      21002120210021201800525152007B797300525131005A5931005A5952007371
      7B00292829002120210021181800848E8C00FFFFFF00FFFFFF00000000000000
      0000DEE7E700B5AEA500A5968400A5968C00A5968400948673008C796B00A596
      8C00D6D7CE00FFFFFF0000000000FFFFFF00000000000000FF00000084000000
      840000008400848684000000000000000000000000000000FF00000084000000
      8400848684000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000FF000000FF000000FF000000
      FF00000000000000000000000000000000002928290010101000424142004241
      420039383900525152007B797B00525100007B790000A5A60000848600005251
      390084868400313031005A595A0021202100FFFFFF0000000000FFFFFF00CEC7
      C600A58E7B00A5866300BD9E7300C6A68400D6AE8C00CEA68400AD8663008459
      39006B4131009C968C00EFF7F70000000000000000000000FF00000084000000
      8400000084000000840084868400000000000000FF0000008400000084000000
      8400000084008486840000000000000000000000FF00000000000000FF000000
      FF000000FF0000000000000000000000000084868400000000000000FF000000
      FF000000FF000000000000000000000000001010100021202100424142003938
      39000808080052515A005251210084860000848600008C8E0000D6D700006361
      00005A595A00313031005251520029282900FFFFFF0000000000D6CFC600B59E
      8400D6B69400EFD7B500E7BE9C00EFB68C00F7C79400EFBE9400EFCFA500E7C7
      9C00B58E6B006B412900948E8400F7FFFF0000000000000000000000FF000000
      8400000084000000840000008400848684000000840000008400000084000000
      8400000084008486840000000000000000000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000001010100021202100424142002928
      2900000000005251630052511800848600007371000094960800F7F784007B79
      00005251520039383900525152002928290000000000E7E7E700C6AE9400DEC7
      AD00FFE7C600FFEFCE00DEBEA500A5412100A5381000C68E6300FFE7BD00FFDF
      BD00EFCFAD00BD9E73006B412900BDB6B5000000000000000000000000000000
      FF00000084000000840000008400000084000000840000008400000084000000
      8400848684000000000000000000000000000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000001010100021202100424142002928
      2900000000005A596300525131007B79000094960800DEDF6300E7E74A005251
      000063616B00313031005251520029282900FFFFFF00D6C7BD00DEC7AD00FFE7
      CE00FFEFCE00FFE7CE00FFF7D6009C51310084180000DEC7A500FFF7D600FFE7
      C600FFDFBD00EFD7B5009C715A0084716B000000000000000000000000000000
      00000000FF000000840000008400000084000000840000008400000084008486
      8400000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000001010100021202100424142002120
      2100101010004A494A0084868C00424110008C8E0000A5A62900636100006361
      5A007B797B00313031005251520029282900FFF7F700D6C7B500F7DFCE00FFEF
      DE00FFEFD600FFEFD600FFEFD600A55939008C200000E7C7AD00FFF7D600FFE7
      C600FFE7CE00FFE7C600CEAE94008C695A000000000000000000000000000000
      0000000000000000840000008400000084000000840000008400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000001818180018181800313031002928
      2900292829005A595A00C6C7C600BDBEBD0052514A005A5952006B696B006B69
      730031303100313031004A494A0029282900FFF7F700D6CFBD00FFEFDE00FFF7
      DE00FFEFDE00FFEFDE00FFFFEF00A55939008C180000E7C7AD00FFF7DE00FFE7
      CE00FFEFCE00FFEFD600DEC7AD008C7163000000000000000000000000000000
      0000000000000000FF0000008400000084000000840000008400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000808080021202100393839004241
      4200424142005A595A00ADAEAD00FFFFFF00FFFFFF00D6D7D60063616B003938
      390039383900393839005251520021202100FFF7F700DED7C600FFEFE700FFF7
      E700FFF7E700FFF7EF00DECFB5008C3010007B100000DEC7AD00FFFFEF00FFEF
      D600FFEFD600FFEFDE00E7CFB500948673000000000000000000000000000000
      00000000FF000000840000008400000084000000840000008400848684000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000101010008C8E8C00C6C7C600C6C7
      C600CECFCE009C9E9C006B696B005A595A005A595A005A595A008C8E8C00C6C7
      C600C6C7C600C6C7C600EFEFEF0052515200FFFFFF00DED7D600F7F7EF00FFFF
      F700FFF7EF00FFFFEF00C6AE9400AD796B00A5796B00E7D7CE00FFFFEF00FFEF
      DE00FFF7E700FFFFEF00DEC7B500ADA69C000000000000000000000000000000
      FF00000084000000840000008400848684000000840000008400000084008486
      8400000000000000000000000000000000000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF000000000021202100C6C7C600CECFCE00CECF
      CE00E7E7E700EFEFEF00DEDFDE00C6C7C600C6C7C600D6D7D600F7F7F700E7E7
      E700CECFCE00DEDFDE00CECFC60073717300FFFFFF00E7E7E700EFE7E700FFFF
      FF00FFFFF700FFFFF700FFFFFF00EFDFCE00F7DFC600FFFFEF00FFF7EF00FFF7
      E700FFFFF700FFF7E700C6BEAD00DEDFDE0000000000000000000000FF000000
      8400000084000000840084868400000000000000FF0000008400000084000000
      840084868400000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF000000000052595A007B797B007B797B005A59
      5A00636163004A494A009C9E9C00ADAEAD00BDBEBD006B696B006B696B006B69
      6B0063595A004A4142007B868400D6E7EF0000000000FFFFFF00E7E7E700F7EF
      EF00FFFFFF00FFFFFF00EFEFEF008430180094280000E7D7C600FFFFFF00FFFF
      FF00FFFFF700E7DFCE00D6D7D600FFFFFF0000000000000000000000FF000000
      840000008400848684000000000000000000000000000000FF00000084000000
      840000008400848684000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF0000000000CEE7E7008C969C0073717300848E
      8C00849694001818180084868400EFEFEF00A5A6A50073797B00A5AEAD006B69
      73005A595A00949E9C00CEDFE700DEF7F700FFFFFF0000000000F7F7F700EFEF
      E700F7F7F700FFFFFF00FFFFFF009C7973008C615A00F7EFEF0000000000FFF7
      F700EFE7DE00EFE7E700FFFFFF00000000000000000000000000000000000000
      FF000000840000000000000000000000000000000000000000000000FF000000
      84000000840000008400000000000000000000000000000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF0000000000DEEFF700E7F7FF00CEE7E700D6EF
      EF00EFFFFF00ADBEBD00393839005A595A007B868400DEEFF700EFFFFF00E7F7
      F700D6E7EF00E7F7FF00DEEFF700D6EFEF00FFFFFF00FFFFFF0000000000FFFF
      FF00EFEFEF00E7EFEF00F7F7F700FFFFFF00FFFFFF00FFFFF700EFEFEF00E7E7
      E700F7F7F7000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000084000000FF0000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000FF000000FF000000FF000000
      FF0000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEEFF700BDBEBD007B797B007B79
      7B007B797B007B797B008486840073717B0042414A0042414A0052515A008486
      84007B797B007B797B008C8E8C00E7EFF70000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBEBD0039383900212021002120
      21002120210021201800525152007B797300525131005A5931005A5952007371
      7B00292829002120210021181800848E8C0000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000002928290010101000424142004241
      420039383900525152007B797B00525100007B790000A5A60000848600005251
      390084868400313031005A595A002120210000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000001010100021202100424142003938
      39000808080052515A005251210084860000848600008C8E0000D6D700006361
      00005A595A0031303100525152002928290000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000001010100021202100424142002928
      2900000000005251630052511800848600007371000094960800F7F784007B79
      00005251520039383900525152002928290000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF008486
      8400FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0084868400FFFFFF00FFFFFF00000000001010100021202100424142002928
      2900000000005A596300525131007B79000094960800DEDF6300E7E74A005251
      000063616B0031303100525152002928290000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF0084868400FFFFFF00FFFFFF0084868400FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00848684008486
      8400FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF008486840084868400FFFFFF0000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000008C8E0000A5A62900636100006361
      5A007B797B0031303100525152002928290000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF008486840084868400FFFFFF00FFFFFF008486840084868400FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000084868400848684008486
      8400848684000000000084868400848684008486840084868400000000008486
      840084868400848684008486840000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF00000052514A005A5952006B696B006B69
      730031303100313031004A494A002928290000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF00000000008486
      8400848684008486840084868400848684008486840084868400848684000000
      0000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00848684008486
      8400FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF008486840084868400FFFFFF0000000000FF000000FF000000393839004241
      4200424142005A595A00FF000000FF000000FFFFFF00D6D7D60063616B003938
      39003938390039383900525152002120210000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF008486840084868400FFFFFF00FFFFFF008486840084868400FFFFFF000000
      0000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF008486
      8400FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF0084868400FFFFFF00FFFFFF0000000000FF000000FF000000C6C7C600C6C7
      C600CECFCE009C9E9C00FF000000FF0000005A595A005A595A008C8E8C00C6C7
      C600C6C7C600C6C7C600EFEFEF005251520000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF0084868400FFFFFF00FFFFFF0084868400FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FF000000FF000000CECFCE00CECF
      CE00E7E7E700EFEFEF00FF000000FF000000C6C7C600D6D7D600F7F7F700E7E7
      E700CECFCE00DEDFDE00CECFC6007371730000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FF000000FF0000007B797B005A59
      5A00636163004A494A00FF000000FF000000BDBEBD006B696B006B696B006B69
      6B0063595A004A4142007B868400D6E7EF0000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000A5A6A50073797B00A5AEAD006B69
      73005A595A00949E9C00CEDFE700DEF7F70000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000007B868400DEEFF700EFFFFF00E7F7
      F700D6E7EF00E7F7FF00DEEFF700D6EFEF0000000000FFFFFF00000000008486
      840000000000FFFFFF00FFFFFF00000000008486840000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000181000007B4918007B4931007349
      31007B492900633808000000000000000000000000000000C600000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00DEEFEF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DEEFEF00FFFFFF00FFFFFF0084513100C6A6A500DEC7C600DEC7
      C600D6BEC600AD867B0000000000000000000000D6000000FF000000AD000000
      A5000000AD008400FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DEEFF700BDBEBD007B797B007B79
      7B007B797B007B797B008486840073717B0042414A0042414A0052515A008486
      84007B797B007B797B008C8E8C00E7EFF700FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00A5715200CE969C00DEB6B500E7DF
      DE00D6A6A500C6968C005230180000000000000000000000FF00000000000000
      0000000000000000F70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000BDBEBD0039383900212021002120
      21002120210021201800525152007B797300525131005A5931005A5952007371
      7B00292829002120210021181800848E8C00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF0042200000AD515A00CE8E9400CEA6
      AD00D6718400733829009C590000000000000000000000000000000000000000
      0000000000000000E70000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000002928290010101000424142004241
      420039383900525152007B797B00525100007B790000A5A60000848600005251
      390084868400313031005A595A0021202100FFFFFF0000000000FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00A5793100DEA65A00EFB66B00F7AE
      4A00F7B66300DE8E4A008C513100000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001010100021202100424142003938
      39000808080052515A005251210084860000848600008C8E0000D6D700006361
      00005A595A00313031005251520029282900FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00DE9E7300FF100000FF180800F710
      1000E700000021861000BD615200000000001810000073491000734921007349
      290073412100734108005A300000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001010100021202100424142002928
      2900000000005251630052511800848600007371000094960800F7F784007B79
      000052515200393839005251520029282900FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00D6CF8C00FFFF7300FFFF8400C6FF
      730052C7080000790800BD615200000000008C593100BD9EA500DEBEC600D6BE
      C600D6BEC6009C716B0094590800211000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000001010100021202100424142002928
      2900000000005A596300525131007B79000094960800DEDF6300E7E74A005251
      000063616B00313031005251520029282900FFFFFF0000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000FFFFFF00FFFFFF00D6C77300EFE76300DEC7AD00FFFF
      A500FFFF6B00CEDF0000AD59520000000000B5866300CEA6A500DEBEBD00E7DF
      DE00D6AEAD00C6969400BD7121001008000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000001010100021202100424142002120
      2100101010004A494A0084868C00424110008C8E0000A5A62900636100006361
      5A007B797B00313031005251520029282900FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00C6B69C00ADE7F70021FFFF00DEC7
      AD00FFFF8400FFF78400A5514200000000005A300000AD515A00CE8E9400D6AE
      B500D6717B007B41310084490000EF8E080000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000001818180018181800313031002928
      2900292829005A595A00C6C7C600BDBEBD0052514A005A5952006B696B006B69
      730031303100313031004A494A0029282900FFFFFF0000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000FFFFFF00FFFFFF00D6C7A50094EFF700C6DFDE00FFFF
      6B00FFFF5A00FFFFBD00AD5942000000000094693100D69E5A00E7AE7300EFAE
      5200EFAE6B00C679420073412900B569000000000000FF000000FF0000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000808080021202100393839004241
      4200424142005A595A00ADAEAD00FFFFFF00FFFFFF00D6D7D60063616B003938
      390039383900393839005251520021202100FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00D6AE8C00DEAE9400CEA68C00DEB6
      7B00D6B68400D6AE9C00DE79420000000000F7AE8400FF080000FF100000FF10
      0000FF000000398E1800AD595200AD61000000000000FF000000FF0000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      000000000000000000000000000000000000101010008C8E8C00C6C7C600C6C7
      C600CECFCE009C9E9C006B696B005A595A005A595A005A595A008C8E8C00C6C7
      C600C6C7C600C6C7C600EFEFEF0052515200FFFFFF0000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000EFE79400FFFF6B00FFFF8C00BDF7
      840029B6000000790800AD595200AD61000000000000FF000000FF0000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      00000000000000000000000000000000000021202100C6C7C600CECFCE00CECF
      CE00E7E7E700EFEFEF00DEDFDE00C6C7C600C6C7C600D6D7D600F7F7F700E7E7
      E700CECFCE00DEDFDE00CECFC60073717300FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000F7DF8C00F7EF7300E7C7A500FFFF
      9400FFFF6B00B5CF00009C515200AD61000000000000FF000000FF0000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      00000000000000000000000000000000000052595A007B797B007B797B005A59
      5A00636163004A494A009C9E9C00ADAEAD00BDBEBD006B696B006B696B006B69
      6B0063595A004A4142007B868400D6E7EF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000DECFAD00C6DFE70021FFFF00E7CF
      AD00FFFF8400FFF7730094494200AD61000000000000FF000000FF0000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      000000000000000000000000000000000000CEE7E7008C969C0073717300848E
      8C00849694001818180084868400EFEFEF00A5A6A50073797B00A5AEAD006B69
      73005A595A00949E9C00CEDFE700DEF7F700FFFFFF0000000000FFFFFF00FFFF
      FF00000000000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000EFD7BD007BEFF700C6E7E700EFEF
      7300FFFF5A00FFFFAD0094494200BD71000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      000000000000000000000000000000000000DEEFF700E7F7FF00CEE7E700D6EF
      EF00EFFFFF00ADBEBD00393839005A595A007B868400DEEFF700EFFFFF00E7F7
      F700D6E7EF00E7F7FF00DEEFF700D6EFEF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000EFC7A500DEB69C00CEA68C00DEBE
      7300DEB67B00D6B69C00D67142004228000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000000000B57108007B5108006B41
      08006B4108006B4108007B490800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00848684008486
      840084868400FFFFFF00848684008486840084868400FFFFFF00848684008486
      840084868400FFFFFF0000000000FFFFFF0000000000C6969400C6969400C696
      9400C6969400C69694005230100000000000000000005A3000008C510800AD61
      0800AD690800BD710800D6790800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000008486
      8400848684008486840084868400848684008486840084868400848684008486
      84008486840084868400848684000000000000000000FFFFFF00848684008486
      840084868400FFFFFF00848684008486840084868400FFFFFF00848684008486
      840084868400FFFFFF0000000000FFFFFF00D6969400DEDFDE00E7E7E700DED7
      D600DECFCE00C6AEAD00B58E840000000000000000005A381800634118006B41
      1800633810006B41000094590800CE7908000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00848684008486
      840084868400FFFFFF00848684008486840084868400FFFFFF00848684008486
      840084868400FFFFFF0000000000FFFFFF00D6969400F7F7F700F7F7F700DEDF
      DE00DEC7C600CEA6A5000000000000000000CE868400C6969400C6969400C696
      9400C69694008459520063380000A56108000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000008486
      8400848684008486840084868400848684008486840084868400848684008486
      84008486840084868400848684000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF0000000000C6969400E7C7C600DEC7
      C600D6969400CE797B000000000000000000CE868400E7E7E700DEDFDE00DECF
      CE00CEBEBD00C69E9C0084593900A56108000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00848684008486
      840084868400FFFFFF00848684008486840084868400FFFFFF00848684008486
      840084868400FFFFFF0000000000FFFFFF0000000000AD795200D68E8C00D68E
      8C00D68E8C00C66163000000000000000000CE868400CE868400DEDFDE00D6B6
      B500CE969400C68E8C009C694200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00848684008486
      840084868400FFFFFF00848684008486840084868400FFFFFF00848684008486
      840084868400FFFFFF0000000000FFFFFF00C6B69400F7B65200F7B65200F7B6
      5200F7B65200F7B65200CE797B000000000000000000CE868400DEC7C600D696
      9400CE696B00945952007B490800BD7108000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000008486
      8400848684008486840084868400848684008486840084868400848684008486
      84008486840084868400848684000000000000000000FFFFFF00848684008486
      840084868400FFFFFF00848684008486840084868400FFFFFF00848684008486
      840084868400FFFFFF0000000000FFFFFF00C6B6940084868400848684008486
      84008486840084868400CE797B000000000000000000CE868400CE868400CE86
      8400CE797B006B38210052300000845108000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00C6B6940084868400848684008486
      84008486840084868400CE797B00FFB63100FFB63100FFB63100FFB63100FFB6
      3100F7B65200F7B65200CE797B006B3800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00848684008486
      840084868400FFFFFF00848684008486840084868400FFFFFF00848684008486
      840084868400FFFFFF0000000000FFFFFF00C6B6940084868400848684008486
      84008486840084868400CE797B00FF000000FF000000FF000000FF000000FF00
      0000FF00000000860000CE797B006B3800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000008486
      8400848684008486840084868400848684008486840084868400848684008486
      84008486840084868400848684000000000000000000FFFFFF00848684008486
      840084868400FFFFFF00848684008486840084868400FFFFFF00848684008486
      840084868400FFFFFF0000000000FFFFFF00C6B6940084868400848684008486
      84008486840084868400CE797B00FFFF0000FFFFFF00FFFF0000FFFFFF000086
      00000086000000860000CE797B006B3800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00848684008486
      840084868400FFFFFF00848684008486840084868400FFFFFF00848684008486
      840084868400FFFFFF0000000000FFFFFF00CEBEBD00CEBEBD00CEBEBD00CEBE
      BD00CEA68C00CEA68C00CE797B00FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF00FFFF000000860000CE797B006B3800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      00000000000000000000C6B69400FFFF0000C6C7C600C6C7C600FFFFFF00FFFF
      0000FFFFFF00FFFF0000CE797B006B3800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      00000000000000000000C6B69400C6C7C600FFFFFF0000FFFF00C6C7C600FFFF
      FF00FFFF0000FFFFFF00CE797B006B3800000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000FF0000000000000000000000FF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000FF0000000000FFFFFF000000000000000000000000000000
      00000000000000000000C6B69400C6C7C60000FFFF00FFFFFF00C6C7C600FFFF
      0000FFFFFF00FFFF0000CE797B008C5108000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000000000000000
      00000000000000000000CEBEBD00CEBEBD00CEBEBD00CEBEBD00CEBEBD00CEA6
      8C00CEA68C00CEA68C00CE797B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF00000000000000000000000000000000000000FF000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000FF000000000000000000000000000000FF000000FF000000
      FF000000FF0000000000000000000000FF0000000000FFFFFF00000000008486
      84008486840084868400000000000000000000000000FFFFFF00FFFFFF000000
      0000848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000FF000000FF000000000000000000000000000000FF00000000000000
      00000000FF000000FF000000FF000000FF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000FF000000FF000000FF0000000000000000000000FF00000000000000
      0000000000000000FF000000FF000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000FF00000000000000FF0000000000000000000000FF00000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000008486
      8400848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000008486
      8400848684008486840084868400000000000000000084868400848684008486
      8400848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF00
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF00
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000600000000100010000000000000300000000000000000000
      000000000000000000000000FFFFFF00FFFF000000000000FC7F000000000000
      F83F000000000000FC1F000000000000F803000000000000F838000000000000
      F800000000000000CC11000000000000870F0000000000008007000000000000
      C007000000000000C007000000000000E007000000000000F00F000000000000
      FC1F000000000000FFFF000000000000FFFFFFFFFFFFFFFF00001C3C87CFF83F
      000030028387E10F000040018103474700004000C0030FE300008000E0071FF3
      00000000F00F0FF900000000F81FFFF900000000F81FFFFF00000000F01F3FFF
      00000000E00F3FC100000000C1079FE100008000C3838FF100004021E7C3C7C1
      00002006FFE3E10DFFFF1008FFFFF83FFFFFFFFF0000FFFFFFFF00000000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FFFF00000000FFFFFFFFFFFF0000FFFF03BFC007FFFF00000303BFFB00000000
      01BBBFFB0000000001FBB01B0000000001FBBFFB000000000101BFFB00000000
      0100B00B000000000100807B000000000100800B0000000001009E7B00000000
      0100903B00000000FF009E4300000000FF009E3300000000FF00903700000000
      FF00804F00000000FF00801FFFFF0000FCFF0000000081FFFF7F000000008181
      FFBF000000000180FE7F000000000300FF7F000000008300FFBF000000008301
      FC3F000000000180FFBF000000000180FE3F000000000000FEDF000000000000
      FEDF000000000000FBBF000000000000F77F00000000FC00F8FF00000000FC00
      E6FF00000000FC00F8FF00000000FC01FFFF0000FC000070FBDF0000F1FE7F76
      0B860000C50E7F76D3B0000015FE7F76D1B9000055027F76D5BF000055FE0076
      DD7F000055020076FD7F000055FE0076FD7F0000551EFFF6FD7F000055F00016
      FD7F000055357FD6FD7F000055F37FD6FC7F000054077FD6FEFF0000501F0010
      FEFF0000407F0010FFFF000001FF001000000000000000000000000000000000
      000000000000}
  end
  object imglstImageFunctions: TImageList
    Left = 304
    Top = 122
    Bitmap = {
      494C01012F003100040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000C0000000010020000000000000C0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000084000000
      84008486840000000000000000000000000000000000000000000000FF008486
      84000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000084000000
      840000008400848684000000000000000000000000000000FF00000084000000
      84008486840000000000000000000000000000000000FFFFFF00000000008486
      84008486840084868400000000000000000000000000FFFFFF00FFFFFF000000
      0000848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF00000084000000
      8400000084000000840084868400000000000000FF0000008400000084000000
      84000000840084868400000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      8400000084000000840000008400848684000000840000008400000084000000
      84000000840084868400000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000084000000840000008400000084000000840000008400000084000000
      84008486840000000000000000000000000000000000FFFFFF0000000000FFFF
      FF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00000000008486
      8400848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000840000008400000084000000840000008400000084008486
      84000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000006B59
      5A006B595A005A494A006B615A005A494A006B615A006359520052695A005A59
      4A00426952000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000840000008400000084000000840000008400848684000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000E7000800C6C7
      C600DEE7DE00D6D7D600B5B6B500EFEFEF00CECFCE00DEDFD600D6D7D600B5B6
      B500FF0000004A51390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000008400000084000000840000008400848684000000
      00000000000000000000000000000000000000000000FFFFFF00000000008486
      8400848684008486840084868400000000000000000084868400848684008486
      84008486840084868400848684000000000000000000F7000000EF000000CED7
      D600CECFD600CECFD600DEE7E700BDC7C600D6D7D600E7C7C600CECFD600DEE7
      E700FF000000FF0008004A595200000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000840000008400000084000000840000008400848684000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FF000000FF000000FF000000000000005A595200FF000800F7100800E7E7
      E700E7E7E700D6DFDE00DEDFDE00DEDFDE00DEE7E700FFE7E700D6DFDE00DEDF
      DE00FF080000E70000004A695A00F7EFF7000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000084000000840000008400848684000000840000008400000084008486
      84000000000000000000000000000000000000000000FFFFFF00000000008486
      8400848684008486840084868400848684008486840084868400848684008486
      840084868400848684008486840000000000E7000000FF100800E7000000FFFF
      FF00EFEFEF00EFEFEF00E7E7E700F7F7F700EFEFEF00EFDFD600EFEFEF00E7E7
      E700FF000000FF101000FF000000295939000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      8400000084000000840084868400000000000000FF0000008400000084000000
      84008486840000000000000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF00
      0000FFFFFF00FFFFFF00FFFFFF0000000000FF100000F7000000FF080000EFEF
      EF00EFF7F700F7FFFF00FFFFFF00E7EFEF00EFF7F700FFFFF700F7FFFF00FFFF
      FF00FF000800EF000000EF0000007B6952000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      840000008400848684000000000000000000000000000000FF00000084000000
      84000000840084868400000000000000000000000000FFFFFF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FF000000FF000000FF000000FF000000FF00
      0000FFFFFF00FFFFFF00FFFFFF00000000006B615200FF000800EF000000EFFF
      FF00E7FFFF00EFFFFF00EFFFFF00EFFFFF00EFFFFF00FFFFF700EFFFFF00EFFF
      FF00E7100000FF0008006B514A00DEB6BD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000840000000000000000000000000000000000000000000000FF000000
      84000000840000008400000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CE000000F7000000FFF7
      F700FFFFFF00FFFFF700FFFFFF00FFFFF700FFFFFF00E7FFF700FFFFF700FFFF
      FF00EF000000E700080052695A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000084000000FF000000000000000000000000000000FF0000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000FF00000000000000000000000000F7081000FFFF
      FF00FFFFFF00FFFFFF00FFFFF700FFFFFF00FFFFFF00ADF7E700FFFFFF00FFFF
      F700FF0010006B594A0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B51
      520073494A0073494A007B515200734952007B515200946163007B4142007351
      4200525142000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000086840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000086840000FFFF0000868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000086840000FFFF0000868400000000000000000000000000000000000000
      000000000000C6CFB5004AAECE00A5B6AD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00000000000000
      0000DEE7E700B5AEA500A5968400A5968C00A5968400948673008C796B00A596
      8C00D6D7CE00FFFFFF0000000000FFFFFF0000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000086
      840000FFFF00008684000000000000000000000000004AAECE007BBEC6000000
      00000000000094D7D6000061940073B6AD000000000000000000848E8C00848E
      8C00000000000000000000081000000000000000000000000000000000000000
      000000000000C6C7C6006396A500BDBEB5000000000000000000000000000000
      000000000000000000001008100000000000FFFFFF0000000000FFFFFF00CEC7
      C600A58E7B00A5866300BD9E7300C6A68400D6AE8C00CEA68400AD8663008459
      39006B4131009C968C00EFF7F700000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000086840000000000000000000086
      840000FFFF0000868400000000000000000000000000A5DFD600009ED60029BE
      DE000000000084D7D6000059940073BEBD00000000004296A500003873009496
      940000000000000000000008100000000000000000000000000073AEC600D6DF
      CE0000000000CECFC6006396A500BDC7BD0000000000B5B6B500638694000000
      000000000000100810001008100010081000FFFFFF0000000000D6CFC600B59E
      8400D6B69400EFD7B500E7BE9C00EFB68C00F7C79400EFBE9400EFCFA500E7C7
      9C00B58E6B006B412900948E8400F7FFFF00000000000000000000000000FFFF
      FF000000000000000000000000000000000000868400008684000000000000FF
      FF000086840000000000000000000000000000000000000000008CE7EF00008E
      C60018DFF7000079C6000071B5000061A50039BEBD00004984004296A5000000
      0000000000000000000000081000000000000000000000000000E7DFCE0084BE
      D60094CFDE00428694004279940042718400A5BEBD00638EA500B5BEB5000000
      00000000000000000000100810000000000000000000E7E7E700C6AE9400DEC7
      AD00FFE7C600FFEFCE00DEBEA500A5412100A5381000C68E6300FFE7BD00FFDF
      BD00EFCFAD00BD9E73006B412900BDB6B500000000000000000000000000FFFF
      FF00000000000000000000000000000000000086840000FFFF00008684000000
      0000000000000000000000000000000000000000000000000000000000004AF7
      EF00008EC60000DFFF0000CFF70000BEE7000061A50039BEBD00000000000000
      00000000000000000000100810000000000000000000000000000000000094D7
      DE004296A50073BED60063B6C60063A6B50042718400A5C7BD00000000000000
      000000000000000000001008100000000000FFFFFF00D6C7BD00DEC7AD00FFE7
      CE00FFEFCE00FFE7CE00FFF7D6009C51310084180000DEC7A500FFF7D600FFE7
      C600FFDFBD00EFD7B5009C715A0084716B000000000000000000848684008486
      8400848684000000000000000000000000000086840000FFFF0000FFFF000086
      84000086840000868400008684000000000000000000CEEFDE0094F7F70000A6
      E70084FFFF0094FFFF0073F7FF0021DFF70000BEE7000061A5006BBEC6008CCF
      CE00D6EFDE0000000000100810000000000000000000D6E7DE00D6E7DE004296
      B500B5E7E700B5EFF700A5D7E70073BEC60063A6B50042718400B5C7C600B5C7
      C60000000000000000001008100000000000FFF7F700D6C7B500F7DFCE00FFEF
      DE00FFEFD600FFEFD600FFEFD600A55939008C200000E7C7AD00FFF7D600FFE7
      C600FFE7CE00FFE7C600CEAE94008C695A000000000084868400FFFFFF00FFFF
      FF00FFFFFF008486840000000000000000000086840000FFFF0000FFFF000086
      840000868400008684000000000000000000000000007BCFDE0000AEF70000BE
      FF00C6FFFF00F7FFFF00B5FFFF0073F7FF0000CFF7000069A500086194000871
      A5004ABEE7000000000010081000000000000000000094C7E70084BED6004296
      B500D6F7F700F7FFF700C6EFF700A5D7E70063B6C600427994006396A5006396
      A50000000000000000001008100000000000FFF7F700D6CFBD00FFEFDE00FFF7
      DE00FFEFDE00FFEFDE00FFFFEF00A55939008C180000E7C7AD00FFF7DE00FFE7
      CE00FFEFCE00FFEFD600DEC7AD008C71630084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084868400000000000086840000FFFF00008684000086
      84000086840000000000000000000000000000000000BDFFF70063FFFF0000CF
      FF00FFFFFF00FFFFFF00F7FFFF0094FFFF0000DFFF000079C6007BEFFF00A5FF
      F7000000000000000000100810000000000000000000EFEFDE00C6DFDE00529E
      B500FFFFFF00FFFFFF00F7FFF700B5E7F70073BED60042869400C6D7CE00E7DF
      DE0000000000000000001008100000000000FFF7F700DED7C600FFEFE700FFF7
      E700FFF7E700FFF7EF00DECFB5008C3010007B100000DEC7AD00FFFFEF00FFEF
      D600FFEFD600FFEFDE00E7CFB5009486730084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084868400000000000086840000FFFF00008684000086
      84000000000000000000000000000000000000000000000000000000000018FF
      EF0000CFFF00FFFFFF00C6FFFF0084FFFF00009EE70018E7FF00000000000000
      00000000000000000000100810000000000000000000000000000000000094DF
      CE0052B6D600FFFFFF00D6F7F700B5EFF700429EB500ADD7CE00000000000000
      000000000000000000001008100000000000FFFFFF00DED7D600F7F7EF00FFFF
      F700FFF7EF00FFFFEF00C6AE9400AD796B00A5796B00E7D7CE00FFFFEF00FFEF
      DE00FFF7E700FFFFEF00DEC7B500ADA69C0084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084868400000000000086840000868400008684000000
      00000000000000000000000000000000000000000000000000005AEFFF0000C7
      FF0018FFEF0000C7FF0000CFFF0000A6E70029E7FF0000AEE70063F7FF000000
      0000000000000000000010081000000000000000000000000000D6E7E70073A6
      C60094DFCE00428EA500428EA5004296A500ADDFDE0094CFE700BDD7DE000000
      000000000000000000001008100000000000FFFFFF00E7E7E700EFE7E700FFFF
      FF00FFFFF700FFFFF700FFFFFF00EFDFCE00F7DFC600FFFFEF00FFF7EF00FFF7
      E700FFFFF700FFF7E700C6BEAD00DEDFDE008486840084868400848684008486
      8400848684008486840084868400000000000086840000868400000000000000
      0000000000000000000000000000000000000000000094E7EF0000C7FF007BF7
      FF000000000052FFEF0000C7FF005AEFFF000000000052F7FF0000A6E70094DF
      E70000000000100810001008100010081000000000000000000084C7E700D6E7
      E70000000000B5DFDE0084C7D600D6E7E70000000000D6DFDE0084C7D6000000
      00000000000000000000100810000000000000000000FFFFFF00E7E7E700F7EF
      EF00FFFFFF00FFFFFF00EFEFEF008430180094280000E7D7C600FFFFFF00FFFF
      FF00FFFFF700E7DFCE00D6D7D600FFFFFF0084868400FFFFFF00FFFFFF008486
      8400FFFFFF00FFFFFF0084868400000000000086840000000000000000000000
      000000000000000000000000000000000000000000009CD7E70094EFF7000000
      00000000000094FFFF0000C7FF006BF7FF00000000000000000084CFE7007BC7
      DE00000000000000000010081000000000000000000000000000000000000000
      000000000000EFEFE70084C7E700DEE7E7000000000000000000000000000000
      000000000000000000001008100000000000FFFFFF0000000000F7F7F700EFEF
      E700F7F7F700FFFFFF00FFFFFF009C7973008C615A00F7EFEF0000000000FFF7
      F700EFE7DE00EFE7E700FFFFFF000000000084868400FFFFFF00FFFFFF008486
      8400FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000D6EFE7004ACFF7009CE7EF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00EFEFEF00E7EFEF00F7F7F700FFFFFF00FFFFFF00FFFFF700EFEFEF00E7E7
      E700F7F7F7000000000000000000FFFFFF000000000084868400848684008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000868400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000086840000FFFF00008684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF0000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000086840000FFFF00008684000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000086840000FFFF0000868400000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000086840000000000000000000086840000FFFF0000868400000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000868400008684000000000000FFFF000086840000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000086840000FFFF0000868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848684008486
      8400848684000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000086840000FFFF0000FFFF00008684000086840000868400008684000000
      0000000000000000000000000000000000000000000084868400FFFFFF00FFFF
      FF00FFFFFF008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      00000086840000FFFF0000FFFF00008684000086840000868400000000000000
      00000000000000000000000000000000000084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      00000086840000FFFF0000868400008684000086840000000000000000000000
      00000000000000000000000000000000000084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      00000086840000FFFF0000868400008684000000000000000000000000000000
      00000000000000000000000000000000000084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      0000008684000086840000868400000000000000000000000000000000000000
      0000000000000000000000000000000000008486840084868400848684008486
      8400848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000008684000086840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084868400FFFFFF00FFFFFF008486
      8400FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000008684000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084868400FFFFFF00FFFFFF008486
      8400FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084868400848684008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840000000000000000000000000000000000848684008486
      8400848684008486840084868400848684000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840000000000000000000000000000000000848684008486
      8400848684008486840084868400848684000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840000000000000000000000000000000000848684008486
      8400848684008486840000000000848684000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840000000000000000000000000000000000848684008486
      8400848684000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840000000000000000000000000000000000848684008486
      8400848684008486840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      84008486840084868400000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848684008486
      8400848684008486840084868400848684008486840084868400848684008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FF000000FF000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000848684008486
      8400848684008486840000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000084000000000000000000
      0000000000000000000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000000000000000
      0000000000008486840084868400848684000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000084000000FF000000FF00
      0000FF000000FF00000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000000000848684008486
      8400848684008486840084868400848684000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000084000000840000008400
      0000840000008400000084000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
      0000848684008486840084868400000000000000000000000000FF0000000000
      00000000000000000000FF0000000000000000000000FF000000000000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF0000FFFF0000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      00000000000000000000FF0000000000000000000000FF000000000000000000
      0000000000000000000000000000FF0000000000000084868400848684008486
      8400848684008486840084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000008486
      840000000000000000000000000000000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000084868400000000000000
      0000000000000000000084868400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000FF
      FF000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000000000000084868400000000000000
      0000000000000000000084868400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000084868400000000000000
      0000000000000000000084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084868400FF000000FF00
      0000FF000000FF00000084868400000000000000000000000000000000000000
      0000FF000000FF0000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084868400848684008486
      8400848684008486840084868400000000000000000000000000000000000000
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
      0000000000000000000000000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FFFFFF00FFFFFF00FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FF000000FF0000000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF00000000000000000000000000000000000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000FF0000000000000000000000FF000000FF00
      0000FFFFFF00FFFFFF00FF000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF0000000000000000000000FF000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF0000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FFFFFF00FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFFFF00FF00000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FFFFFF00FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFFFF00FF0000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000FF000000FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFFFF00FF000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000FF000000FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FFFFFF00FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FFFFFF00FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FFFFFF00FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FFFFFF00FFFF
      FF00FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FFFFFF00FFFFFF00FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FFFFFF00FFFFFF00FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FFFFFF00FFFFFF00FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FFFFFF00FFFFFF00FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFFFF00FFFFFF00FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
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
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000000000000000000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF0000000000000000000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF000000FF00000000000000000000000000
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
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084868400000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008486840084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008486840084868400848684000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008486840084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008486840084868400848684000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FFFFFF00FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848684000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FFFFFF00FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000008486
      8400848684008486840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FFFFFF00FFFF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FFFFFF00FFFFFF00FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FFFFFF00FFFFFF00FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007B797B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007B797B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000FF000000FF000000FF000000
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007B797B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF00000000000000FF000000
      FF000000FF0000000000000000000000000084868400000000000000FF000000
      FF000000FF00000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000008486840000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF007B797B00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B797B007B79
      7B0000000000000000007B797B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007B797B007B797B0000FFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00007B797B0000FFFF0000FFFF00000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00000000000000
      0000FFFFFF00000000000000000000000000FFFFFF0000000000000000000000
      00000000FF0000000000000000007B797B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF0000000000000000000000000000000000000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000BDBE
      BD00FFFFFF0000000000FFFFFF000000000000000000000000007B797B000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF000000FF00000000000000FF000000FF000000FF000000
      FF0000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
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
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF0000000000000000000000FF000000FFFFFF00FF00
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FF00000000000000FFFFFF00000000000000
      000000000000000000000000000000000000FF000000FF000000FF0000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000FF000000FFFFFF00FFFFFF00000000008486840084868400848684008486
      8400848684000000000084868400848684008486840084868400848684000000
      0000848684008486840084868400848684000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000008486840084868400848684000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FF000000FFFFFF008486840084868400FFFFFF00FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000008486840084868400848684008486
      8400848684000000000084868400848684008486840084868400848684000000
      0000848684008486840084868400848684000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000FF0000008486840000000000FF000000000000008486
      8400FF00000000000000000000000000000000000000FFFFFF00FFFFFF00FF00
      0000FF000000FFFFFF0084868400FFFFFF00FFFFFF0084868400FFFFFF00FF00
      0000FF000000FFFFFF00FFFFFF00000000008486840084868400848684008486
      8400848684000000000084868400848684008486840084868400848684000000
      0000848684008486840084868400848684000000000000000000000000000000
      00000000000000000000FF0000000000000000000000FF00000000000000FF00
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000FF00000084868400FF000000FF000000FF0000008486
      8400FF00000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FF00000084868400FFFFFF008486840084868400FFFFFF0084868400FF00
      000000000000FFFFFF00FFFFFF00000000008486840084868400848684008486
      8400848684000000000084868400848684008486840084868400848684000000
      0000848684008486840084868400848684000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      0000FF0000000000000000000000000000000000000000000000848684008486
      84008486840000000000FF0000008486840000000000FF000000000000008486
      8400FF00000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000FF00000084868400FFFFFF008486840084868400FFFFFF0084868400FF00
      000000000000FFFFFF00FFFFFF00000000008486840084868400848684008486
      8400848684000000000084868400848684008486840084868400848684000000
      0000848684008486840084868400848684000000000000000000000000000000
      000000000000FF00000000000000848684008486840000000000FF0000000000
      0000000000000000000000000000000000000000000084868400FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000008486840084868400848684000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FF00
      0000FF000000FFFFFF0084868400FFFFFF00FFFFFF0084868400FFFFFF00FF00
      0000FF000000FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008486840000000000000000008486840000000000FF00
      0000FF00000000000000000000000000000084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000000000FF000000FF000000FF0000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF0000000000FF000000FFFFFF008486840084868400FFFFFF00FF0000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000848684000000000084868400848684000000000084868400FF00
      00000000000000000000000000000000000084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FF000000FF000000FF000000FF00000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000848684000000000084868400848684000000000084868400FF00
      00000000000000000000000000000000000084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FF0000000000000000000000FF000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000000000008486840000000000000000008486840000000000FF00
      0000FF0000000000000000000000000000008486840084868400848684008486
      8400848684008486840084868400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000848684008486840000000000FF0000000000
      00000000000000000000000000000000000084868400FFFFFF00FFFFFF008486
      8400FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF000000FF000000000000000000
      00000000000000000000000000000000000084868400FFFFFF00FFFFFF008486
      8400FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF0000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000084868400848684008486
      8400848684008486840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000084868400848684008486
      8400848684008486840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848684008486840084868400000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000008400
      0000840000008400000084000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      0000C6000000C6000000C6000000C6000000C6000000C6000000C6000000C600
      000000000000000000000000FF00000000000000000084868400848684008486
      8400848684008486840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000848684008486840000000000FFFFFF0000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084868400848684008486
      84008486840000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000848684000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084868400848684008486
      840084868400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084868400000000000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084868400848684008486
      840000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084868400848684000000
      0000FFFFFF000000000000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0084868400000000000000000000000000000000000000
      0000FFFFFF00FFFFFF000000000000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084868400848684000000
      0000000000008486840000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0084868400000000000000000000000000848684000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000008400
      0000000000000000000000000000000000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084868400848684008486
      8400848684008486840000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0084868400000000000000000084868400FFFFFF00FFFF
      FF00FFFFFF00848684000000000000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000008400
      0000840000008400000084000000840000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      000000000000000000000000000000000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084868400848684008486
      8400848684008486840000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF00848684000000000084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008486840000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF0000000000FFFFFF00000000000000000000000000000000008400
      0000840000000000000000000000840000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      0000C6000000C6000000C6000000C6000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084868400848684008486
      8400848684008486840000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF000000000000000000848684000000000084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008486840000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000840000008400000000000000840000000000000000000000000000008400
      0000000000000000000000000000000000000000FF000000000000000000C600
      0000C60000000000000000000000C6000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084868400848684008486
      8400848684008486840000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF000000000084868400848684000000000084868400FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008486840000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000008400000084000000840000000000000000000000000000008400
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000C6000000C600000000000000C6000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000084868400848684008486
      8400848684008486840084868400000000008486840000000000848684000000
      0000848684008486840084868400000000008486840084868400848684008486
      8400848684008486840084868400000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000084000000840000008400000084000000840000008400
      0000000000000000000000000000000000000000FF0000000000000000000000
      000000000000C6000000C6000000C6000000000000000000000000000000C600
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000084868400FFFFFF00FFFFFF008486
      8400FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000FF0000000000000000000000
      00000000000000000000C6000000C6000000C6000000C6000000C6000000C600
      000000000000000000000000FF000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF0000000000000084868400FFFFFF00FFFFFF008486
      8400FFFFFF00FFFFFF0084868400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084868400848684008486
      8400848684008486840000000000000000000000000000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000C00000000100010000000000000600000000000000000000
      000000000000000000000000FFFFFF00FFFF0000FFFF000087CF0000FFFF0000
      83870000FFFF000081030000FFFF0000C0030000FFFF0000E0070000FFFF0000
      F00F0000E0070000F81F0000C0030000F81F000080010000F01F000000000000
      E00F000000000000C107000000000000C383000000000000E7C3000080010000
      FFE30000C0030000FFFF0000E0070000FFF8FFFFFFFFFFFFFFF0FFFFFFFF1C3C
      FFF0F8FFFFFF3002BF6198CDF8FD4001DF21888DC8984000EF03C01DC01D8000
      EF00E03DE03D0000C7008005800D000083018005800D00000103800D800D0000
      0107E03DE03D0000010FC01DC01D0000011F8888C89D8000013F98CDF8FD4021
      017FF8FFFFFF200683FFFFFFFFFF1008FFFFC003FF9FFF8FFF55D7FBE007FF0F
      FFFFDEFBE3E7FF0FBF7DDFFB8FE7F61FDFFFDF73AFE7F21FEF7DDFFBCFF7F03F
      EFFFD6FBCFF7F007C77DDFDBCFF7F00F83FFDFFBEFF3F01F017DD7FBEFF3F03F
      01FFDFFBEFF3F07F0155DE83E7F5F0FF01FFDBB7E7F1F1FF01FFDFAFE7C7F3FF
      01FFDF9FE007F7FF83FFC03FF8FFFFFF00010000003F0000FFCF7FFE7FBF0000
      FF87400240BF0000FF03400240BF0000FFCF400240BF0000F3CF400240BF0000
      F3CF4002403F0000F3CF40027E3F0000F3CF4002001F0000F3CF40021E0F0000
      F3CF400200060000F3FF4002FFE00000C0FF7FFEFFF00000E1FF0000FFF00000
      F3FF1FF8FFE0000000000000FFFF0000FFFFFFFFFFFF7FFEFC7FFFFF81017FFE
      F83FFFFFBD7D7FF6FC1FFFFFBD7D7FF2F803DFFEBD7D7C00F838DFFE817D7C00
      F800DFFE817D7FF2CC11DDBEFF017FF6870FD81EFF016FFE8007DDBE81FF4FFE
      C0071FF8BDE1003EC0079FFCBDED003EE007DFFEBDED4FFEF00FFFFF81E16FFE
      FC1FFFFF81E17FFEFFFFFFFFFFFF7FFE7FFEFFFFFFFFFFFF7FFEFFFFFFFFFEFF
      7FFEFFFFFFFFFC3F7FFEFFFFFFFFF80F7FFEDFFFFFFBFC036FF68FFFFFF1FEC1
      4FF207FFFFE0FFF11FF88FFFFFF1FFF81FF88FFFFFF1FFF84FF2C7FFFFE3FFF8
      6FF6C7FFFFE3FFF17FFEE3FFFFC7FFC17FFEE0FFFF07FE037FFEF01FF80FFE0F
      7FFEFC1FF83FFE3F7FFEFF1FF8FFFFFFFFFFFFFF00000000F80101017E7EFE7F
      F80101017C3EFC3FF8010101799EF99FF80101017FFEFFFFF80101016FF6FFFF
      D80101014FF2FFFFE80101011FF8FFFFF001FFFF1FF8FFFFCC0101014FF2FFFF
      F5FF01016FF6FFFFEAFF01017FFEFFFFDF7F0101799EF99FFBFF01017C3EFC3F
      FFFF01017E7EFE7FFBFF010100000000FFFFFFFFFFFFFFBFFFFFFFFFBBFBFF1F
      C00FFFFBB3F3FE0FDFEFFFF1A3E30000D0EFFFE083C30000DFEFFFF1A3E30000
      D02FFFF1B3F3FE0FDFEFFFF1FBFBF60FD02FFFF1FFFFE3FFDFEFFFE3BFBBC1FF
      D1EFFFE39F9B0000DF0FFFC78F8B0000D35FFF0787830000DF3FF80F8F8BC1FF
      C07FF83F9F9BC1FFFFFFF8FFBFBBFFFFFFFFFFFFFC00FFFFF83FF83FFC00FFFF
      E10FE10FFC00E00747474747FC00DFFB0FE30FE30000C0031FF31FF30000C4DB
      0FF90FF90000DB23FFF9FFF90000C003FFFFFFFF0023F00F3FFF3FFF0001F00F
      3FC13FC10000F00F9FE19FE10023F01F8FF18FF10063F07FC7C1C7C100C3F07F
      E10DE10D0107FFFFF83FF83F03FFFFFFFFFFFFFC0000FFFF557FFFF80000FFFF
      FFFFFF110000FFFF7F7CBE0300000410FFF8DD17000004107F71E8A300000410
      FC2BE803000004107007C0A300000410F24F85170000DF7D65A7020F00008E38
      E247011F00000410624701FF0000DF7DE5A701FF0000DF7D724F01FF0000DF7D
      F81F01FF0000FFFF543F83FF0000FFFFFFFF7FFD0000FE0100007FFD0000FE01
      E00F600D00007C00EFEF6FED0000B800EFEF6FED0000D800EFEF6FED0000F000
      EFEF6FED0000E000EFEF6FED0000C200EFEF6FED00008200E0EF6FED00000000
      E6EF60ED00000001F2EF66ED00000003F8EF72ED00000107FC0F78ED0000019F
      00007C0D000001FFFFFF7FFD000083FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      3FF3FFF3CFFFCFFC3FC3FFC3C3FFC3FC3F03FF03C0FFC0FC3C03FC03C03FC03C
      3003F003C00FC00C0003C003C003C0003003F003C00FC00C3C03FC03C03FC03C
      3F03FF03C0FFC0FC3FC3FFC3C3FFC3FC3FF3FFF3CFFFCFFCFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object timerStickToCPRS: TTimer
    Enabled = False
    Interval = 300
    OnTimer = timerStickToCPRSTimer
    Left = 355
    Top = 121
  end
  object OpenDialog1: TOpenDialog
    Filter = '*.*|*.*|*.txt|*.txt|*.exe|*.exe'
    Left = 145
    Top = 124
  end
  object MagSubscriber1: TMagSubscriber
    OnSubscriberUpdate = MagSubscriber1SubscriberUpdate
    Publisher = frmImageList.MagPublisher1
    Left = 56
    Top = 144
  end
end
