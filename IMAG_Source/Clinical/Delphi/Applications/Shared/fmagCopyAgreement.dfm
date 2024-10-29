object frmCopyAgreement: TfrmCopyAgreement
  Left = -1059
  Top = 256
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'VistA Imaging : Physcian Agreement for Downloaded Images.'
  ClientHeight = 385
  ClientWidth = 577
  Color = clBtnFace
  Constraints.MinWidth = 400
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object pnlAgree: TPanel
    Left = 0
    Top = 0
    Width = 565
    Height = 369
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      565
      369)
    object memAgreement: TMemo
      Left = 37
      Top = 24
      Width = 513
      Height = 281
      Anchors = [akLeft, akTop, akRight, akBottom]
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Lines.Strings = (
        'Agreement'
        ''
        'All uses pose potential violations of patient privacy.'
        ''
        
          'It is absolutely required that all users with download capablili' +
          'ty personally'
        'inspect each downloaded image.'
        ''
        
          'For technical reasons, related to the image capture process, som' +
          'e of the '
        
          'images contain patient identification data which must be manuall' +
          'y '
        'removed.'
        ''
        
          'Each image downloaded is tracked and audited by the Imaging Syst' +
          'em. '
        ''
        
          'The images are not to be distributed outside the VA, or used for' +
          ' any other '
        'purposes than listed on the next page.'
        ''
        
          'The downloading user is specifically responsible for protection ' +
          'of these '
        'images.'
        ''
        '')
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object btnOKAgree: TBitBtn
      Left = 118
      Top = 319
      Width = 90
      Height = 30
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKAgreeClick
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
      Margin = 2
      NumGlyphs = 2
      Spacing = -1
      IsControl = True
    end
    object BitBtn1: TBitBtn
      Left = 362
      Top = 319
      Width = 90
      Height = 30
      TabOrder = 2
      Kind = bkCancel
      Margin = 2
      Spacing = -1
      IsControl = True
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 577
    Height = 377
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      577
      377)
    object lbHeader: TLabel
      Left = 10
      Top = 14
      Width = 335
      Height = 16
      Caption = 'Images are made available only for the following purposes:'
    end
    object lstReasons: TListBox
      Left = 12
      Top = 48
      Width = 556
      Height = 233
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 16
      TabOrder = 0
      OnClick = lstReasonsClick
    end
    object pnlesig2: TPanel
      Left = 0
      Top = 287
      Width = 577
      Height = 90
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        577
        90)
      object lbSelectedReason: TLabel
        Left = 28
        Top = 10
        Width = 4
        Height = 16
      end
      object btnOK: TBitBtn
        Left = 117
        Top = 32
        Width = 90
        Height = 30
        Caption = 'OK'
        Default = True
        Enabled = False
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
        Margin = 2
        NumGlyphs = 2
        Spacing = -1
        IsControl = True
      end
      object btnCancel: TBitBtn
        Left = 362
        Top = 32
        Width = 90
        Height = 30
        Anchors = [akTop, akRight]
        TabOrder = 1
        Kind = bkCancel
        Margin = 2
        Spacing = -1
        IsControl = True
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 128
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      OnClick = File1Click
      object mnuAgreement: TMenuItem
        Caption = 'Agreement...'
        OnClick = mnuAgreementClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object ImageDownloadAgreementHelp1: TMenuItem
        Caption = 'Image Download Agreement Help'
        OnClick = ImageDownloadAgreementHelp1Click
      end
    end
  end
end
