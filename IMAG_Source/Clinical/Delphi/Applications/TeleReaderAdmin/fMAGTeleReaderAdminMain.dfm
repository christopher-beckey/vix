object frmTeleReaderAdmin: TfrmTeleReaderAdmin
  Left = 535
  Top = 390
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'TeleReader Configurator'
  ClientHeight = 239
  ClientWidth = 742
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMainClient: TPanel
    Left = 0
    Top = 0
    Width = 742
    Height = 239
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      742
      239)
    object btnAcquisition: TButton
      Left = 246
      Top = 50
      Width = 250
      Height = 25
      Hint = 'Add/Edit/Delete Consult Types to be added to the Unread List.'
      Anchors = [akTop]
      Caption = 'Ac&quisition Site Setup'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnAcquisitionClick
    end
    object btnReader: TButton
      Left = 246
      Top = 90
      Width = 250
      Height = 25
      Hint = 
        'Add/Edit/Delete Consult Types to be added to the DICOM Gateway M' +
        'odality Worklist'
      Anchors = [akTop]
      Caption = '&Reading Site Setup'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnReaderClick
    end
    object btnExit: TButton
      Left = 246
      Top = 170
      Width = 250
      Height = 25
      Hint = 'Quit TeleReader Configuration'
      Anchors = [akTop]
      Caption = 'E&xit'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btnExitClick
    end
    object btnSettings: TButton
      Left = 246
      Top = 130
      Width = 250
      Height = 25
      Hint = 'Set TeleReader Application Wide Settings'
      Anchors = [akTop]
      Caption = ' Global &Settings'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnSettingsClick
    end
    object pnlTop: TPanel
      Left = 1
      Top = 1
      Width = 740
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 4
    end
  end
  object MainMenu1: TMainMenu
    Left = 32
    Top = 168
    object miFile: TMenuItem
      AutoHotkeys = maManual
      Caption = '&File'
      object miAcquisition: TMenuItem
        Caption = 'Ac&quisition Site Setup'
        OnClick = btnAcquisitionClick
      end
      object miReader: TMenuItem
        Caption = '&Reading Site Setup'
        OnClick = btnReaderClick
      end
      object miSettings: TMenuItem
        Caption = 'Global &Settings'
        OnClick = btnSettingsClick
      end
      object miExit: TMenuItem
        Caption = 'E&xit'
        OnClick = btnExitClick
      end
    end
    object miHelp: TMenuItem
      AutoHotkeys = maManual
      Caption = '&Help'
      object miContents: TMenuItem
        Caption = '&Contents'
        OnClick = miContentsClick
      end
      object miMessageLog: TMenuItem
        Caption = 'Message &Log'
        OnClick = miMessageLogClick
      end
      object miAbout: TMenuItem
        Caption = '&About...'
        OnClick = miAboutClick
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 32
    Top = 32
  end
  object amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmTeleReaderAdmin'
        'Status = stsDefault'))
  end
end
