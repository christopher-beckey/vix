object frmMagAnnotationMarkProperty: TfrmMagAnnotationMarkProperty
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Mark Property'
  ClientHeight = 303
  ClientWidth = 342
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 342
    Height = 303
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 340
      Height = 271
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 0
      object PageControl1: TPageControl
        Left = 0
        Top = 0
        Width = 340
        Height = 271
        ActivePage = pageText
        Align = alClient
        TabOrder = 0
        object pageFont: TTabSheet
          Caption = 'Font'
          ImageIndex = 2
          object FontLbl: TLabel
            Left = 11
            Top = 3
            Width = 26
            Height = 13
            Caption = 'Font:'
          end
          object StyleLbl: TLabel
            Left = 176
            Top = 3
            Width = 28
            Height = 13
            Caption = 'Style:'
          end
          object FontSizeLbl: TLabel
            Left = 264
            Top = 3
            Width = 23
            Height = 13
            Caption = 'Size:'
          end
          object FontList: TListBox
            Left = 3
            Top = 22
            Width = 170
            Height = 123
            ItemHeight = 13
            Items.Strings = (
              'Arial')
            TabOrder = 0
            OnClick = FontListClick
          end
          object FontStyles: TListBox
            Left = 177
            Top = 22
            Width = 87
            Height = 123
            ItemHeight = 13
            Items.Strings = (
              'Regular'
              'Bold'
              'Italic'
              'Bold Italic')
            TabOrder = 1
            OnClick = FontStylesClick
          end
          object FontSizes: TListBox
            Left = 270
            Top = 22
            Width = 59
            Height = 123
            ItemHeight = 13
            Items.Strings = (
              '8'
              '9'
              '10'
              '11'
              '12'
              '14'
              '16'
              '18'
              '20'
              '22'
              '24'
              '26'
              '28'
              '36'
              '48'
              '72')
            TabOrder = 2
            OnClick = FontSizesClick
          end
          object FontSample: TPanel
            Left = 3
            Top = 151
            Width = 324
            Height = 85
            BevelInner = bvLowered
            Caption = 'Sample'
            Enabled = False
            TabOrder = 3
          end
        end
        object pageText: TTabSheet
          Caption = 'Text'
          ImageIndex = 4
          object TextAlignmentLbl: TLabel
            Left = 3
            Top = 176
            Width = 47
            Height = 13
            Caption = 'Alignment'
          end
          object TextBoundsWrapLbl: TLabel
            Left = 3
            Top = 208
            Width = 64
            Height = 13
            Caption = 'Bounds Wrap'
            Visible = False
          end
          object Memo1: TMemo
            Left = 3
            Top = 3
            Width = 324
            Height = 134
            Lines.Strings = (
              'Memo1')
            TabOrder = 0
            OnChange = Memo1Change
          end
          object TextWordWrap: TCheckBox
            Left = 252
            Top = 143
            Width = 75
            Height = 17
            Caption = 'Word Wrap'
            TabOrder = 1
            OnClick = TextWordWrapClick
          end
          object TextAlignment: TComboBox
            Left = 80
            Top = 173
            Width = 247
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 2
            Text = 'Top Left'
            OnChange = TextAlignmentChange
            Items.Strings = (
              'Top Left'
              'Top Center'
              'Top Right'
              'Center Left'
              'Center Center'
              'Center Right'
              'Bottom Left'
              'Bottom Center'
              'Bottom Right')
          end
          object TextBoundsWrap: TComboBox
            Left = 80
            Top = 200
            Width = 247
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            ItemIndex = 0
            TabOrder = 3
            Text = 'No Wrap'
            Visible = False
            OnChange = TextBoundsWrapChange
            Items.Strings = (
              'No Wrap'
              'Horizontal'
              'Vertical'
              'Horizontal & Vertical')
          end
        end
        object pageShape: TTabSheet
          Caption = 'Shape'
          object ShapeWidthLbl: TLabel
            Left = 20
            Top = 16
            Width = 28
            Height = 13
            Caption = 'Width'
          end
          object ShapeWidthUpDown: TUpDown
            Left = 110
            Top = 13
            Width = 30
            Height = 21
            Hint = 'Change Line Width'
            Associate = ShapeWidth
            Min = 1
            Orientation = udHorizontal
            Position = 1
            TabOrder = 0
            OnClick = ShapeWidthUpDownClick
          end
          object ShapeClosed: TCheckBox
            Left = 168
            Top = 15
            Width = 57
            Height = 17
            Hint = 'Make mark closed'
            Caption = 'Closed'
            TabOrder = 1
            OnClick = ShapeClosedClick
          end
          object ShapeWidth: TEdit
            Left = 60
            Top = 13
            Width = 50
            Height = 21
            ReadOnly = True
            TabOrder = 2
            Text = '1'
          end
          object ShapeArrowPanel: TPanel
            Left = -1
            Top = 51
            Width = 330
            Height = 122
            BevelOuter = bvNone
            TabOrder = 3
            object ShapeStartLbl: TLabel
              Left = 20
              Top = 6
              Width = 24
              Height = 13
              Caption = 'Start'
              Visible = False
            end
            object ShapeStartAngleLbl: TLabel
              Left = 195
              Top = 35
              Width = 27
              Height = 13
              Caption = 'Angle'
              Visible = False
            end
            object ShapeStartLengthLbl: TLabel
              Left = 60
              Top = 35
              Width = 33
              Height = 13
              Caption = 'Length'
              Visible = False
            end
            object Label4: TLabel
              Left = 20
              Top = 64
              Width = 57
              Height = 13
              Caption = 'Arrow Head'
            end
            object ShapeEndLengthLbl: TLabel
              Left = 60
              Top = 94
              Width = 33
              Height = 13
              Caption = 'Length'
            end
            object ShapeEndAngleLbl: TLabel
              Left = 195
              Top = 94
              Width = 27
              Height = 13
              Caption = 'Angle'
            end
            object ShapeStartArrowStyle: TComboBox
              Left = 60
              Top = 0
              Width = 245
              Height = 21
              ItemHeight = 13
              TabOrder = 0
              Visible = False
              OnChange = ShapeStartArrowStyleChange
              Items.Strings = (
                'Pointer'
                'Solid'
                'Open'
                'Pointer Solid'
                'None')
            end
            object ShapeStartArrowAngle: TEdit
              Left = 228
              Top = 27
              Width = 50
              Height = 21
              ReadOnly = True
              TabOrder = 1
              Text = '10'
              Visible = False
            end
            object ShapeStartArrowAngleUpDown: TUpDown
              Left = 278
              Top = 27
              Width = 30
              Height = 21
              Hint = 'Change Arrow Angle'
              Associate = ShapeStartArrowAngle
              Min = 10
              Max = 60
              Increment = 5
              Orientation = udHorizontal
              Position = 10
              TabOrder = 2
              Visible = False
              OnClick = ShapeStartArrowAngleUpDownClick
            end
            object ShapeStartArrowLength: TEdit
              Left = 99
              Top = 27
              Width = 50
              Height = 21
              ReadOnly = True
              TabOrder = 3
              Text = '10'
              Visible = False
            end
            object ShapeStartArrowLengthUpDown: TUpDown
              Left = 149
              Top = 27
              Width = 30
              Height = 21
              Hint = 'Change Arrow Length'
              Associate = ShapeStartArrowLength
              Min = 10
              Max = 200
              Increment = 5
              Orientation = udHorizontal
              Position = 10
              TabOrder = 4
              Visible = False
              OnClick = ShapeStartArrowLengthUpDownClick
            end
            object ShapeEndArrowStyle: TComboBox
              Left = 99
              Top = 62
              Width = 206
              Height = 21
              Style = csDropDownList
              ItemHeight = 13
              TabOrder = 5
              OnChange = ShapeEndArrowStyleChange
              Items.Strings = (
                'Pointer'
                'Solid'
                'Open'
                'Pointer Solid'
                'None')
            end
            object ShapeEndArrowLength: TEdit
              Left = 99
              Top = 89
              Width = 50
              Height = 21
              ReadOnly = True
              TabOrder = 6
              Text = '10'
            end
            object ShapeEndArrowLengthUpDown: TUpDown
              Left = 149
              Top = 89
              Width = 30
              Height = 21
              Hint = 'Change Arrow Length'
              Associate = ShapeEndArrowLength
              Min = 10
              Max = 200
              Increment = 5
              Orientation = udHorizontal
              Position = 10
              TabOrder = 7
              OnClick = ShapeEndArrowLengthUpDownClick
            end
            object ShapeEndArrowAngle: TEdit
              Left = 228
              Top = 89
              Width = 50
              Height = 21
              ReadOnly = True
              TabOrder = 8
              Text = '10'
            end
            object ShapeEndArrowAngleUpDown: TUpDown
              Left = 278
              Top = 89
              Width = 30
              Height = 21
              Hint = 'Change Arrow Angle'
              Associate = ShapeEndArrowAngle
              Min = 10
              Max = 60
              Increment = 5
              Orientation = udHorizontal
              Position = 10
              TabOrder = 9
              OnClick = ShapeEndArrowAngleUpDownClick
            end
          end
        end
        object pageColor: TTabSheet
          Caption = 'Color'
          ImageIndex = 1
          object Label5: TLabel
            Left = 19
            Top = 92
            Width = 117
            Height = 13
            Caption = 'Color Selected: <Color>'
          end
          object LineColorBox: TGroupBox
            Left = 20
            Top = 13
            Width = 253
            Height = 73
            Caption = 'Annotation Color:'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            object btnLineColor01: TSpeedButton
              Left = 11
              Top = 16
              Width = 23
              Height = 22
              Hint = 'Black'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003000000000000000030000003000000000000000030000003000
                0000000000000300000030000000000000000300000030000000000000000300
                0000300000000000000003000000300000000000000003000000300000000000
                0000030000003000000000000000030000003000000000000000030000003000
                0000000000000300000030000000000000000300000030000000000000000300
                0000300000000000000003000000300000000000000003000000300000000000
                000003000000333333333333333333000000}
              OnClick = btnLineColor01Click
            end
            object btnLineColor02: TSpeedButton
              Left = 40
              Top = 16
              Width = 23
              Height = 22
              Hint = 'Gray'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003777777777777777730000003777777777777777730000003777
                7777777777777300000037777777777777777300000037777777777777777300
                0000377777777777777773000000377777777777777773000000377777777777
                7777730000003777777777777777730000003777777777777777730000003777
                7777777777777300000037777777777777777300000037777777777777777300
                0000377777777777777773000000377777777777777773000000377777777777
                777773000000333333333333333333000000}
              OnClick = btnLineColor02Click
            end
            object btnLineColor03: TSpeedButton
              Left = 69
              Top = 16
              Width = 23
              Height = 22
              Hint = 'Maroon'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003111111111111111130000003111111111111111130000003111
                1111111111111300000031111111111111111300000031111111111111111300
                0000311111111111111113000000311111111111111113000000311111111111
                1111130000003111111111111111130000003111111111111111130000003111
                1111111111111300000031111111111111111300000031111111111111111300
                0000311111111111111113000000311111111111111113000000311111111111
                111113000000333333333333333333000000}
              OnClick = btnLineColor03Click
            end
            object btnLineColor04: TSpeedButton
              Left = 98
              Top = 16
              Width = 23
              Height = 22
              Hint = 'Olive'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
                5555550000005333333333333333350000005333333333333333350000005333
                3333333333333500000053333333333333333500000053333333333333333500
                0000533333333333333335000000533333333333333335000000533333333333
                3333350000005333333333333333350000005333333333333333350000005333
                3333333333333500000053333333333333333500000053333333333333333500
                0000533333333333333335000000533333333333333335000000533333333333
                333335000000555555555555555555000000}
              OnClick = btnLineColor04Click
            end
            object btnLineColor05: TSpeedButton
              Left = 127
              Top = 16
              Width = 23
              Height = 22
              Hint = 'Green'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003222222222222222230000003222222222222222230000003222
                2222222222222300000032222222222222222300000032222222222222222300
                0000322222222222222223000000322222222222222223000000322222222222
                2222230000003222222222222222230000003222222222222222230000003222
                2222222222222300000032222222222222222300000032222222222222222300
                0000322222222222222223000000322222222222222223000000322222222222
                222223000000333333333333333333000000}
              OnClick = btnLineColor05Click
            end
            object btnLineColor06: TSpeedButton
              Left = 156
              Top = 16
              Width = 23
              Height = 22
              Hint = 'Teal'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003666666666666666630000003666666666666666630000003666
                6666666666666300000036666666666666666300000036666666666666666300
                0000366666666666666663000000366666666666666663000000366666666666
                6666630000003666666666666666630000003666666666666666630000003666
                6666666666666300000036666666666666666300000036666666666666666300
                0000366666666666666663000000366666666666666663000000366666666666
                666663000000333333333333333333000000}
              OnClick = btnLineColor06Click
            end
            object btnLineColor07: TSpeedButton
              Left = 185
              Top = 16
              Width = 23
              Height = 22
              Hint = 'Navy'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003444444444444444430000003444444444444444430000003444
                4444444444444300000034444444444444444300000034444444444444444300
                0000344444444444444443000000344444444444444443000000344444444444
                4444430000003444444444444444430000003444444444444444430000003444
                4444444444444300000034444444444444444300000034444444444444444300
                0000344444444444444443000000344444444444444443000000344444444444
                444443000000333333333333333333000000}
              OnClick = btnLineColor07Click
            end
            object btnLineColor08: TSpeedButton
              Left = 214
              Top = 16
              Width = 23
              Height = 22
              Hint = 'Purple'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003555555555555555530000003555555555555555530000003555
                5555555555555300000035555555555555555300000035555555555555555300
                0000355555555555555553000000355555555555555553000000355555555555
                5555530000003555555555555555530000003555555555555555530000003555
                5555555555555300000035555555555555555300000035555555555555555300
                0000355555555555555553000000355555555555555553000000355555555555
                555553000000333333333333333333000000}
              OnClick = btnLineColor08Click
            end
            object btnLineColor09: TSpeedButton
              Left = 11
              Top = 44
              Width = 23
              Height = 22
              Hint = 'White'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003FFFFFFFFFFFFFFFF30000003FFFFFFFFFFFFFFFF30000003FFF
                FFFFFFFFFFFFF30000003FFFFFFFFFFFFFFFF30000003FFFFFFFFFFFFFFFF300
                00003FFFFFFFFFFFFFFFF30000003FFFFFFFFFFFFFFFF30000003FFFFFFFFFFF
                FFFFF30000003FFFFFFFFFFFFFFFF30000003FFFFFFFFFFFFFFFF30000003FFF
                FFFFFFFFFFFFF30000003FFFFFFFFFFFFFFFF30000003FFFFFFFFFFFFFFFF300
                00003FFFFFFFFFFFFFFFF30000003FFFFFFFFFFFFFFFF30000003FFFFFFFFFFF
                FFFFF3000000333333333333333333000000}
              OnClick = btnLineColor09Click
            end
            object btnLineColor10: TSpeedButton
              Left = 40
              Top = 44
              Width = 23
              Height = 22
              Hint = 'Silver'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003888888888888888830000003888888888888888830000003888
                8888888888888300000038888888888888888300000038888888888888888300
                0000388888888888888883000000388888888888888883000000388888888888
                8888830000003888888888888888830000003888888888888888830000003888
                8888888888888300000038888888888888888300000038888888888888888300
                0000388888888888888883000000388888888888888883000000388888888888
                888883000000333333333333333333000000}
              OnClick = btnLineColor10Click
            end
            object btnLineColor11: TSpeedButton
              Left = 69
              Top = 44
              Width = 23
              Height = 22
              Hint = 'Red'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003999999999999999930000003999999999999999930000003999
                9999999999999300000039999999999999999300000039999999999999999300
                0000399999999999999993000000399999999999999993000000399999999999
                9999930000003999999999999999930000003999999999999999930000003999
                9999999999999300000039999999999999999300000039999999999999999300
                0000399999999999999993000000399999999999999993000000399999999999
                999993000000333333333333333333000000}
              OnClick = btnLineColor11Click
            end
            object btnLineColor12: TSpeedButton
              Left = 98
              Top = 44
              Width = 23
              Height = 22
              Hint = 'Yellow'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003BBBBBBBBBBBBBBBB30000003BBBBBBBBBBBBBBBB30000003BBB
                BBBBBBBBBBBBB30000003BBBBBBBBBBBBBBBB30000003BBBBBBBBBBBBBBBB300
                00003BBBBBBBBBBBBBBBB30000003BBBBBBBBBBBBBBBB30000003BBBBBBBBBBB
                BBBBB30000003BBBBBBBBBBBBBBBB30000003BBBBBBBBBBBBBBBB30000003BBB
                BBBBBBBBBBBBB30000003BBBBBBBBBBBBBBBB30000003BBBBBBBBBBBBBBBB300
                00003BBBBBBBBBBBBBBBB30000003BBBBBBBBBBBBBBBB30000003BBBBBBBBBBB
                BBBBB3000000333333333333333333000000}
              OnClick = btnLineColor12Click
            end
            object btnLineColor13: TSpeedButton
              Left = 127
              Top = 44
              Width = 23
              Height = 22
              Hint = 'Lime'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003AAAAAAAAAAAAAAAA30000003AAAAAAAAAAAAAAAA30000003AAA
                AAAAAAAAAAAAA30000003AAAAAAAAAAAAAAAA30000003AAAAAAAAAAAAAAAA300
                00003AAAAAAAAAAAAAAAA30000003AAAAAAAAAAAAAAAA30000003AAAAAAAAAAA
                AAAAA30000003AAAAAAAAAAAAAAAA30000003AAAAAAAAAAAAAAAA30000003AAA
                AAAAAAAAAAAAA30000003AAAAAAAAAAAAAAAA30000003AAAAAAAAAAAAAAAA300
                00003AAAAAAAAAAAAAAAA30000003AAAAAAAAAAAAAAAA30000003AAAAAAAAAAA
                AAAAA3000000333333333333333333000000}
              OnClick = btnLineColor13Click
            end
            object btnLineColor14: TSpeedButton
              Left = 156
              Top = 44
              Width = 23
              Height = 22
              Hint = 'Aqua'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003EEEEEEEEEEEEEEEE30000003EEEEEEEEEEEEEEEE30000003EEE
                EEEEEEEEEEEEE30000003EEEEEEEEEEEEEEEE30000003EEEEEEEEEEEEEEEE300
                00003EEEEEEEEEEEEEEEE30000003EEEEEEEEEEEEEEEE30000003EEEEEEEEEEE
                EEEEE30000003EEEEEEEEEEEEEEEE30000003EEEEEEEEEEEEEEEE30000003EEE
                EEEEEEEEEEEEE30000003EEEEEEEEEEEEEEEE30000003EEEEEEEEEEEEEEEE300
                00003EEEEEEEEEEEEEEEE30000003EEEEEEEEEEEEEEEE30000003EEEEEEEEEEE
                EEEEE3000000333333333333333333000000}
              OnClick = btnLineColor14Click
            end
            object btnLineColor15: TSpeedButton
              Left = 185
              Top = 44
              Width = 23
              Height = 22
              Hint = 'Blue'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003CCCCCCCCCCCCCCCC30000003CCCCCCCCCCCCCCCC30000003CCC
                CCCCCCCCCCCCC30000003CCCCCCCCCCCCCCCC30000003CCCCCCCCCCCCCCCC300
                00003CCCCCCCCCCCCCCCC30000003CCCCCCCCCCCCCCCC30000003CCCCCCCCCCC
                CCCCC30000003CCCCCCCCCCCCCCCC30000003CCCCCCCCCCCCCCCC30000003CCC
                CCCCCCCCCCCCC30000003CCCCCCCCCCCCCCCC30000003CCCCCCCCCCCCCCCC300
                00003CCCCCCCCCCCCCCCC30000003CCCCCCCCCCCCCCCC30000003CCCCCCCCCCC
                CCCCC3000000333333333333333333000000}
              OnClick = btnLineColor15Click
            end
            object btnLineColor16: TSpeedButton
              Left = 214
              Top = 44
              Width = 23
              Height = 22
              Hint = 'Fuchsia'
              Glyph.Data = {
                4E010000424D4E01000000000000760000002800000012000000120000000100
                040000000000D800000000000000000000001000000000000000000000000000
                8000008000000080800080000000800080008080000080808000C0C0C0000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
                3333330000003DDDDDDDDDDDDDDDD30000003DDDDDDDDDDDDDDDD30000003DDD
                DDDDDDDDDDDDD30000003DDDDDDDDDDDDDDDD30000003DDDDDDDDDDDDDDDD300
                00003DDDDDDDDDDDDDDDD30000003DDDDDDDDDDDDDDDD30000003DDDDDDDDDDD
                DDDDD30000003DDDDDDDDDDDDDDDD30000003DDDDDDDDDDDDDDDD30000003DDD
                DDDDDDDDDDDDD30000003DDDDDDDDDDDDDDDD30000003DDDDDDDDDDDDDDDD300
                00003DDDDDDDDDDDDDDDD30000003DDDDDDDDDDDDDDDD30000003DDDDDDDDDDD
                DDDDD3000000333333333333333333000000}
              OnClick = btnLineColor16Click
            end
          end
          object OpacityPanel: TPanel
            Left = 0
            Top = 162
            Width = 329
            Height = 73
            BevelOuter = bvNone
            TabOrder = 1
            object Label3: TLabel
              Left = 20
              Top = 4
              Width = 37
              Height = 13
              Caption = 'Opacity'
            end
            object Label1: TLabel
              Left = 20
              Top = 47
              Width = 16
              Height = 13
              Caption = 'Min'
            end
            object Label2: TLabel
              Left = 253
              Top = 47
              Width = 20
              Height = 13
              Caption = 'Max'
            end
            object Opacity: TTrackBar
              Left = 20
              Top = 17
              Width = 253
              Height = 32
              Max = 255
              Min = 63
              Frequency = 96
              Position = 159
              TabOrder = 0
              OnChange = OpacityChange
            end
          end
          object NoFillColor: TCheckBox
            Left = 20
            Top = 126
            Width = 51
            Height = 17
            Caption = 'No Fill'
            TabOrder = 2
            OnClick = NoFillColorClick
          end
        end
        object pageMeasure: TTabSheet
          Caption = 'Measure'
          ImageIndex = 3
          object editPrecision: TLabeledEdit
            Left = 104
            Top = 61
            Width = 73
            Height = 21
            EditLabel.Width = 42
            EditLabel.Height = 13
            EditLabel.Caption = 'Precision'
            LabelPosition = lpLeft
            TabOrder = 0
            Text = '0'
            Visible = False
          end
          object editStartLineLength: TLabeledEdit
            Left = 104
            Top = 88
            Width = 73
            Height = 21
            EditLabel.Width = 82
            EditLabel.Height = 13
            EditLabel.Caption = 'Start Line Length'
            LabelPosition = lpLeft
            ReadOnly = True
            TabOrder = 1
            Text = '4'
          end
          object editEndLineLength: TLabeledEdit
            Left = 104
            Top = 115
            Width = 73
            Height = 21
            EditLabel.Width = 76
            EditLabel.Height = 13
            EditLabel.Caption = 'End Line Length'
            LabelPosition = lpLeft
            ReadOnly = True
            TabOrder = 2
            Text = '4'
          end
          object PrecisionUpDown: TUpDown
            Left = 177
            Top = 61
            Width = 30
            Height = 21
            Hint = 'Change Precision'
            Associate = editPrecision
            Max = 5
            Orientation = udHorizontal
            TabOrder = 3
            Visible = False
            OnClick = PrecisionUpDownClick
          end
          object RulerStartLengthUpDown: TUpDown
            Left = 177
            Top = 88
            Width = 30
            Height = 21
            Hint = 'Change Start Line Length for Ruler'
            Associate = editStartLineLength
            Min = 4
            Max = 400
            Increment = 4
            Orientation = udHorizontal
            Position = 4
            TabOrder = 4
            OnClick = RulerStartLengthUpDownClick
          end
          object RulerEndLengthUpDown: TUpDown
            Left = 177
            Top = 115
            Width = 30
            Height = 21
            Hint = 'Change End Line Length for Ruler'
            Associate = editEndLineLength
            Min = 4
            Max = 400
            Increment = 4
            Orientation = udHorizontal
            Position = 4
            TabOrder = 5
            OnClick = RulerEndLengthUpDownClick
          end
        end
      end
    end
    object Panel4: TPanel
      Left = 1
      Top = 272
      Width = 340
      Height = 30
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object btnClose: TButton
        Left = 129
        Top = 5
        Width = 70
        Height = 20
        Caption = 'OK'
        TabOrder = 0
        OnClick = btnCloseClick
      end
    end
  end
end
