object frmCapSettings: TfrmCapSettings
  Left = -2151
  Top = 274
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'User Session settings'
  ClientHeight = 441
  ClientWidth = 453
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 10
    Width = 453
    Height = 392
    BevelOuter = bvNone
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
    object pgctrlSettings: TPageControl
      Left = 5
      Top = 5
      Width = 443
      Height = 382
      ActivePage = tbshImport
      Align = alClient
      TabOrder = 0
      OnChange = pgctrlSettingsChange
      object tbshtAutoSettings: TTabSheet
        Caption = 'Auto- Settings'
        object lbAutoSelect: TLabel
          Left = 82
          Top = 96
          Width = 227
          Height = 13
          Caption = 'when only one list item matches keyboard input'
        end
        object lbAutoOpen: TLabel
          Left = 82
          Top = 150
          Width = 248
          Height = 13
          Caption = ' when the edit box of a list control gets input focus.'
        end
        object lbAutoTab: TLabel
          Left = 82
          Top = 46
          Width = 331
          Height = 13
          AutoSize = False
          Caption = 
            'when <enter> is pressed in an edit box, or a list item is select' +
            'ed'
          WordWrap = True
        end
        object chkAutoSelect: TCheckBox
          Left = 68
          Top = 80
          Width = 223
          Height = 17
          Hint = 
            'Automatically select a List entry when only one matches keyboard' +
            ' imput'
          Caption = 'Automatically select that List item'
          TabOrder = 0
        end
        object chkAutoTab: TCheckBox
          Left = 68
          Top = 28
          Width = 191
          Height = 17
          Hint = 'Automatically Tab to next control'
          Caption = 'Automatically Tab to next control'
          TabOrder = 1
        end
        object chkAutoOpen: TCheckBox
          Left = 68
          Top = 132
          Width = 179
          Height = 17
          Caption = 'Open the selection list'
          TabOrder = 2
        end
        object chkAutoExpand: TCheckBox
          Left = 340
          Top = 116
          Width = 97
          Height = 17
          Caption = 'chkAutoExpand'
          Enabled = False
          TabOrder = 3
          Visible = False
        end
        object pnlAutoSettings2: TPanel
          Left = 7
          Top = 184
          Width = 433
          Height = 161
          BevelInner = bvLowered
          TabOrder = 4
          Visible = False
          object lbAutoDeskew: TLabel
            Left = 74
            Top = 36
            Width = 162
            Height = 13
            Caption = 'after scanning a TIF file  (G4 Fax)'
          end
          object lbAutoDeSpeckle: TLabel
            Left = 74
            Top = 84
            Width = 162
            Height = 13
            Caption = 'after scanning a TIF file  (G4 Fax)'
          end
          object lbAutoPreviewNote: TLabel
            Left = 74
            Top = 132
            Width = 286
            Height = 13
            Caption = 'when a Note is selected in the Select Progress Note window'
          end
          object chkAutoDeskew: TCheckBox
            Left = 64
            Top = 16
            Width = 225
            Height = 17
            Caption = 'Auto Deskew Scanned TIF File'
            TabOrder = 0
          end
          object chkAutoDeSpeckle: TCheckBox
            Left = 64
            Top = 64
            Width = 265
            Height = 17
            Caption = 'Auto DeSpeckle Scanned TIF File'
            TabOrder = 1
          end
          object chkAutoPreviewNote: TCheckBox
            Left = 64
            Top = 112
            Width = 241
            Height = 17
            Caption = 'Auto Preview Note'
            TabOrder = 2
          end
        end
      end
      object tbshtZoomScrollSettings: TTabSheet
        Caption = 'Scroll Bar and Zoom Settings'
        OnMouseMove = tbshtZoomScrollSettingsMouseMove
        object Label6: TLabel
          Left = 0
          Top = 0
          Width = 435
          Height = 33
          Align = alTop
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'When an Image is displayed in the Capture Window Image Box, appl' +
            'y the selected Settings           (Settings include: Horizontal ' +
            'and Vertical Scroll bar positions and Zoom)'
          WordWrap = True
        end
        object lblHoriz: TLabel
          Left = 30
          Top = 146
          Width = 52
          Height = 13
          Caption = 'Horizontal:'
        end
        object lblVert: TLabel
          Left = 141
          Top = 146
          Width = 39
          Height = 13
          Caption = 'Vertical:'
        end
        object lblHorizD: TLabel
          Left = 85
          Top = 146
          Width = 6
          Height = 13
          Caption = '0'
        end
        object lblVertD: TLabel
          Left = 186
          Top = 146
          Width = 6
          Height = 13
          Caption = '0'
        end
        object lblZoom: TLabel
          Left = 240
          Top = 146
          Width = 26
          Height = 13
          Caption = 'Zoom'
        end
        object lblZoomD: TLabel
          Left = 280
          Top = 146
          Width = 6
          Height = 13
          Caption = '0'
        end
        object lblZoompos: TLabel
          Left = 90
          Top = 186
          Width = 80
          Height = 13
          Caption = 'Always Zoom to:'
        end
        object lblZoomposD: TLabel
          Left = 174
          Top = 186
          Width = 6
          Height = 13
          Caption = '0'
        end
        object lblPositional: TLabel
          Left = 38
          Top = 300
          Width = 133
          Height = 34
          AutoSize = False
          Caption = 'Always scroll to a certain area of the image:'
          WordWrap = True
        end
        object Bevel1: TBevel
          Left = 0
          Top = 33
          Width = 435
          Height = 2
          Align = alTop
        end
        object chkSaveOnCapture: TRadioButton
          Left = 14
          Top = 84
          Width = 219
          Height = 17
          Caption = 'Repeat settings of last displayed image.  '
          TabOrder = 1
          OnClick = chkSaveOnCaptureClick
        end
        object chkUseStatic: TRadioButton
          Left = 14
          Top = 122
          Width = 153
          Height = 17
          Caption = 'Always use these settings:'
          TabOrder = 2
          OnClick = chkUseStaticClick
        end
        object btnGetCurrentSettings: TButton
          Left = 204
          Top = 122
          Width = 111
          Height = 17
          Caption = 'Get Current Settings'
          TabOrder = 3
          OnClick = btnGetCurrentSettingsClick
        end
        object chkFitToWin: TRadioButton
          Left = 14
          Top = 51
          Width = 199
          Height = 17
          Caption = 'Use Fit to Window Setting.'
          TabOrder = 0
          OnClick = chkFitToWinClick
        end
        object chkPositional: TRadioButton
          Left = 14
          Top = 184
          Width = 75
          Height = 17
          Caption = 'Positional'
          TabOrder = 4
          OnClick = chkPositionalClick
        end
        object btnGetCurrentZoom: TButton
          Left = 202
          Top = 184
          Width = 111
          Height = 17
          Caption = 'Get Current Zoom'
          TabOrder = 5
          OnClick = btnGetCurrentZoomClick
        end
        object pnlPositional: TPanel
          Left = 186
          Top = 213
          Width = 135
          Height = 133
          BevelInner = bvLowered
          Color = clGrayText
          TabOrder = 11
          OnMouseDown = pnlPositionalMouseDown
          OnMouseMove = pnlPositionalMouseMove
          object lblmove: TLabel
            Left = 2
            Top = 2
            Width = 131
            Height = 129
            Cursor = crHandPoint
            Align = alClient
            AutoSize = False
            Caption = 'Bottom Right'
            Color = clInactiveBorder
            Font.Charset = ANSI_CHARSET
            Font.Color = clWhite
            Font.Height = -11
            Font.Name = 'Arial'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            Transparent = True
            Layout = tlBottom
            Visible = False
            WordWrap = True
            OnMouseDown = lblmoveMouseDown
            OnMouseMove = pnlPositionalMouseMove
          end
          object lblArea: TLabel
            Left = 81
            Top = 89
            Width = 51
            Height = 41
            Alignment = taCenter
            AutoSize = False
            Caption = 'Bottom Right'
            Color = clHighlightText
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Small Fonts'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            Layout = tlCenter
            WordWrap = True
          end
        end
        object Panel3: TPanel
          Left = 330
          Top = 235
          Width = 101
          Height = 101
          Caption = 'Panel3'
          TabOrder = 12
          Visible = False
          object chkPosTL: TRadioButton
            Left = 16
            Top = 19
            Width = 65
            Height = 17
            Caption = 'Top Left'
            TabOrder = 0
            OnClick = chkPosTLClick
          end
          object chkPosTR: TRadioButton
            Left = 14
            Top = 4
            Width = 67
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Top Right'
            TabOrder = 1
            OnClick = chkPosTRClick
          end
          object chkPosC: TRadioButton
            Left = 14
            Top = 34
            Width = 57
            Height = 17
            Caption = 'Center'
            TabOrder = 2
            OnClick = chkPosCClick
          end
          object chkPosBR: TRadioButton
            Left = 12
            Top = 49
            Width = 79
            Height = 17
            Alignment = taLeftJustify
            Caption = 'Bottom Right'
            TabOrder = 3
            OnClick = chkPosBRClick
          end
          object chkPosBL: TRadioButton
            Left = 12
            Top = 64
            Width = 79
            Height = 17
            Caption = 'Bottom Left'
            TabOrder = 4
            OnClick = chkPosBLClick
          end
        end
        object btnTL: TBitBtn
          Left = 35
          Top = 230
          Width = 24
          Height = 24
          TabOrder = 6
          OnClick = btnTLClick
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF99A8AC0000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000
            FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
            00000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF
            0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000000000
            FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000008000008000000000FFFFFFFF
            FFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000008000008000008000008000000000FFFFFFFFFFFFFFFF
            FFFFFFFF99A8ACFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF00
            8000008000008000008000008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF
            99A8ACFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF
            00008000008000008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF
            FF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00
            FFFFFF008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF
            00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FF
            FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF
            0000FF0000FF0000FF0000FFFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFF
            FF000000FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000000000FF271613000000FF
            00002716130000FFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00000000
            FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF000000271613FF00000000002716
            130000FFFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF000000FFFFFFFF
            FFFFFFFFFFFFFFFF0000FF0000000000FF0000002716132716130000FF0000FF
            FFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00000000FFFFFFFFFFFFFFFF
            FFFFFFFF0000FF0000FF0000000000FF0000000000FF0000000000FFFFFFFFFF
            FF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
            0000FF0000000000FF0000000000FF0000000000FF0000FFFFFF00FFFFFFFFFF
            00FFFFFFFFFF00FFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000FF99A8AC99A8AC99A8AC99A8AC
            99A8AC99A8AC99A8AC99A8ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF}
          Layout = blGlyphBottom
        end
        object btnTR: TBitBtn
          Left = 61
          Top = 230
          Width = 24
          Height = 24
          TabOrder = 7
          OnClick = btnTRClick
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF99A8AC0000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000
            FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
            00000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF
            0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000000000
            FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000008000008000000000FFFFFFFF
            FFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000008000008000008000008000000000FFFFFFFFFFFFFFFF
            FFFFFFFF99A8ACFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF00
            8000008000008000008000008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF
            99A8ACFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF
            00008000008000008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF
            FF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00
            FFFFFF008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF
            00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FF
            FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFF00FFFFFFFFFF00
            D8E9ECD8E9ECFFFFFFFFFF000000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF00D8E9ECFFFFFF00
            FFFFD8E9ECFFFFFF0000FF0000000000FF0000000000FF0000000000FF0000FF
            FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFF00FFFFFFD8E9EC00FFFFFFFFFFD8E9
            ECFFFF000000FF0000FF0000000000FF0000000000FF0000000000FFFFFFFFFF
            FFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF00FFFFFFD8E9ECD8E9ECFFFF00FFFFFF
            0000FF0000000000FF0000000000FF0000000000FF0000FFFFFFFFFFFFFFFFFF
            FFFFFFFF99A8ACFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF000000FF00
            00FF0000000000FF0000000000FF0000000000FFFFFFFFFFFFFFFFFFFFFFFFFF
            99A8ACFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF0000FF0000000000
            FF0000000000FF0000000000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF99A8AC99
            A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC0000FF0000FF0000FF0000FF
            0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF}
        end
        object btnCenter: TBitBtn
          Left = 87
          Top = 230
          Width = 24
          Height = 24
          TabOrder = 8
          OnClick = btnCenterClick
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF99A8AC0000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000
            FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF00
            00000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF
            0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000000000
            FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF0000FF00
            00FF0000FF0000FF0000FF0000FF0000FF0000008000008000000000FFFFFFFF
            FFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF0000FF0000FF0000
            FF0000FF0000FF0000008000008000008000008000000000FFFFFFFFFFFFFFFF
            FFFFFFFF99A8ACFFFF00FFFFFFFFFF000000FF0000FF0000FF0000FF0000FF00
            00FF0000FF0000FF008000008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF
            99A8ACFFFFFFFFFF00FFFFFF0000FF0000000000FF0000000000FF0000000000
            FF0000FF008000008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF
            FF00FFFFFFFFFF000000FF0000FF0000000000FF0000000000FF0000000000FF
            FFFFFF008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF
            00FFFFFF0000FF0000000000FF0000000000FF0000000000FF0000FFFFFF00FF
            FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFF00FFFFFFFFFF00
            0000FF2716130000000000FF0000000000FF0000000000FFFFFFFFFFFF00FFFF
            FF000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF00D8E9EC0000FFFF
            00002716130000000000FF0000000000FF0000FFFFFF00FFFFFFFFFF00000000
            FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFF00FFFFFFD8E9EC0000FF0000FF0000
            FF0000FF0000FF0000FF0000FF0000FFFFFFFFFFFF00FFFFFF000000FFFFFFFF
            FFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF00FFFFFFD8E9ECD8E9ECFFFF00FFFFFF
            FFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00000000FFFFFFFFFFFFFFFF
            FFFFFFFF99A8ACFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFF
            FF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
            99A8ACFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF
            00FFFFFFFFFF00FFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF99A8AC99
            A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC
            99A8AC99A8AC99A8AC99A8ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF}
        end
        object btnBL: TBitBtn
          Left = 113
          Top = 230
          Width = 24
          Height = 24
          TabOrder = 9
          OnClick = btnBLClick
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000
            FF0000FF0000FF0000FF0000FF0000FF00000000000000000000000000000000
            0000000000000000FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000000000FF271613
            000000FF00002716130000FFFF0000FF0000FF0000FF0000FF0000FF0000FF00
            00000000FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF000000271613FF000000
            00002716130000FFFF0000FF0000FF0000FF0000FF0000FF0000FF0000000000
            FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000000000FF0000002716132716130000
            FF0000FFFF0000FF0000FF0000FF0000FF0000008000008000000000FFFFFFFF
            FFFFFFFFFFFFFFFF0000FF0000FF0000000000FF0000000000FF0000000000FF
            FF0000FF0000FF0000008000008000008000008000000000FFFFFFFFFFFFFFFF
            FFFFFFFF0000FF0000000000FF0000000000FF0000000000FF0000FFFFFFFF00
            8000008000008000008000008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF
            0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFFFF00FFFFFFFFFF
            00008000008000008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF
            FF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00
            FFFFFF008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF
            00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FF
            FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFF00FFFFFFFFFF00
            D8E9ECD8E9ECFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFF
            FF000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF00D8E9ECFFFFFF00
            FFFFD8E9ECFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00000000
            FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFF00FFFFFFD8E9EC00FFFFFFFFFFD8E9
            ECFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF000000FFFFFFFF
            FFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF00FFFFFFD8E9ECD8E9ECFFFF00FFFFFF
            FFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00000000FFFFFFFFFFFFFFFF
            FFFFFFFF99A8ACFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFF
            FF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
            99A8ACFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF
            00FFFFFFFFFF00FFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF99A8AC99
            A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC
            99A8AC99A8AC99A8AC99A8ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF}
        end
        object btnBR: TBitBtn
          Left = 140
          Top = 230
          Width = 24
          Height = 24
          TabOrder = 10
          OnClick = btnBRClick
          Glyph.Data = {
            E6040000424DE604000000000000360000002800000014000000140000000100
            180000000000B004000000000000000000000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF99A8AC0000000000
            000000000000000000000000000000000000FF0000FF0000FF0000FF0000FF00
            00FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000
            FF0000FF0000FF0000FF00000000FF0000000000FF271613000000FF00002716
            130000FFFFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF
            0000FF0000FF00000000FF0000FF000000271613FF00000000002716130000FF
            FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF0000FF00
            00FF00000000FF0000000000FF0000002716132716130000FF0000FFFFFFFFFF
            FFFFFFFFFFFFFFFF99A8ACFF0000FF0000FF0000FF0000FF0000FF0000FF0000
            0000FF0000FF0000000000FF0000000000FF0000000000FFFFFFFFFFFFFFFFFF
            FFFFFFFF99A8ACFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF000000FF00
            00000000FF0000000000FF0000000000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF
            99A8ACFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF0000FF0000FF0000
            FF0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF99A8ACFF
            FF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00
            FFFFFF008000008000000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF
            00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FF
            FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFF00FFFFFFFFFF00
            D8E9ECD8E9ECFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFF
            FF000000FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF00D8E9ECFFFFFF00
            FFFFD8E9ECFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00000000
            FFFFFFFFFFFFFFFFFFFFFFFF99A8ACFFFF00FFFFFFD8E9EC00FFFFFFFFFFD8E9
            ECFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF000000FFFFFFFF
            FFFFFFFFFFFFFFFF99A8ACFFFFFFFFFF00FFFFFFD8E9ECD8E9ECFFFF00FFFFFF
            FFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00000000FFFFFFFFFFFFFFFF
            FFFFFFFF99A8ACFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFF
            FF00FFFFFFFFFF00FFFFFFFFFF00FFFFFF000000FFFFFFFFFFFFFFFFFFFFFFFF
            99A8ACFFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF00FFFFFFFFFF
            00FFFFFFFFFF00FFFFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFF99A8AC99
            A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC99A8AC
            99A8AC99A8AC99A8AC99A8ACFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFF}
        end
      end
      object tbshImport: TTabSheet
        Tag = 1
        Caption = 'Import Directories'
        ImageIndex = 2
        DesignSize = (
          435
          354)
        object lbdefaultdesc: TLabel
          Left = 4
          Top = 32
          Width = 89
          Height = 13
          Caption = 'Default Directory: '
        end
        object lbdefault: TLabel
          Left = 106
          Top = 32
          Width = 333
          Height = 43
          AutoSize = False
          Caption = '<dir>'
          WordWrap = True
        end
        object Label1: TLabel
          Left = 4
          Top = 80
          Width = 98
          Height = 13
          Caption = 'Import Directory List'
        end
        object Label2: TLabel
          Left = 4
          Top = 4
          Width = 355
          Height = 13
          Caption = 'Workstation settings: these settings are the same for all users.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object pnloptlstboximport: TListBox
          Left = 10
          Top = 100
          Width = 415
          Height = 157
          Anchors = [akLeft, akTop, akRight, akBottom]
          ItemHeight = 13
          PopupMenu = mnupnloptlst
          TabOrder = 0
          OnClick = pnloptlstboximportClick
          OnDblClick = pnloptlstboximportDblClick
        end
        object pnloptimport: TPanel
          Left = 0
          Top = 257
          Width = 435
          Height = 97
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object btnOptDelete: TBitBtn
            Left = 116
            Top = 14
            Width = 96
            Height = 25
            Caption = 'Remove'
            Enabled = False
            TabOrder = 0
            OnClick = btnOptDeleteClick
          end
          object BitBtn2: TBitBtn
            Left = 328
            Top = 14
            Width = 96
            Height = 25
            Caption = 'Add Directory...'
            TabOrder = 1
            OnClick = BitBtn2Click
          end
          object btnOptSetAsDefault: TBitBtn
            Left = 222
            Top = 14
            Width = 96
            Height = 25
            Caption = 'Set as Default'
            Enabled = False
            TabOrder = 2
            OnClick = btnOptSetAsDefaultClick
          end
          object btnOptApply: TBitBtn
            Left = 10
            Top = 14
            Width = 96
            Height = 25
            Caption = 'Apply'
            Enabled = False
            TabOrder = 3
            OnClick = btnOptApplyClick
          end
        end
        object cbAddDirONSelect: TCheckBox
          Left = 14
          Top = 314
          Width = 389
          Height = 27
          Caption = 
            'Automatically add any selected directory to the Import Directory' +
            ' List.'
          TabOrder = 2
          WordWrap = True
        end
      end
      object tbshNotes: TTabSheet
        Tag = 3
        Caption = 'Visit Location'
        ImageIndex = 4
        object Bevel2: TBevel
          Left = 15
          Top = 40
          Width = 406
          Height = 36
        end
        object Bevel3: TBevel
          Left = 15
          Top = 95
          Width = 406
          Height = 181
        end
        object lbVLWrks: TLabel
          Left = 50
          Top = 190
          Width = 161
          Height = 13
          Caption = 'Workstation Default Visit Location'
        end
        object lbVLMy: TLabel
          Left = 50
          Top = 137
          Width = 237
          Height = 13
          Caption = 'My Default Visit Location  for New Progress Notes'
        end
        object Label7: TLabel
          Left = 5
          Top = 5
          Width = 170
          Height = 13
          Caption = 'When creating New Progress Notes'
        end
        object lbVLConfig: TLabel
          Left = 50
          Top = 110
          Width = 178
          Height = 13
          Caption = 'Use '#39'Visit Location'#39' from configuration'
        end
        object Label10: TLabel
          Left = 30
          Top = 110
          Width = 10
          Height = 13
          Caption = '1)'
        end
        object Label11: TLabel
          Left = 30
          Top = 137
          Width = 10
          Height = 13
          Caption = '2)'
        end
        object Label12: TLabel
          Left = 30
          Top = 190
          Width = 10
          Height = 13
          Caption = '3)'
        end
        object Label3: TLabel
          Left = 50
          Top = 53
          Width = 252
          Height = 13
          Caption = 'You will need to select a Visit Location when needed.'
        end
        object lbVLwrksNoKey1: TLabel
          Left = 230
          Top = 190
          Width = 159
          Height = 13
          Caption = '(Key is required to change value)'
          Visible = False
        end
        object edtVLMy: TEdit
          Left = 52
          Top = 157
          Width = 244
          Height = 21
          Hint = 'Search for a Hospital Location that matches the entered text'
          TabOrder = 0
          OnKeyUp = edtVLMyKeyUp
        end
        object edtVLWrks: TEdit
          Left = 52
          Top = 212
          Width = 244
          Height = 21
          Hint = 'Search for a Hospital Location that matches the entered text'
          Enabled = False
          TabOrder = 3
          OnKeyUp = edtVLWrksKeyUp
        end
        object btnVLMy: TBitBtn
          Left = 274
          Top = 159
          Width = 20
          Height = 18
          TabOrder = 2
          TabStop = False
          OnClick = btnVLMyClick
          Glyph.Data = {
            C6000000424DC60000000000000076000000280000000A0000000A0000000100
            0400000000005000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFF007FFFF00
            0000FF00777FFF000000F00FFF77FF00000000FFFFF77F000000000007777700
            0000FFFF07FFFF000000FFFF07FFFF000000FFFF07FFFF000000FFFF07FFFF00
            0000FFFF07FFFF000000}
        end
        object btnVLWrks: TBitBtn
          Left = 274
          Top = 214
          Width = 20
          Height = 18
          Enabled = False
          TabOrder = 4
          TabStop = False
          OnClick = btnVLWrksClick
          Glyph.Data = {
            C6000000424DC60000000000000076000000280000000A0000000A0000000100
            0400000000005000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFF007FFFF00
            0000FF00777FFF000000F00FFF77FF00000000FFFFF77F000000000007777700
            0000FFFF07FFFF000000FFFF07FFFF000000FFFF07FFFF000000FFFF07FFFF00
            0000FFFF07FFFF000000}
        end
        object mlvVLMy: TMagListView
          Tag = 170
          Left = 68
          Top = 179
          Width = 273
          Height = 37
          BevelOuter = bvRaised
          BevelKind = bkSoft
          BorderWidth = 2
          Columns = <>
          TabOrder = 1
          TabStop = False
          Visible = False
          OnClick = mlvVLMyClick
          OnExit = mlvVLMyExit
          OnSelectItem = mlvVLMySelectItem
        end
        object mlvVLWrks: TMagListView
          Tag = 92
          Left = 68
          Top = 234
          Width = 273
          Height = 37
          BevelOuter = bvRaised
          BevelKind = bkSoft
          BorderWidth = 2
          Columns = <>
          TabOrder = 5
          TabStop = False
          Visible = False
          OnClick = mlvVLWrksClick
          OnExit = mlvVLWrksExit
          OnSelectItem = mlvVLWrksSelectItem
        end
        object rbUseDefaults: TRadioButton
          Left = 25
          Top = 87
          Width = 296
          Height = 17
          Caption = 'Use Default values for Visit Location in the following order '
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 6
          TabStop = True
          OnClick = rbUseDefaultsClick
        end
        object rbNotUseDefaults: TRadioButton
          Left = 25
          Top = 32
          Width = 221
          Height = 17
          Caption = 'Don'#39't use Default values for Visit Location '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 7
          OnClick = rbNotUseDefaultsClick
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 392
    Width = 453
    Height = 49
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object OKBtn: TButton
      Left = 126
      Top = 10
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object HelpBtn: TButton
      Left = 268
      Top = 10
      Width = 75
      Height = 25
      Caption = '&Help'
      TabOrder = 2
    end
    object btnApplySettings: TButton
      Left = 6
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Apply'
      TabOrder = 3
      Visible = False
      OnClick = btnApplySettingsClick
    end
    object CancelBtn: TButton
      Left = 41
      Top = 0
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      Visible = False
    end
  end
  object opendialogOption: TOpenDialog
    Filter = 'All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofNoChangeDir, ofNoTestFileCreate, ofEnableSizing]
    Title = 'Add Directory to Import Directory List'
    Left = 383
    Top = 53
  end
  object mnupnloptlst: TPopupMenu
    Left = 383
    Top = 145
    object Remove1: TMenuItem
      Caption = 'Remove'
      OnClick = Remove1Click
    end
    object SetasDefault1: TMenuItem
      Caption = 'Set as Default'
      OnClick = SetasDefault1Click
    end
    object Applydblclick1: TMenuItem
      Caption = 'Apply        <dbl-click>'
      OnClick = Applydblclick1Click
    end
  end
  object timerlkp: TTimer
    Enabled = False
    Interval = 500
    OnTimer = timerlkpTimer
    Left = 384
    Top = 94
  end
end
