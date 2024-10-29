object frmCTConfigure: TfrmCTConfigure
  Left = 893
  Top = 204
  BorderStyle = bsSingle
  Caption = 'CT Presets Configuration'
  ClientHeight = 533
  ClientWidth = 465
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object grpPresetsConfig: TGroupBox
    Left = 8
    Top = 0
    Width = 449
    Height = 473
    Caption = 'Non-Hounsfield Units'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 0
    object lblStandardPresets: TLabel
      Left = 8
      Top = 24
      Width = 107
      Height = 16
      Alignment = taCenter
      Caption = 'Standard Presets:'
      Color = clBtnFace
      ParentColor = False
    end
    object lblPresetName: TLabel
      Left = 16
      Top = 48
      Width = 105
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Preset Name:'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
    end
    object lblWindow: TLabel
      Left = 136
      Top = 48
      Width = 105
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Window'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
    end
    object lblLevel: TLabel
      Left = 256
      Top = 48
      Width = 111
      Height = 15
      Alignment = taCenter
      AutoSize = False
      Caption = 'Level'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
    end
    object lblCustomPresets: TLabel
      Left = 8
      Top = 312
      Width = 97
      Height = 16
      Caption = 'Custom Presets:'
      Color = clBtnFace
      ParentColor = False
    end
    object lblCustomName: TLabel
      Left = 16
      Top = 336
      Width = 105
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Preset Name'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
    end
    object lblCustomWindow: TLabel
      Left = 136
      Top = 336
      Width = 105
      Height = 17
      Alignment = taCenter
      AutoSize = False
      Caption = 'Window'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
    end
    object lblCustomLevel: TLabel
      Left = 256
      Top = 336
      Width = 113
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Level'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsUnderline]
      ParentColor = False
      ParentFont = False
    end
    object edtName1: TEdit
      Left = 16
      Top = 72
      Width = 105
      Height = 24
      AutoSize = False
      Color = clMenu
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'Abdomen'
    end
    object edtName2: TEdit
      Left = 16
      Top = 112
      Width = 105
      Height = 24
      AutoSize = False
      Color = clMenu
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 31
      Text = 'Bone'
    end
    object edtName3: TEdit
      Left = 16
      Top = 152
      Width = 105
      Height = 24
      AutoSize = False
      Color = clMenu
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 32
      Text = 'Disk'
    end
    object edtName4: TEdit
      Left = 16
      Top = 192
      Width = 105
      Height = 24
      AutoSize = False
      Color = clMenu
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 33
      Text = 'Head'
    end
    object edtName5: TEdit
      Left = 16
      Top = 232
      Width = 105
      Height = 24
      AutoSize = False
      Color = clMenu
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 34
      Text = 'Lung'
    end
    object edtWindow1: TEdit
      Left = 136
      Top = 72
      Width = 105
      Height = 24
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '350'
    end
    object edtWindow2: TEdit
      Left = 136
      Top = 112
      Width = 105
      Height = 24
      AutoSize = False
      TabOrder = 4
      Text = '500'
    end
    object edtWindow3: TEdit
      Left = 136
      Top = 152
      Width = 105
      Height = 24
      AutoSize = False
      TabOrder = 7
      Text = '950'
    end
    object edtWindow4: TEdit
      Left = 136
      Top = 192
      Width = 105
      Height = 24
      AutoSize = False
      TabOrder = 10
      Text = '80'
    end
    object edtWindow5: TEdit
      Left = 136
      Top = 232
      Width = 105
      Height = 24
      AutoSize = False
      TabOrder = 13
      Text = '1000'
    end
    object edtLevel1: TEdit
      Left = 256
      Top = 72
      Width = 113
      Height = 24
      AutoSize = False
      TabOrder = 2
      Text = '1040'
    end
    object edtLevel2: TEdit
      Left = 256
      Top = 112
      Width = 113
      Height = 24
      AutoSize = False
      TabOrder = 5
      Text = '1274'
    end
    object edtLevel3: TEdit
      Left = 256
      Top = 152
      Width = 113
      Height = 24
      AutoSize = False
      TabOrder = 8
      Text = '1240'
    end
    object edtLevel4: TEdit
      Left = 256
      Top = 192
      Width = 113
      Height = 24
      AutoSize = False
      TabOrder = 11
      Text = '1040'
    end
    object edtLevel5: TEdit
      Left = 256
      Top = 232
      Width = 113
      Height = 24
      AutoSize = False
      TabOrder = 14
      Text = '300'
    end
    object edtName6: TEdit
      Left = 16
      Top = 272
      Width = 105
      Height = 24
      AutoSize = False
      Color = clMenu
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 35
      Text = 'Mediastinum'
    end
    object edtWindow6: TEdit
      Left = 136
      Top = 272
      Width = 105
      Height = 24
      AutoSize = False
      TabOrder = 16
      Text = '500'
    end
    object edtLevel6: TEdit
      Left = 256
      Top = 272
      Width = 113
      Height = 24
      AutoSize = False
      TabOrder = 17
      Text = '1040'
    end
    object edtName7: TEdit
      Left = 16
      Top = 360
      Width = 105
      Height = 24
      AutoSize = False
      MaxLength = 12
      TabOrder = 19
    end
    object edtName8: TEdit
      Left = 16
      Top = 400
      Width = 105
      Height = 24
      AutoSize = False
      MaxLength = 12
      TabOrder = 23
    end
    object edtName9: TEdit
      Left = 16
      Top = 440
      Width = 105
      Height = 24
      AutoSize = False
      MaxLength = 12
      TabOrder = 27
    end
    object edtWindow7: TEdit
      Left = 136
      Top = 360
      Width = 105
      Height = 24
      AutoSize = False
      TabOrder = 20
    end
    object edtLevel7: TEdit
      Left = 256
      Top = 360
      Width = 113
      Height = 24
      AutoSize = False
      TabOrder = 21
    end
    object edtWindow8: TEdit
      Left = 136
      Top = 400
      Width = 105
      Height = 24
      AutoSize = False
      TabOrder = 24
    end
    object edtLevel8: TEdit
      Left = 256
      Top = 400
      Width = 113
      Height = 24
      AutoSize = False
      TabOrder = 25
    end
    object edtWindow9: TEdit
      Left = 136
      Top = 440
      Width = 105
      Height = 24
      AutoSize = False
      TabOrder = 28
    end
    object edtLevel9: TEdit
      Left = 256
      Top = 440
      Width = 113
      Height = 24
      AutoSize = False
      TabOrder = 29
    end
    object btnTestAbdomen: TButton
      Left = 384
      Top = 72
      Width = 51
      Height = 25
      Hint = 
        'Click Here to see the effect these Window/Level values have on t' +
        'he image'
      Caption = 'Test'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnTestAbdomenClick
    end
    object btnTestBone: TButton
      Left = 384
      Top = 112
      Width = 49
      Height = 25
      Hint = 
        'Click Here to see the effect these Window/Level values have on t' +
        'he image'
      Caption = 'Test'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = btnTestBoneClick
    end
    object btnTestDisk: TButton
      Left = 384
      Top = 152
      Width = 49
      Height = 25
      Hint = 
        'Click Here to see the effect these Window/Level values have on t' +
        'he image'
      Caption = 'Test'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = btnTestDiskClick
    end
    object btnTestHead: TButton
      Left = 384
      Top = 192
      Width = 49
      Height = 25
      Hint = 
        'Click Here to see the effect these Window/Level values have on t' +
        'he image'
      Caption = 'Test'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      OnClick = btnTestHeadClick
    end
    object btnTestLung: TButton
      Left = 384
      Top = 232
      Width = 49
      Height = 25
      Hint = 
        'Click Here to see the effect these Window/Level values have on t' +
        'he image'
      Caption = 'Test'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      OnClick = btnTestLungClick
    end
    object btnTestMediastinum: TButton
      Left = 384
      Top = 272
      Width = 49
      Height = 25
      Hint = 
        'Click Here to see the effect these Window/Level values have on t' +
        'he image'
      Caption = 'Test'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 18
      OnClick = btnTestMediastinumClick
    end
    object btnTestCustom1: TButton
      Left = 384
      Top = 360
      Width = 49
      Height = 25
      Hint = 
        'Click Here to see the effect these Window/Level values have on t' +
        'he image'
      Caption = 'Test'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 22
      OnClick = btnTestCustom1Click
    end
    object btnTestCustom2: TButton
      Left = 384
      Top = 400
      Width = 49
      Height = 25
      Hint = 
        'Click Here to see the effect these Window/Level values have on t' +
        'he image'
      Caption = 'Test'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 26
      OnClick = btnTestCustom2Click
    end
    object btnTestCustom3: TButton
      Left = 384
      Top = 440
      Width = 49
      Height = 25
      Hint = 
        'Click Here to see the effect these Window/Level values have on t' +
        'he image'
      Caption = 'Test'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 30
      OnClick = btnTestCustom3Click
    end
  end
  object grpButtons: TGroupBox
    Left = 8
    Top = 472
    Width = 449
    Height = 57
    TabOrder = 1
    object btnPreview: TButton
      Left = 16
      Top = 16
      Width = 105
      Height = 25
      Hint = 
        'Click here to save your values locally and return to the Radiolo' +
        'gy viewer.'
      Caption = '&Preview'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnPreviewClick
    end
    object btnSaveForSite: TButton
      Left = 120
      Top = 16
      Width = 105
      Height = 25
      Hint = 'Save the CT settings for the site'
      Caption = '&Save For Site'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnSaveForSiteClick
    end
    object btnDefaultValues: TButton
      Left = 224
      Top = 16
      Width = 105
      Height = 25
      Hint = 
        'Reset the Preset CT settings to their default values (will not e' +
        'ffect Custom Presets).'
      Caption = 'Default Values'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnDefaultValuesClick
    end
    object btnCancel: TButton
      Left = 328
      Top = 16
      Width = 105
      Height = 25
      Hint = 'Cancel this dialog without saving the changes'
      Caption = '&Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnCancelClick
    end
    object btnClearDatabase: TButton
      Left = 248
      Top = 40
      Width = 81
      Height = 17
      Caption = 'Clear Database'
      TabOrder = 4
      Visible = False
    end
  end
end
