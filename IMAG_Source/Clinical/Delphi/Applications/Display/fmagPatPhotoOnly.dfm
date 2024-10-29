object frmPatPhotoOnly: TfrmPatPhotoOnly
  Left = 361
  Top = 439
  HelpContext = 10145
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'VistA Imaging : Patient Photo Viewer'
  ClientHeight = 359
  ClientWidth = 727
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Splitter1: TSplitter
    Left = 181
    Top = 41
    Width = 5
    Height = 294
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 335
    Width = 727
    Height = 24
    Panels = <
      item
        Alignment = taCenter
        Width = 50
      end>
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 727
    Height = 41
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object magObserverLabel1: TMagObserverLabel
      Left = 11
      Top = 1
      Width = 109
      Height = 18
      Align = alLeft
      Caption = '<patient name>'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      MagPat = Mag4PatPhotoOnly
    end
    object Label2: TLabel
      Left = 348
      Top = 1
      Width = 378
      Height = 39
      Align = alRight
      AutoSize = False
      Caption = ' Patient Photo Viewer'
      Layout = tlCenter
    end
    object Label3: TLabel
      Left = 1
      Top = 1
      Width = 10
      Height = 39
      Align = alLeft
      AutoSize = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 181
    Height = 294
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 2
    object MagPatPhoto1: TMagPatPhoto
      Left = 0
      Top = 0
      Width = 181
      Height = 294
      Align = alClient
      TabOrder = 0
      MagHideWhenNull = False
      MagPat = Mag4PatPhotoOnly
    end
  end
  object Panel5: TPanel
    Left = 192
    Top = 41
    Width = 529
    Height = 294
    Caption = 'Panel5'
    TabOrder = 3
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 527
      Height = 48
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 3
        Top = 15
        Width = 45
        Height = 16
        Caption = 'Patient:'
      end
      object ePatient: TEdit
        Left = 72
        Top = 12
        Width = 283
        Height = 24
        TabOrder = 0
        OnDblClick = ePatientDblClick
        OnEnter = ePatientEnter
        OnKeyDown = ePatientKeyDown
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 237
      Width = 527
      Height = 56
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object bbClose: TBitBtn
        Left = 205
        Top = 13
        Width = 82
        Height = 30
        Caption = '&Close'
        ModalResult = 2
        TabOrder = 0
        OnClick = bbCloseClick
        OnEnter = bbCloseEnter
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
          F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
          000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
          338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
          45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
          3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
          F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
          000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
          338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
          4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
          8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
          333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
          0000}
        NumGlyphs = 2
      end
    end
    object lvPat: TMagListView
      Left = 48
      Top = 87
      Width = 379
      Height = 124
      Columns = <>
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      PopupMenu = PopupMenu1
      TabOrder = 2
      OnChange = lvPatChange
      OnEnter = lvPatEnter
      OnKeyDown = lvPatKeyDown
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'System'
    Font.Style = []
    Left = 516
    Top = 185
  end
  object MainMenu1: TMainMenu
    Left = 240
    Top = 268
    object File1: TMenuItem
      Caption = 'File'
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object mnuOptions: TMenuItem
      Caption = 'Options'
      Visible = False
      object PhotowInfo1: TMenuItem
        Caption = 'Photo w/Info'
        OnClick = PhotowInfo1Click
      end
      object PhotoOnly1: TMenuItem
        Caption = 'Photo Only'
        OnClick = PhotoOnly1Click
      end
      object PhotowName1: TMenuItem
        Caption = 'Photo w/Name'
      end
      object PhotoTop1: TMenuItem
        Caption = 'Photo Top'
      end
      object PhotoLeft1: TMenuItem
        Caption = 'Photo Left'
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object PatientPhotoOnlyHelp1: TMenuItem
        Caption = 'Patient Photo Only  Help'
        OnClick = PatientPhotoOnlyHelp1Click
      end
    end
  end
  object Mag4PatPhotoOnly: TMag4Pat
    M_FakePatientName = 'LightYear,Buzz'
    M_UseFakeName = False
    CurrentlySwitchingPatient = False
    Left = 256
    Top = 88
  end
  object PopupMenu1: TPopupMenu
    Left = 345
    Top = 168
    object FitColumnstoText1: TMenuItem
      Caption = 'Fit Columns to Text'
      OnClick = FitColumnstoText1Click
    end
    object FitColumnstoForm1: TMenuItem
      Caption = 'Fit Columns to Window'
      OnClick = FitColumnstoForm1Click
    end
  end
end
