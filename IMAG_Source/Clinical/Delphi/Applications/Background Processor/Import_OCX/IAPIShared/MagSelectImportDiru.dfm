object MagSelectImportDirf: TMagSelectImportDirf
  Left = 347
  Top = 115
  HelpContext = 134
  ActiveControl = OKBtn
  BorderStyle = bsDialog
  Caption = 'Select Directory of Images to Import'
  ClientHeight = 246
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object DrvDir: TLabel
    Left = 208
    Top = 49
    Width = 144
    Height = 13
    Alignment = taCenter
    Caption = 'C:\dev\p94\Clin\Capture'
    Color = clBtnFace
    ParentColor = False
  end
  object lbAlign: TLabel
    Left = 398
    Top = 232
    Width = 15
    Height = 13
    AutoSize = False
    Caption = 'lbAlign'
    Color = clRed
    ParentColor = False
    Visible = False
  end
  object DriveComboBox2: TDriveComboBox
    Left = 14
    Top = 16
    Width = 181
    Height = 19
    DirList = DirectoryListBox2
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 208
    Top = 16
    Width = 181
    Height = 21
    Hint = 
      'Select entry from list or Enter your own ( i.e.  st*.* ) to limi' +
      't the directory listing.'
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    Text = '*.*'
    OnClick = ComboBox1Click
    OnKeyDown = ComboBox1KeyDown
    Items.Strings = (
      '*.*'
      '*.BMP'
      '*.JPG'
      '*.JPG;*.TGA;*.TIF;*.BMP'
      '*.TGA'
      '*.TIF')
  end
  object DirectoryListBox2: TDirectoryListBox
    Left = 14
    Top = 50
    Width = 181
    Height = 120
    DirLabel = DrvDir
    FileList = FileListBox1
    ItemHeight = 16
    TabOrder = 2
  end
  object FileListBox1: TFileListBox
    Left = 208
    Top = 75
    Width = 181
    Height = 95
    TabStop = False
    DragMode = dmAutomatic
    ItemHeight = 13
    TabOrder = 3
  end
  object OKBtn: TBitBtn
    Left = 31
    Top = 184
    Width = 77
    Height = 27
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = OKBtnClick
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
    Margin = 2
    NumGlyphs = 2
    Style = bsNew
    Spacing = -1
    IsControl = True
  end
  object CancelBtn: TBitBtn
    Left = 167
    Top = 184
    Width = 77
    Height = 27
    TabOrder = 5
    Kind = bkCancel
    Margin = 2
    Style = bsNew
    Spacing = -1
    IsControl = True
  end
  object BitBtn1: TBitBtn
    Left = 302
    Top = 184
    Width = 77
    Height = 27
    HelpContext = 134
    Caption = '&Help'
    TabOrder = 6
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000010000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
      3333333333333FF3333333330000333333364463333333333333388F33333333
      00003333333E66433333333333338F38F3333333000033333333E66333333333
      33338FF8F3333333000033333333333333333333333338833333333300003333
      3333446333333333333333FF3333333300003333333666433333333333333888
      F333333300003333333E66433333333333338F38F333333300003333333E6664
      3333333333338F38F3333333000033333333E6664333333333338F338F333333
      0000333333333E6664333333333338F338F3333300003333344333E666433333
      333F338F338F3333000033336664333E664333333388F338F338F33300003333
      E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
      3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
      E333333333388FFFFF8333330000333333333333333333333333388888333333
      0000}
    NumGlyphs = 2
    Style = bsNew
  end
  object cbSaveAsDefault: TCheckBox
    Left = 10
    Top = 216
    Width = 115
    Height = 23
    Caption = 'Save as Default'
    TabOrder = 7
  end
end
