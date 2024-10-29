object frmCapConfig: TfrmCapConfig
  Left = 633
  Top = 224
  HelpContext = 10107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Imaging Workstation configuration'
  ClientHeight = 433
  ClientWidth = 658
  Color = 12963793
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object pnlHide1: TPanel
    Left = 718
    Top = 114
    Width = 161
    Height = 111
    Caption = 'pnlHide1'
    TabOrder = 4
    Visible = False
    object lLum100values: TListBox
      Left = 6
      Top = 4
      Width = 143
      Height = 71
      TabStop = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -9
      Font.Name = 'Small Fonts'
      Font.Style = [fsBold]
      ItemHeight = 11
      ParentFont = False
      TabOrder = 0
    end
    object elum100: TEdit
      Left = 8
      Top = 78
      Width = 137
      Height = 22
      TabStop = False
      TabOrder = 1
      Text = 'elum100'
    end
  end
  object pnlHide: TPanel
    Left = 24
    Top = 452
    Width = 709
    Height = 141
    Caption = 'pnlHide'
    TabOrder = 5
    Visible = False
    object Label5: TLabel
      Left = 520
      Top = 10
      Width = 81
      Height = 45
      AutoSize = False
      Caption = 'add [group image #] to image short description.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object OffLine: TRadioButton
      Left = 196
      Top = 116
      Width = 113
      Height = 17
      Caption = 'Off Line'
      Enabled = False
      TabOrder = 0
      OnClick = OffLineClick
    end
    object Vidar: TRadioButton
      Left = 132
      Top = 6
      Width = 125
      Height = 17
      Caption = 'Vidar / Howtek'
      Enabled = False
      TabOrder = 1
    end
    object ScanJetXray: TRadioButton
      Left = 106
      Top = 24
      Width = 143
      Height = 17
      Caption = 'HP ScanJet 4c Xray'
      Enabled = False
      TabOrder = 2
    end
    object Vista: TRadioButton
      Left = 112
      Top = 45
      Width = 125
      Height = 17
      Caption = 'Vista'
      Enabled = False
      TabOrder = 3
    end
    object VistaInteractive: TRadioButton
      Left = 106
      Top = 67
      Width = 125
      Height = 17
      Caption = 'Vista Interactive'
      Enabled = False
      TabOrder = 4
    end
    object Lumisys100: TRadioButton
      Left = 12
      Top = 8
      Width = 113
      Height = 17
      Caption = 'Lumisys 100'
      TabOrder = 5
    end
    object ScanECG: TRadioButton
      Left = 68
      Top = 109
      Width = 103
      Height = 17
      Caption = 'ScanECG'
      Enabled = False
      TabOrder = 6
    end
    object pnlSupportedTypes: TPanel
      Left = 256
      Top = 8
      Width = 217
      Height = 97
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 7
      object lblSupportedTypes: TLabel
        Left = 8
        Top = 8
        Width = 201
        Height = 17
        AutoSize = False
        Caption = 'Other types that can be imported:'
        WordWrap = True
      end
      object ListBox1: TListBox
        Left = 6
        Top = 24
        Width = 201
        Height = 65
        TabStop = False
        BorderStyle = bsNone
        Color = clBtnFace
        ItemHeight = 14
        Items.Strings = (
          'Adobe (PDF)'
          'Word (DOC)'
          'Rich Text (RTF)'
          'Motion Video (AVI, MPG)'
          'Text Document (TXT)'
          'Web Document (HTM)'
          'Audio  (WAV)')
        TabOrder = 0
      end
    end
    object cbPageNum: TCheckBox
      Left = 496
      Top = 14
      Width = 17
      Height = 21
      TabStop = False
      Caption = 'cbPageNum'
      TabOrder = 8
      Visible = False
    end
  end
  object BitBtn1: TBitBtn
    Left = 27
    Top = 385
    Width = 90
    Height = 33
    Caption = '&OK'
    Default = True
    TabOrder = 0
    OnClick = BitBtn1Click
    Glyph.Data = {
      BE060000424DBE06000000000000360400002800000024000000120000000100
      0800000000008802000000000000000000000001000000010000000000000000
      BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000C0DCC000F0C8
      A400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
      0303030303030303030303030303030303030303030303030303030303030303
      03030303030303030303030303030303030303030303FF030303030303030303
      03030303030303040403030303030303030303030303030303F8F8FF03030303
      03030303030303030303040202040303030303030303030303030303F80303F8
      FF030303030303030303030303040202020204030303030303030303030303F8
      03030303F8FF0303030303030303030304020202020202040303030303030303
      0303F8030303030303F8FF030303030303030304020202FA0202020204030303
      0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
      040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
      03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
      FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
      0303030303030303030303FA0202020403030303030303030303030303F8FF03
      03F8FF03030303030303030303030303FA020202040303030303030303030303
      0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
      03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
      030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
      0202040303030303030303030303030303F8FF03F8FF03030303030303030303
      03030303FA0202030303030303030303030303030303F8FFF803030303030303
      030303030303030303FA0303030303030303030303030303030303F803030303
      0303030303030303030303030303030303030303030303030303030303030303
      0303}
    NumGlyphs = 2
    Style = bsWin31
  end
  object BitBtn3: TBitBtn
    Left = 557
    Top = 385
    Width = 90
    Height = 33
    HelpContext = 10107
    Caption = '&Help'
    TabOrder = 3
    OnClick = BitBtn3Click
    Style = bsWin31
  end
  object bShowConfigs: TBitBtn
    Left = 147
    Top = 385
    Width = 190
    Height = 33
    Hint = 'Open the Configuration List window'
    Caption = 'Configuration List...'
    TabOrder = 1
    OnClick = bShowConfigsClick
    Glyph.Data = {
      7E010000424D7E01000000000000760000002800000016000000160000000100
      0400000000000801000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
      88888888880088888888888888888888880080000000000000000088880080FF
      F7FFFFFFFFFFF088880080FFF7FFFFFFFFFFF088880080FFF7FFFFFFFFFFF088
      880080777777777777777088880080FFF7FFFFFFFFFFF088880080FFF7FFFFFF
      FFFFF088880080FFF7FFFFFFFFFFF088880080777777777777777088880080FF
      F7FFFFFFFFFFF088880080FFF7FFFFFFFFFFF088880080FFF7FFFFFFFFFFF088
      880080777777777777777088880080FFF7FFFFFFFFFFF088880080FFF7FFFFFF
      FFFFF088880080000000000000000088880080CC08888888880CC08888008000
      0000000000000088880088888888888888888888880088888888888888888888
      8800}
  end
  object BitBtn2: TBitBtn
    Left = 355
    Top = 385
    Width = 190
    Height = 33
    Hint = 'Save the current settings as a New configuration'
    Caption = 'Save Settings As...'
    TabOrder = 2
    OnClick = BitBtn2Click
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FF000000
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00
      FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FF0000000000000000000000000000000000000000000000000000
      00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000808000808000000000
      0000000000000000000000008080000000FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF0000000080800080800080800080800080800080800080800080800000
      00FF00FFFF00FFFF00FF000000000000FF00FF00000000808000808000000000
      0000000000000000008080008080000000FF00FF000000000000FF00FFFF00FF
      FF00FF000000008080000000FF00FFFF00FFFF00FFFF00FF0000000080800000
      00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000008080000000FF00FFFF
      00FFFF00FFFF00FF000000008080000000FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF000000008080000000FF00FFFF00FFFF00FFFF00FF0000000000000000
      00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000008080000000FF00FFFF
      00FFFF00FFFF00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF0000000000000000000000000000000000000000000000000000000000
      00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00
      FFFF00FF000000FF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000}
  end
  object gOther: TGroupBox
    Left = 24
    Top = 542
    Width = 273
    Height = 81
    Caption = 'Other'
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    DesignSize = (
      273
      81)
    object Label7: TLabel
      Left = 12
      Top = 16
      Width = 247
      Height = 42
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 
        '"Other" refers to the settings for the Input Source.  Changes ar' +
        'e made in the Configuration Settings Window or the Workstation C' +
        'onfiguration Editor.'
      WordWrap = True
    end
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 2
    Width = 639
    Height = 371
    ActivePage = tbshSourceFormat
    TabOrder = 7
    object tbshSourceFormat: TTabSheet
      Caption = 'Source/Format'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbCombine: TLabel
        Left = 61
        Top = 3
        Width = 269
        Height = 14
        Caption = 'Combine images from multiple sources as multipage PDF'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 409
        Top = 4
        Width = 219
        Height = 20
        AutoSize = False
        Caption = 'Convert Imported/Scanned image(s) to PDF'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object GLInputSource: TGroupBox
        Left = 12
        Top = 52
        Width = 367
        Height = 229
        HelpContext = 10112
        Caption = 'Source'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        object Label1: TLabel
          Left = 184
          Top = 18
          Width = 159
          Height = 14
          Caption = 'TWAIN Device (scanner/camera)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object pnlTwainSource: TPanel
          Left = 184
          Top = 38
          Width = 173
          Height = 175
          TabOrder = 1
        end
        object pnlImportSource: TPanel
          Left = 14
          Top = 38
          Width = 160
          Height = 175
          TabOrder = 0
          object xxxlbImportMode: TLabel
            Left = 8
            Top = 45
            Width = 66
            Height = 11
            Caption = 'Import Mode'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = [fsBold]
            ParentFont = False
            Visible = False
          end
          object cbImportBatch: TCheckBox
            Left = 89
            Top = 10
            Width = 50
            Height = 17
            Hint = 'Check to enable Batch import of images'
            HelpContext = 10008
            Caption = 'Batch'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = cbImportBatchClick
          end
          object cmbImportMode: TComboBox
            Left = 8
            Top = 62
            Width = 120
            Height = 22
            Style = csDropDownList
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ItemHeight = 0
            ParentFont = False
            TabOrder = 1
            OnChange = cmbImportModeChange
            Items.Strings = (
              'Copy to Server'
              'Convert to DICOM')
          end
        end
        object Import: TRadioButton
          Tag = 50
          Left = 31
          Top = 48
          Width = 57
          Height = 17
          Caption = 'Import'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = ImportClick
        end
        object Twain: TRadioButton
          Tag = 50
          Left = 201
          Top = 143
          Width = 120
          Height = 17
          Caption = 'Twain window'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = TwainClick
        end
        object ScannedDocument: TRadioButton
          Tag = 50
          Left = 201
          Top = 172
          Width = 120
          Height = 22
          Caption = 'ScannedDocument'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = ScannedDocumentClick
        end
        object cbTwainALLPages: TCheckBox
          Left = 202
          Top = 52
          Width = 81
          Height = 17
          Hint = 'Scan a multi page document.'
          Caption = 'MultiPg Doc.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = cbTwainALLPagesClick
        end
        object bTwainSource: TBitBtn
          Left = 192
          Top = 80
          Width = 150
          Height = 19
          Caption = 'Select TWAIN Source ...'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = bTwainSourceClick
          Style = bsWin31
        end
        object btnTwainSettings: TBitBtn
          Left = 192
          Top = 114
          Width = 150
          Height = 20
          Caption = 'TWAIN Settings ...'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnClick = btnTwainSettingsClick
          Style = bsWin31
        end
      end
      object GLImageFormat: TGroupBox
        Left = 388
        Top = 52
        Width = 230
        Height = 229
        HelpContext = 999
        Caption = 'Format'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        object Label6: TLabel
          Left = 10
          Top = 175
          Width = 172
          Height = 14
          Caption = 'For Telereader Consult - convert to:'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Bevel5: TBevel
          Left = 21
          Top = 38
          Width = 187
          Height = 116
        end
        object DocumentG4: TRadioButton
          Tag = 51
          Left = 34
          Top = 86
          Width = 165
          Height = 17
          Caption = 'Document (1bit TIF G4 FAX)'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = DocumentG4Click
        end
        object ImportFormat: TRadioButton
          Tag = 51
          Left = 31
          Top = 124
          Width = 165
          Height = 17
          Caption = 'Use Format of Imported Image.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = ImportFormatClick
        end
        object DICOMFormat: TRadioButton
          Tag = 51
          Left = 22
          Top = 195
          Width = 177
          Height = 17
          Caption = 'DICOM(VL Photo Image Storage)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = DICOMFormatClick
        end
        object PDFImage: TRadioButton
          Left = 124
          Top = 152
          Width = 180
          Height = 17
          Caption = ' PDF (color image)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          Visible = False
          OnClick = PDFImageClick
        end
        object TrueColorJPG: TRadioButton
          Tag = 51
          Left = 31
          Top = 48
          Width = 165
          Height = 17
          Caption = 'True Color      (24bit JPG)'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = TrueColorJPGClick
        end
      end
      object GImageGroup: TGroupBox
        Left = 195
        Top = 292
        Width = 265
        Height = 45
        HelpContext = 10187
        Caption = 'Images Saved as:'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 2
        object ImageGroup: TRadioButton
          Tag = 54
          Left = 16
          Top = 19
          Width = 107
          Height = 17
          Caption = 'Study (Group)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = ImageGroupClick
        end
        object SingleImage: TRadioButton
          Tag = 54
          Left = 158
          Top = 19
          Width = 86
          Height = 17
          Caption = 'Single Image'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = SingleImageClick
        end
      end
      object cbMultipleCapture: TCheckBox
        Tag = 55
        Left = 68
        Top = 29
        Width = 181
        Height = 17
        Caption = 'Multiple Source Capture to PDF'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = cbMultipleCaptureClick
      end
      object cbPDFConvert: TCheckBox
        Tag = 55
        Left = 471
        Top = 29
        Width = 145
        Height = 17
        Caption = 'PDF (Adobe Document)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        OnClick = cbPDFConvertClick
      end
      object btnINitColorPDF: TButton
        Left = 471
        Top = 68
        Width = 125
        Height = 16
        Caption = 'Initialize Color PDF'
        TabOrder = 5
        Visible = False
        OnClick = btnINitColorPDFClick
      end
    end
    object tbshAssociation: TTabSheet
      Caption = 'Association / Mode '
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object GMode: TGroupBox
        Left = 165
        Top = 279
        Width = 251
        Height = 36
        Caption = 'Mode'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        object OnLine: TRadioButton
          Tag = 53
          Left = 6
          Top = 14
          Width = 113
          Height = 17
          Caption = 'OnLine (Live)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = OnLineClick
        end
        object rbtnTestMode: TRadioButton
          Tag = 53
          Left = 106
          Top = 14
          Width = 113
          Height = 17
          Caption = 'Test Mode'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = rbtnTestModeClick
        end
      end
      object GAssociation: TGroupBox
        Left = 84
        Top = 31
        Width = 424
        Height = 219
        HelpContext = 10007
        Caption = 'Association'
        Color = clBtnFace
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        object Bevel1: TBevel
          Left = 30
          Top = 47
          Width = 221
          Height = 149
          Style = bsRaised
        end
        object Bevel4: TBevel
          Left = 268
          Top = 47
          Width = 125
          Height = 149
          Style = bsRaised
        end
        object Label4: TLabel
          Left = 268
          Top = 21
          Width = 57
          Height = 14
          Caption = 'Patient Only'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label3: TLabel
          Left = 30
          Top = 21
          Width = 71
          Height = 14
          Caption = 'VistA Package'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object ClinProc: TRadioButton
          Tag = 52
          Left = 34
          Top = 57
          Width = 113
          Height = 17
          Caption = 'Clinical Procedures'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = ClinProcClick
        end
        object TeleReaderConsult: TRadioButton
          Tag = 52
          Left = 34
          Top = 156
          Width = 117
          Height = 17
          Caption = 'TeleReader Consult'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 9
          OnClick = TeleReaderConsultClick
        end
        object Surgery: TRadioButton
          Tag = 52
          Left = 159
          Top = 57
          Width = 71
          Height = 17
          Caption = 'Surgery'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
          OnClick = SurgeryClick
        end
        object Radiology: TRadioButton
          Tag = 52
          Left = 159
          Top = 90
          Width = 71
          Height = 17
          Caption = 'Radiology'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnClick = RadiologyClick
        end
        object TIU: TRadioButton
          Tag = 52
          Left = 34
          Top = 121
          Width = 94
          Height = 17
          Caption = 'Progress Note'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = TIUClick
        end
        object Medicine: TRadioButton
          Tag = 52
          Left = 159
          Top = 121
          Width = 67
          Height = 17
          Caption = 'Medicine'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = MedicineClick
        end
        object Laboratory: TRadioButton
          Tag = 52
          Left = 34
          Top = 90
          Width = 79
          Height = 17
          Caption = 'Laboratory'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = LaboratoryClick
        end
        object ClinImage: TRadioButton
          Tag = 52
          Left = 282
          Top = 70
          Width = 61
          Height = 19
          Caption = 'Clinical'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = ClinImageClick
        end
        object PhotoID: TRadioButton
          Tag = 52
          Left = 282
          Top = 108
          Width = 69
          Height = 17
          Caption = 'Photo ID'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = PhotoIDClick
        end
        object AdminDoc: TRadioButton
          Tag = 52
          Left = 282
          Top = 144
          Width = 95
          Height = 17
          Hint = 'Administrative Document'
          Caption = 'Administrative'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = AdminDocClick
        end
      end
    end
    object tbshLegacy: TTabSheet
      Caption = 'Legacy'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Lum100choice: TComboBox
        Left = 555
        Top = 307
        Width = 35
        Height = 22
        Style = csDropDownList
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ItemHeight = 0
        ParentFont = False
        TabOrder = 0
        Visible = False
        OnChange = Lum100choiceChange
      end
      object grpLegacySource: TGroupBox
        Left = 25
        Top = 14
        Width = 246
        Height = 265
        Caption = 'Source'
        TabOrder = 1
        object Lumisys75: TRadioButton
          Tag = 50
          Left = 42
          Top = 43
          Width = 129
          Height = 17
          Caption = 'Lumisys 75'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = Lumisys75Click
        end
        object Lumisys150: TRadioButton
          Tag = 50
          Left = 42
          Top = 77
          Width = 107
          Height = 17
          Caption = 'Lumisys 150'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = Lumisys150Click
        end
        object Clipboard: TRadioButton
          Tag = 50
          Left = 42
          Top = 110
          Width = 103
          Height = 17
          Caption = 'ClipBoard'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = ClipboardClick
        end
        object pnlMeteorsettings: TPanel
          Left = 25
          Top = 147
          Width = 198
          Height = 86
          TabOrder = 3
          object cbMeteorInt: TCheckBox
            Left = 102
            Top = 44
            Width = 69
            Height = 17
            Caption = 'Interactive'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = cbMeteorIntClick
          end
          object bMetSettings: TBitBtn
            Left = 102
            Top = 14
            Width = 71
            Height = 19
            Caption = 'Settings ...'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            OnClick = bMetSettingsClick
          end
        end
        object Meteor: TRadioButton
          Tag = 50
          Left = 39
          Top = 156
          Width = 82
          Height = 17
          Caption = 'Meteor/Orion'
          Enabled = False
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = MeteorClick
        end
      end
      object grpLegacyFormat: TGroupBox
        Left = 294
        Top = 14
        Width = 301
        Height = 265
        Caption = 'Format'
        TabOrder = 2
        object Color: TRadioButton
          Tag = 51
          Left = 52
          Top = 31
          Width = 180
          Height = 17
          Caption = 'True Color      (24bit TGA)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = ColorClick
        end
        object ColorScan: TRadioButton
          Tag = 51
          Left = 52
          Top = 61
          Width = 199
          Height = 17
          Caption = '256 Color        (8bit TIF)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = ColorScanClick
        end
        object Xray: TRadioButton
          Tag = 51
          Left = 52
          Top = 92
          Width = 199
          Height = 17
          Caption = 'Xray                (8bit TGA grayScale)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = XrayClick
        end
        object XrayJPG: TRadioButton
          Tag = 51
          Left = 52
          Top = 123
          Width = 199
          Height = 17
          Caption = 'Xray                (8bit JPG grayscale)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = XrayJPGClick
        end
        object BlackandWhite: TRadioButton
          Tag = 51
          Left = 52
          Top = 153
          Width = 199
          Height = 17
          Caption = 'Black && White (8bit TGA grayScale)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = BlackandWhiteClick
        end
        object Document: TRadioButton
          Tag = 51
          Left = 52
          Top = 184
          Width = 199
          Height = 17
          Caption = 'Document (TIF Uncompressed)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = DocumentClick
        end
        object bitmap: TRadioButton
          Tag = 51
          Left = 52
          Top = 215
          Width = 167
          Height = 17
          Caption = 'Bitmap (uncompressed)'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          OnClick = bitmapClick
        end
      end
    end
  end
end
