object frmRadHeaderProgress: TfrmRadHeaderProgress
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Header Load Progress'
  ClientHeight = 183
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  DesignSize = (
    356
    183)
  PixelsPerInch = 96
  TextHeight = 13
  object lblStatus: TLabel
    Left = 0
    Top = 88
    Width = 356
    Height = 41
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = 'text'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
  end
  object lblDescription: TLabel
    Left = 0
    Top = 0
    Width = 356
    Height = 73
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'Loading the header information for all images in the selected st' +
      'udy. This is necessary for viewing scout lines. Pressing the can' +
      'cel button below will make the study load faster but will disabl' +
      'e scout line functionality'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 166
    Width = 356
    Height = 17
    Align = alBottom
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 146
    Top = 135
    Width = 75
    Height = 25
    Anchors = []
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
end
