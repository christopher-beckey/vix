object frmLoadingImageMessage: TfrmLoadingImageMessage
  Left = -2169
  Top = 397
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Loading Images'
  ClientHeight = 117
  ClientWidth = 304
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbImageResolution: TLabel
    Left = 81
    Top = 0
    Width = 140
    Height = 16
    AutoSize = False
    Caption = 'Loading a page of Abstracts...'
    Layout = tlCenter
  end
  object lbImagename: TLabel
    Left = 6
    Top = 42
    Width = 293
    Height = 17
    AutoSize = False
    Caption = 'lbImagename'
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 48
    Top = 92
    Width = 209
    Height = 13
    Caption = '('#39'Cancel'#39' to stop after loading current image.)'
  end
  object lbnumbers: TLabel
    Left = 6
    Top = 22
    Width = 293
    Height = 17
    AutoSize = False
    Caption = 'lbnumbers'
    Layout = tlCenter
  end
  object bbCancel: TBitBtn
    Left = 108
    Top = 66
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 0
    OnClick = bbCancelClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000010000000000000000000
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
  object timerShow: TTimer
    Enabled = False
    Interval = 10
    OnTimer = timerShowTimer
    Left = 268
    Top = 68
  end
end
