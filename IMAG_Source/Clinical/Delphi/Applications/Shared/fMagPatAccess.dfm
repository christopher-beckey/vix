object frmPatAccess: TfrmPatAccess
  Left = 707
  Top = 116
  HelpContext = 10142
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'PATIENT ALERT !!!'
  ClientHeight = 279
  ClientWidth = 435
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object lbAlign: TLabel
    Left = 696
    Top = 250
    Width = 10
    Height = 10
    AutoSize = False
    Color = clRed
    ParentColor = False
    Visible = False
  end
  object lbmsg: TLabel
    Left = 0
    Top = 191
    Width = 435
    Height = 31
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Layout = tlCenter
  end
  object lblSiteName: TLabel
    Left = 0
    Top = 41
    Width = 435
    Height = 19
    Align = alTop
    Alignment = taCenter
    Font.Charset = ANSI_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 60
    Width = 435
    Height = 131
    HorzScrollBar.Range = 391
    HorzScrollBar.Visible = False
    VertScrollBar.Increment = 2
    VertScrollBar.Position = 8
    VertScrollBar.Range = 350
    VertScrollBar.Tracking = True
    Align = alTop
    AutoScroll = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Memo1: TMemo
      Left = 0
      Top = -8
      Width = 414
      Height = 398
      TabStop = False
      Align = alTop
      Alignment = taCenter
      Color = clSilver
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      Lines.Strings = (
        'Memo1'
        '1234567890123456789012345678901234567890123456789'
        '0'
        '123456789S123456789S12345'
        '6789E'
        ''
        '1234567890123456789012345678901234567890123456789'
        '0'
        '123456789S123456789S12345'
        '6789E')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WordWrap = False
      OnClick = Memo1Click
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 435
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lbAlerttext: TLabel
      Left = 0
      Top = 0
      Width = 435
      Height = 41
      Align = alClient
      Alignment = taCenter
      Caption = 'RESTRICTED PATIENT RECORD !!!'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 222
    Width = 211
    Height = 57
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    object bbOK: TBitBtn
      Left = 100
      Top = 14
      Width = 89
      Height = 33
      TabOrder = 0
      OnClick = bbOKClick
      Kind = bkOK
    end
  end
  object Panel3: TPanel
    Left = 224
    Top = 222
    Width = 211
    Height = 57
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
    object bbCancel: TBitBtn
      Left = 16
      Top = 14
      Width = 89
      Height = 33
      TabOrder = 0
      OnClick = bbCancelClick
      Kind = bkCancel
    end
    object btnCancelAll: TBitBtn
      Left = 112
      Top = 14
      Width = 97
      Height = 33
      Hint = 'Don'#39't view sensitive patient images at remaining remote sites.'
      Caption = 'Cancel All'
      ModalResult = 9
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnCancelAllClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 44
    Top = 162
  end
end
