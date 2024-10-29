object fMagRemoteToolbar: TfMagRemoteToolbar
  Left = 0
  Top = 0
  Width = 511
  Height = 32
  TabOrder = 0
  object pnlConfig: TPanel
    Left = 0
    Top = 26
    Width = 65
    Height = 0
    BevelInner = bvLowered
    TabOrder = 0
    Visible = False
    object btnConfigure: TBitBtn
      Left = 0
      Top = 0
      Width = 65
      Height = 26
      Caption = 'Configure'
      TabOrder = 0
      OnClick = btnConfigureClick
    end
  end
  object pToolbar: TPanel
    Left = 0
    Top = 26
    Width = 511
    Height = 6
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 1
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 511
    Height = 26
    AutoSize = True
    Caption = 'ToolBar1'
    TabOrder = 2
  end
end
