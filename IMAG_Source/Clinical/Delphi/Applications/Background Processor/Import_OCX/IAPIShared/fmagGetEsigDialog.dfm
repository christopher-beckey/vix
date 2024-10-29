object frmGetEsigDialog: TfrmGetEsigDialog
  Left = 393
  Top = 409
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Electronic Signature Dialog'
  ClientHeight = 170
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 64
    Top = 42
    Width = 123
    Height = 13
    Caption = 'Enter Electronic Signature'
  end
  object lbesigdesc: TLabel
    Left = 37
    Top = 8
    Width = 314
    Height = 13
    Caption = 
      'Electronic Signature is required to enable Print and Copy functi' +
      'ons.'
  end
  object edtEsig: TEdit
    Left = 209
    Top = 40
    Width = 114
    Height = 21
    PasswordChar = '*'
    TabOrder = 0
    OnKeyUp = edtEsigKeyUp
  end
  object okbtn: TBitBtn
    Left = 80
    Top = 102
    Width = 75
    Height = 25
    Enabled = False
    TabOrder = 1
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 232
    Top = 102
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
