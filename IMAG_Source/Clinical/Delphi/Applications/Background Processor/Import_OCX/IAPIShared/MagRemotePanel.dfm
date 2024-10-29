object fMagRemotePanel: TfMagRemotePanel
  Left = 0
  Top = 0
  Width = 320
  Height = 30
  TabOrder = 0
  object pRIV: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 30
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
  end
  object Button1: TButton
    Left = 120
    Top = 0
    Width = 81
    Height = 25
    Caption = 'Aline'#39's Button'
    TabOrder = 1
    Visible = False
    OnClick = Button1Click
  end
  object PopupMenu1: TPopupMenu
    Left = 240
    Top = 8
    object mnuSiteName: TMenuItem
      Enabled = False
    end
    object mnuBar1: TMenuItem
      Caption = '-'
    end
    object mnuCloseConnection: TMenuItem
      Caption = 'Close Connection'
      OnClick = mnuCloseConnectionClick
    end
    object mnuOpenConnection: TMenuItem
      Caption = 'Open Connection'
      OnClick = mnuOpenConnectionClick
    end
  end
end
