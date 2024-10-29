object fEKGdlg: TfEKGdlg
  Left = 353
  Top = 253
  BorderStyle = bsDialog
  Caption = 'Dotted Grid'
  ClientHeight = 200
  ClientWidth = 427
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 104
    Top = 4
    Width = 202
    Height = 29
    Caption = 'Print a dotted grid?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object cbShowDottedGridDlg: TCheckBox
    Left = 40
    Top = 168
    Width = 145
    Height = 17
    Caption = 'Don'#39't ask me this again'
    TabOrder = 0
    OnClick = cbShowDottedGridDlgClick
  end
  object bYes: TButton
    Left = 232
    Top = 160
    Width = 75
    Height = 25
    Caption = '&Yes'
    TabOrder = 1
    OnClick = bYesClick
  end
  object bNo: TButton
    Left = 320
    Top = 160
    Width = 75
    Height = 25
    Caption = '&No'
    TabOrder = 2
    OnClick = bNoClick
  end
  object Memo1: TMemo
    Left = 16
    Top = 40
    Width = 393
    Height = 105
    Color = 13756649
    Ctl3D = True
    Lines.Strings = (
      
        'EKG grids print differently on different types of printers.  Ink' +
        'jet printers'
      
        'print the best quality grid without any special settings.  Many ' +
        'laser'
      
        'printers do not print the minor grid lines (1mm lines) very well' +
        '.  You can'
      
        'use the dotted grid setting to print a more readable grid with a' +
        ' laser printer.'
      ''
      
        'Note:  If you choose yes, the grid on your display will change w' +
        'hile the EKG'
      'is printing.  It will revert back to a normal grid when done.')
    ParentCtl3D = False
    ReadOnly = True
    TabOrder = 3
  end
end
