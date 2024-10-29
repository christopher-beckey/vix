object DicomNumbers: TDicomNumbers
  Left = 619
  Top = 339
  Caption = 'Test Dicom Series and Image number fields'
  ClientHeight = 171
  ClientWidth = 382
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 203
    Top = 118
    Width = 132
    Height = 16
    Caption = 'Dicom Image numbrer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 49
    Top = 120
    Width = 133
    Height = 16
    Caption = 'Dicom Series numbrer'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 2
    Width = 369
    Height = 81
    AutoSize = False
    Caption = 
      'Here we are simulating a modality that sends Dicom Series, and I' +
      'mage unmbers as Data for the image.  This Dicom data will be sto' +
      'red in the Image file for the captured image.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object Label4: TLabel
    Left = 84
    Top = 94
    Width = 213
    Height = 13
    Caption = 'This is for testing, use with a test patient only.'
    Color = clBlue
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object EDSN: TEdit
    Left = 75
    Top = 148
    Width = 75
    Height = 21
    TabOrder = 0
    Text = '1'
  end
  object EDIN: TEdit
    Left = 231
    Top = 148
    Width = 79
    Height = 21
    TabOrder = 1
    Text = '1'
  end
end
