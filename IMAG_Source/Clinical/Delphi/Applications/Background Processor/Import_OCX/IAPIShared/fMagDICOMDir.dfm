object frmDICOMDir: TfrmDICOMDir
  Left = 598
  Top = 281
  Width = 377
  Height = 475
  BorderIcons = [biSystemMenu]
  Caption = 'DCM Viewer Open File'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  DesignSize = (
    369
    441)
  PixelsPerInch = 96
  TextHeight = 13
  object btnClose: TButton
    Left = 144
    Top = 416
    Width = 75
    Height = 25
    Anchors = [akBottom]
    Caption = 'Close'
    TabOrder = 0
    OnClick = btnCloseClick
  end
  object pnlLeft: TPanel
    Left = 8
    Top = 8
    Width = 169
    Height = 377
    Anchors = [akLeft, akTop, akBottom]
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      169
      377)
    object DriveComboBox1: TDriveComboBox
      Left = 0
      Top = 8
      Width = 169
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = DriveComboBox1Change
    end
    object DirectoryListBox1: TDirectoryListBox
      Left = 0
      Top = 32
      Width = 169
      Height = 137
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 16
      TabOrder = 1
      OnChange = DirectoryListBox1Change
    end
    object FileListBox1: TFileListBox
      Left = 0
      Top = 176
      Width = 169
      Height = 169
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      Mask = '*.tga;*.pac;*.756;*.jpg;*.tif;*.bmp;*.dcm;*.big;*.bw'
      TabOrder = 2
      OnClick = FileListBox1Click
    end
    object FilterComboBox1: TFilterComboBox
      Left = 0
      Top = 348
      Width = 169
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      FileList = FileListBox1
      Filter = 
        'Images|*.tga;*.pac;*.756;*.jpg;*.tif;*.bmp;*.dcm;*.big;*.bw|Radi' +
        'ology|*.tga;*.pac;*.bw;*.big,*.dcm|Abstracts|*.abs|All Files (*.' +
        '*)|*.*'
      TabOrder = 3
    end
  end
  object pnlRight: TPanel
    Left = 192
    Top = 8
    Width = 169
    Height = 377
    Anchors = [akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      169
      377)
    object DriveComboBox2: TDriveComboBox
      Left = 0
      Top = 8
      Width = 169
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = DriveComboBox2Change
    end
    object DirectoryListBox2: TDirectoryListBox
      Left = 0
      Top = 32
      Width = 169
      Height = 137
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 16
      TabOrder = 1
      OnChange = DirectoryListBox2Change
    end
    object FileListBox2: TFileListBox
      Left = 0
      Top = 176
      Width = 169
      Height = 169
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      Mask = '*.tga;*.pac;*.756;*.jpg;*.tif;*.bmp;*.dcm;*.big;*.bw'
      TabOrder = 2
      OnClick = FileListBox2Click
    end
    object FilterComboBox2: TFilterComboBox
      Left = 0
      Top = 348
      Width = 169
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      FileList = FileListBox2
      Filter = 
        'Images|*.tga;*.pac;*.756;*.jpg;*.tif;*.bmp;*.dcm;*.big;*.bw|Radi' +
        'ology|*.tga;*.pac;*.bw;*.big,*.dcm|Abstracts|*.abs|All Files (*.' +
        '*)|*.*'
      TabOrder = 3
    end
  end
  object timerResize: TTimer
    Enabled = False
    Interval = 500
    OnTimer = timerResizeTimer
    Left = 288
    Top = 400
  end
end
