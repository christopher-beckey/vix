object Mag4VGear: TMag4VGear
  Left = 0
  Top = 0
  Width = 669
  Height = 295
  Color = 12762528
  ParentColor = False
  TabOrder = 0
  OnEndDrag = FrameEndDrag
  OnMouseMove = FrameMouseMove
  OnMouseUp = FrameMouseUp
  OnMouseWheelDown = FrameMouseWheelDown
  OnMouseWheelUp = FrameMouseWheelUp
  OnStartDrag = FrameStartDrag
  DesignSize = (
    669
    295)
  object pnlImage: TPanel
    Left = 4
    Top = 0
    Width = 659
    Height = 286
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'pnlImage'
    ParentColor = True
    TabOrder = 0
    object Bevel1: TBevel
      Left = 0
      Top = 21
      Width = 655
      Height = 2
      Align = alTop
      Shape = bsTopLine
    end
    object lbImageStatus: TLabel
      Left = 0
      Top = 39
      Width = 655
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = '<Image status>'
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      Transparent = False
      Visible = False
    end
    object pnlHeader: TPanel
      Left = 0
      Top = 23
      Width = 655
      Height = 16
      Align = alTop
      Caption = ' Image Group'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Small Fonts'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Visible = False
      DesignSize = (
        655
        16)
      object btn1to1: TSpeedButton
        Left = 631
        Top = -6
        Width = 23
        Height = 21
        Anchors = [akRight, akBottom]
        Flat = True
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          888888888888888888888888888888888888888888888888888888C888888888
          888C88C888888888888C88C888888888888C88C888C88C88888C88C88CCCCCC8
          888C88C888C88C88888CCCC8888888888CCC8CC88888888888CC88C888888888
          888C888888888888888888888888888888888888888888888888}
        Transparent = False
        Visible = False
        OnClick = btn1to1Click
      end
      object btnDownArrow: TSpeedButton
        Left = 608
        Top = -6
        Width = 23
        Height = 21
        Hint = 'Next'
        Anchors = [akRight, akBottom]
        Flat = True
        Glyph.Data = {
          DE000000424DDE0000000000000076000000280000000C0000000D0000000100
          04000000000068000000C40E0000C40E00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          0000888888888888000088888888888800008888888888880000888888888888
          0000888880888888000088880008888800008880000088880000880000000888
          0000888888888888000088888888888800008888888888880000888888888888
          0000}
        Transparent = False
        Visible = False
        OnClick = btnDownArrowClick
      end
    end
    object pnlDesc: TPanel
      Left = 0
      Top = 0
      Width = 655
      Height = 21
      Align = alTop
      BevelOuter = bvNone
      Constraints.MinHeight = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object lblImage: TLabel
        Left = 68
        Top = -2
        Width = 171
        Height = 15
        AutoSize = False
        Caption = '<image description>'
        OnDblClick = lblImageDblClick
        OnMouseDown = lblImageMouseDown
        OnMouseMove = lblImageMouseMove
        OnMouseEnter = lblImageMouseEnter
        OnMouseLeave = lblImageMouseLeave
      end
      object lblDescIndex: TLabel
        Left = 0
        Top = 0
        Width = 37
        Height = 13
        Align = alLeft
        Caption = '<index>'
      end
      object pnlClose: TPanel
        Left = 580
        Top = 0
        Width = 75
        Height = 21
        Align = alRight
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        object lblDescPage: TLabel
          Left = 0
          Top = 0
          Width = 53
          Height = 21
          Align = alLeft
          AutoSize = False
          Caption = '<page>'
          Layout = tlCenter
        end
        object btnCloseImage: TSpeedButton
          Left = 53
          Top = 0
          Width = 20
          Height = 20
          Hint = 'Close Image'
          Flat = True
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B0040000000000000000000000000000000000004080FF4080FF
            4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080
            FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4080FF4080FFFFFFFFCB6B0ACB6B0ACB6B
            0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB
            6B0ACB6B0ACB6B0AFFFFFF4080FF4080FFFFFFFFCB6B0A4080FF4080FF4080FF
            4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080
            FFCB6B0AFFFFFF4080FF4080FFFFFFFFCB6B0A4080FF4080FF4080FF0A0A9A40
            80FF4080FF4080FF4080FF4080FF4080FF0A0A9A4080FF4080FF4080FFCB6B0A
            FFFFFF4080FF4080FFFFFFFFCB6B0A4080FF4080FF0A0A9A0A1DC20A0A9A4080
            FF4080FF4080FF4080FF0A0A9A0A1DC20A0A9A4080FF4080FFCB6B0AFFFFFF40
            80FF4080FFFFFFFFCB6B0A4080FF0A0A9A0A29D90A1DC20A1DC20A0A9A4080FF
            4080FF0A0A9A0A29D90A1DC20A1DC20A0A9A4080FFCB6B0AFFFFFF4080FF4080
            FFFFFFFFCB6B0A4080FF4080FF0A0A9A0A29D90A29D90A29D90A0A9A0A0A9A0A
            29D90A29D90A29D90A0A9A4080FF4080FFCB6B0AFFFFFF4080FF4080FFFFFFFF
            CB6B0A4080FF4080FF4080FF0A0A9A0A2FE60A2FE60A2FE60A2FE60A29D90A2F
            E60A0A9A4080FF4080FF4080FFCB6B0AFFFFFF4080FF4080FFFFFFFFCB6B0A40
            80FF4080FF4080FF4080FF0A0A9A0A29D90A2FE60A2FE60A2FE60A0A9A4080FF
            4080FF4080FF4080FFCB6B0AFFFFFF4080FF4080FFFFFFFFCB6B0A4080FF4080
            FF4080FF4080FF0A0A9A0A2FE60A2FE60A2FE60A2FE60A0A9A4080FF4080FF40
            80FF4080FFCB6B0AFFFFFF4080FF4080FFFFFFFFCB6B0A4080FF4080FF4080FF
            0A0A9A0A29D90A2FE60A29D90A2FE60A2FE60A2FE60A0A9A4080FF4080FF4080
            FFCB6B0AFFFFFF4080FF4080FFFFFFFFCB6B0A4080FF4080FF0A0A9A0A29D90A
            2FE60A2FE60A0A9A0A0A9A0A29D90A2FE60A2FE60A0A9A4080FF4080FFCB6B0A
            FFFFFF4080FF4080FFFFFFFFCB6B0A4080FF0A0A9A0A29D90A2FE60A2FE60A0A
            9A4080FF4080FF0A0A9A0A29D90A2FE60A2FE60A0A9A4080FFCB6B0AFFFFFF40
            80FF4080FFFFFFFFCB6B0A4080FF4080FF0A0A9A0A2FE60A0A9A4080FF4080FF
            4080FF4080FF0A0A9A0A29D90A0A9A4080FF4080FFCB6B0AFFFFFF4080FF4080
            FFFFFFFFCB6B0A4080FF4080FF4080FF0A0A9A4080FF4080FF4080FF4080FF40
            80FF4080FF0A0A9A4080FF4080FF4080FFCB6B0AFFFFFF4080FF4080FFFFFFFF
            CB6B0A4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080
            FF4080FF4080FF4080FF4080FFCB6B0AFFFFFF4080FF4080FFFFFFFFCB6B0ACB
            6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0ACB6B0A
            CB6B0ACB6B0ACB6B0ACB6B0AFFFFFF4080FF4080FFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFF4080FF4080FF4080FF4080FF4080FF4080FF4080FF
            4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080
            FF4080FF4080FF4080FF}
          Layout = blGlyphTop
          OnClick = btnCloseImageClick
        end
      end
    end
    object pnlRadiology: TPanel
      Left = 0
      Top = 265
      Width = 655
      Height = 17
      Align = alBottom
      Alignment = taLeftJustify
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 2
    end
  end
end
