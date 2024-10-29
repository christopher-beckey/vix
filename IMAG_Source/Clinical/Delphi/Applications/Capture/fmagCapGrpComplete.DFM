object frmCapGrpComplete: TfrmCapGrpComplete
  Left = 603
  Top = 326
  Width = 581
  Height = 399
  BorderIcons = [biSystemMenu]
  Caption = 'Study Group is Complete'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = [fsBold]
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 14
  object lbAlign: TLabel
    Left = 560
    Top = 375
    Width = 13
    Height = 14
    AutoSize = False
    Color = clRed
    ParentColor = False
    Visible = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 299
    Width = 573
    Height = 66
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object OKBtn: TBitBtn
      Left = 113
      Top = 18
      Width = 90
      Height = 30
      TabOrder = 0
      Kind = bkOK
      Margin = 2
      Style = bsWin31
      Spacing = -1
      IsControl = True
    end
    object CancelBtn: TBitBtn
      Left = 237
      Top = 18
      Width = 90
      Height = 30
      TabOrder = 1
      Kind = bkCancel
      Margin = 2
      Style = bsWin31
      Spacing = -1
      IsControl = True
    end
    object HelpBtn: TBitBtn
      Left = 361
      Top = 18
      Width = 90
      Height = 30
      Caption = 'HelpBtn'
      Enabled = False
      TabOrder = 2
      Kind = bkHelp
      Margin = 2
      Style = bsWin31
      Spacing = -1
      IsControl = True
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 573
    Height = 299
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    BorderWidth = 10
    TabOrder = 1
    object Panel3: TPanel
      Left = 12
      Top = 12
      Width = 549
      Height = 153
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lbprompt: TLabel
        Left = 16
        Top = 16
        Width = 523
        Height = 61
        AutoSize = False
        WordWrap = True
      end
      object Label1: TLabel
        Left = 16
        Top = 88
        Width = 246
        Height = 14
        Caption = 'Study Group Short description: (60 char max)'
      end
      object lbDicom: TLabel
        Left = 292
        Top = 88
        Width = 28
        Height = 16
        Caption = '       '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 16
        Top = 131
        Width = 168
        Height = 14
        Caption = 'Study Group Long description:'
      end
      object egroupdesc: TEdit
        Left = 16
        Top = 105
        Width = 523
        Height = 22
        MaxLength = 60
        TabOrder = 0
      end
      object CheckBox1: TCheckBox
        Left = 230
        Top = 130
        Width = 97
        Height = 17
        Caption = 'word wrap'
        TabOrder = 1
        OnClick = CheckBox1Click
      end
    end
    object Panel4: TPanel
      Left = 12
      Top = 165
      Width = 549
      Height = 122
      Align = alClient
      TabOrder = 1
      object grouplongdesc: TMemo
        Left = 1
        Top = 1
        Width = 547
        Height = 120
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
end
