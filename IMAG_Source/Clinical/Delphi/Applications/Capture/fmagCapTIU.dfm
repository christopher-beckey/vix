object frmCapTIU: TfrmCapTIU
  Left = 435
  Top = 94
  HelpContext = 10156
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Select Progress Note'
  ClientHeight = 664
  ClientWidth = 735
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 575
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = True
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbVisit: TLabel
    Left = 622
    Top = 232
    Width = 31
    Height = 13
    Caption = '<Visit>'
    Visible = False
  end
  object Label4: TLabel
    Left = 624
    Top = 276
    Width = 33
    Height = 13
    Caption = 'Action:'
    Visible = False
  end
  object lbNewNote: TLabel
    Left = 624
    Top = 300
    Width = 82
    Height = 13
    Caption = 'Create New Note'
    Visible = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 645
    Width = 735
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object pageControl: TPageControl
    Left = 8
    Top = 5
    Width = 652
    Height = 630
    ActivePage = tabshSelect
    Images = imglst16w
    TabOrder = 1
    TabStop = False
    OnChange = pageControlChange
    object tabshSelect: TTabSheet
      Caption = 'Select Note'
      ImageIndex = -1
      object spltList: TSplitter
        Left = 0
        Top = 402
        Width = 644
        Height = 7
        Cursor = crVSplit
        Align = alBottom
        Beveled = True
        OnCanResize = spltListCanResize
        ExplicitTop = 297
        ExplicitWidth = 609
      end
      object pnlPreview: TPanel
        Left = 0
        Top = 409
        Width = 644
        Height = 192
        Align = alBottom
        BevelOuter = bvNone
        Caption = '<pnl Preview>'
        Color = clActiveCaption
        TabOrder = 3
        OnResize = pnlPreviewResize
        DesignSize = (
          644
          192)
        object lbpreview: TLabel
          Left = 0
          Top = 0
          Width = 644
          Height = 23
          Align = alTop
          AutoSize = False
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clActiveCaption
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Layout = tlCenter
          ExplicitWidth = 609
        end
        object Splitter2: TSplitter
          Left = 636
          Top = 23
          Width = 8
          Height = 169
          Align = alRight
          Beveled = True
          Color = clBtnFace
          ParentColor = False
          Visible = False
          ExplicitLeft = 464
        end
        object memNoteText: TMemo
          Left = 32
          Top = 54
          Width = 290
          Height = 107
          TabStop = False
          Anchors = [akLeft, akTop, akRight, akBottom]
          Color = 13038324
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object StatusBar2: TStatusBar
        Left = 0
        Top = 21
        Width = 644
        Height = 19
        Align = alTop
        Panels = <
          item
            Width = 60
          end
          item
            Width = 160
          end
          item
            Width = 85
          end
          item
            Width = 85
          end
          item
            Width = 60
          end>
      end
      object tbarMain: TToolBar
        Left = 0
        Top = 0
        Width = 644
        Height = 21
        AutoSize = True
        ButtonHeight = 21
        ButtonWidth = 69
        ShowCaptions = True
        TabOrder = 1
        object tbPreview: TToolButton
          Left = 0
          Top = 0
          AutoSize = True
          Caption = '[Preview]'
          Style = tbsCheck
          OnClick = tbPreviewClick
        end
        object tbtnDivider1: TToolButton
          Left = 55
          Top = 0
          Width = 8
          Caption = 'tbtnDivider1'
          ImageIndex = 3
          Style = tbsSeparator
        end
        object tbtnMine: TToolButton
          Left = 63
          Top = 0
          AllowAllUp = True
          AutoSize = True
          Caption = 'My Notes'
          Grouped = True
          Style = tbsCheck
          OnClick = tbtnMineClick
        end
        object tbtnSigned: TToolButton
          Tag = 1
          Left = 119
          Top = 0
          AllowAllUp = True
          AutoSize = True
          Caption = 'Signed (100)'
          Grouped = True
          Style = tbsCheck
          OnClick = tbtnSignedClick
        end
        object tbtnMore: TToolButton
          Left = 190
          Top = 0
          Caption = 'More'
          ImageIndex = 4
          OnClick = tbtnMoreClick
        end
        object tbtndivider2: TToolButton
          Left = 259
          Top = 0
          Width = 8
          Caption = 'tbtndivider2'
          ImageIndex = 9
          Style = tbsSeparator
        end
        object tbtnUnSigned: TToolButton
          Tag = 2
          Left = 267
          Top = 0
          AutoSize = True
          Caption = 'UnSigned'
          Style = tbsCheck
          OnClick = tbtnUnSignedClick
        end
        object tbtnUnCosigned: TToolButton
          Tag = 3
          Left = 325
          Top = 0
          AutoSize = True
          Caption = 'UnCosigned'
          Style = tbsCheck
          OnClick = tbtnUnCosignedClick
        end
        object tbrnDivider3: TToolButton
          Left = 394
          Top = 0
          Width = 8
          Caption = 'tbrnDivider3'
          ImageIndex = 7
          Style = tbsSeparator
        end
        object tbtnAuthor: TToolButton
          Tag = 4
          Left = 402
          Top = 0
          AllowAllUp = True
          AutoSize = True
          Caption = 'by Author...'
          Grouped = True
          OnClick = tbtnAuthorClick
        end
        object ToolButton1: TToolButton
          Left = 467
          Top = 0
          Width = 8
          Caption = 'ToolButton1'
          ImageIndex = 8
          Style = tbsSeparator
        end
        object tbtnNoteOptions: TToolButton
          Left = 475
          Top = 0
          AutoSize = True
          Caption = 'List options...'
          OnClick = tbtnNoteOptionsClick
        end
        object ToolButton2: TToolButton
          Left = 548
          Top = 0
          Width = 8
          Caption = 'ToolButton2'
          ImageIndex = 9
          Style = tbsSeparator
        end
        object tbtnSignNote: TToolButton
          Left = 556
          Top = 0
          AutoSize = True
          Caption = 'Sign Note...'
          ImageIndex = 3
          OnClick = tbtnSignNoteClick
        end
      end
      object pnlListNotes: TPanel
        Left = 0
        Top = 40
        Width = 644
        Height = 362
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 2
        Caption = 'pnlListNotes'
        Constraints.MinHeight = 236
        TabOrder = 0
        object pnlNotes: TPanel
          Left = 2
          Top = 2
          Width = 423
          Height = 245
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object splUnsigned: TSplitter
            Left = 0
            Top = 100
            Width = 423
            Height = 5
            Cursor = crVSplit
            Align = alTop
            Visible = False
            ExplicitTop = 57
            ExplicitWidth = 388
          end
          object mlvNotes: TMagListView
            Left = 0
            Top = 105
            Width = 423
            Height = 140
            Align = alClient
            Columns = <>
            SmallImages = imglst16w
            StateImages = imglst16w
            TabOrder = 0
            OnClick = mlvGenericClick
            OnDblClick = MlvGenericDblClick
            OnKeyUp = mlvGenericKeyUp
            OnSelectItem = MlvGenericSelectItem
          end
          object mlvUnSigned: TMagListView
            Left = 0
            Top = 0
            Width = 423
            Height = 100
            Align = alTop
            Columns = <>
            SmallImages = imglst16w
            StateImages = imglst16w
            TabOrder = 1
            Visible = False
            OnClick = mlvGenericClick
            OnDblClick = MlvGenericDblClick
            OnKeyUp = mlvGenericKeyUp
            OnSelectItem = MlvGenericSelectItem
          end
        end
        object pnlOkCancel: TPanel
          Left = 425
          Top = 2
          Width = 217
          Height = 245
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          DesignSize = (
            217
            245)
          object lbNoteTitle: TLabel
            Left = 15
            Top = 4
            Width = 61
            Height = 13
            Caption = '< Note Title>'
            Color = clBtnFace
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clActiveCaption
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            Transparent = False
          end
          object lbActionDesc: TLabel
            Left = 15
            Top = 23
            Width = 119
            Height = 13
            Caption = '<select a Progress Note>'
          end
          object rgrp2NoteStatus: TRadioGroup
            Left = 13
            Top = 66
            Width = 173
            Height = 95
            Caption = 'Change Note Status : '
            ItemIndex = 0
            Items.Strings = (
              'Un-Signed (no change)'
              'Signed'
              'Electronically Filed.')
            TabOrder = 0
            OnClick = rgrp2NoteStatusClick
          end
          object btnOK: TBitBtn
            Left = 18
            Top = 167
            Width = 75
            Height = 25
            Anchors = [akRight, akBottom]
            Caption = '&OK'
            Enabled = False
            TabOrder = 1
            OnClick = btnOKClick
            Glyph.Data = {
              DE010000424DDE01000000000000760000002800000024000000120000000100
              0400000000006801000000000000000000001000000010000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
              3333333333333333333333330000333333333333333333333333F33333333333
              00003333344333333333333333388F3333333333000033334224333333333333
              338338F3333333330000333422224333333333333833338F3333333300003342
              222224333333333383333338F3333333000034222A22224333333338F338F333
              8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
              33333338F83338F338F33333000033A33333A222433333338333338F338F3333
              0000333333333A222433333333333338F338F33300003333333333A222433333
              333333338F338F33000033333333333A222433333333333338F338F300003333
              33333333A222433333333333338F338F00003333333333333A22433333333333
              3338F38F000033333333333333A223333333333333338F830000333333333333
              333A333333333333333338330000333333333333333333333333333333333333
              0000}
            NumGlyphs = 2
          end
          object btnCancel: TBitBtn
            Left = 112
            Top = 167
            Width = 75
            Height = 25
            Anchors = [akRight, akBottom]
            Caption = '&Cancel'
            TabOrder = 2
            Kind = bkCancel
          end
          object pnlcbAddendum: TPanel
            Left = 13
            Top = 42
            Width = 151
            Height = 23
            BevelOuter = bvNone
            TabOrder = 3
            object imageAddendum: TImage
              Left = 6
              Top = 2
              Width = 16
              Height = 16
              Picture.Data = {
                07544269746D617036030000424D360300000000000036000000280000001000
                0000100000000100180000000000000300000000000000000000000000000000
                0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
                00000000000000000000000000000000000000000000000000000000FFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000F4FDFDF4FDFDF4FDFDF4FDFDF4FDFD
                F4FDFDF4FDFDF4FDFD000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
                00F4FDFDF4FDFDF4FDFDF4FDFDF4FDFDF4FDFDF4FDFDF4FDFD000000FFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000F4FDFDF4FDFDF4FDFDF4FDFDF4FDFD
                F4FDFDF4FDFDF4FDFD000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
                00F4FDFDF4FDFDF4FDFDF4FDFDF4FDFDF4FDFDF4FDFDF4FDFD000000FFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000F4FDFDF4FDFDF4FDFD000000F4FDFD
                F4FDFDF4FDFDF4FDFD000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
                00F4FDFDF4FDFDF4FDFD000000F4FDFDF4FDFDF4FDFDF4FDFD000000FFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000F4FDFD000000000000000000000000
                000000F4FDFDF4FDFD000000FFFFFFFFFFFF80C8DC92DAE492E7F430C0F0A0F0
                FFA0E8FF90D8F0F4FDFD000000F4FDFDF4FDFDF4FDFDF4FDFD000000FFFFFFFF
                FFFFA6E3EB30B8E080E8FF50C8F090F0FF20B8E060C0FFF4FDFD000000F4FDFD
                F4FDFDF4FDFDF4FDFD000000FFFFFFFFFFFF9EE8F590F0FFC0F8FFB0E8F0C0F8
                FF90F0FFA0F0FFF4FDFDF4FDFDF4FDFDF4FDFDF4FDFDF4FDFD000000FFFFFFFF
                FFFF10B0E050C0E0B0E8F0F0FFFFB0F0FF50C0E030C0F0F4FDFDF4FDFDF4FDFD
                F4FDFDF4FDFDF4FDFD000000FFFFFFFFFFFF9EE8F590F0FFC0F8FFB0E8F0C0F8
                FF90F0FFA0F0FF000000000000000000000000000000000000000000FFFFFFFF
                FFFFA6E3EB30B8E090F0FF50C8F090F0FF30B8E090C8D0FFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF72C4DD92DAE49EE7F420B0E092E6
                F39DDCE68DC8D5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFF}
              Transparent = True
            end
            object cbAddendum: TCheckBox
              Left = 32
              Top = 1
              Width = 107
              Height = 17
              Caption = 'Make Addendum'
              TabOrder = 0
              OnClick = cbAddendumClick
            end
          end
        end
        object pnlAddendum: TPanel
          Left = 2
          Top = 247
          Width = 640
          Height = 113
          Align = alBottom
          BevelOuter = bvNone
          Caption = 'pnlAddendum'
          Color = clActiveBorder
          TabOrder = 2
          Visible = False
          object lbAddendum: TLabel
            Left = 0
            Top = 0
            Width = 640
            Height = 21
            Align = alTop
            AutoSize = False
            Caption = '  Enter Text of the Addendum:          (Optional)'
            Color = clBtnFace
            ParentColor = False
            Layout = tlCenter
            ExplicitWidth = 605
          end
          object memAddNoteText: TMemo
            Left = 0
            Top = 21
            Width = 470
            Height = 92
            Align = alClient
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
          object rgrp2Addendum: TRadioGroup
            Left = 470
            Top = 21
            Width = 170
            Height = 92
            Align = alRight
            Anchors = [akTop, akRight]
            Caption = 'Addendum Status: '
            Color = cl3DLight
            ItemIndex = 0
            Items.Strings = (
              'Un-Signed'
              'Signed'
              'Electronically Filed')
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            TabStop = True
            OnClick = rgrp2AddendumClick
          end
        end
      end
    end
    object tabshNew: TTabSheet
      Caption = 'Create New Note'
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object spltTitle: TSplitter
        Left = 0
        Top = 394
        Width = 644
        Height = 7
        Cursor = crVSplit
        Align = alBottom
        Beveled = True
        OnCanResize = spltTitleCanResize
        ExplicitTop = 289
        ExplicitWidth = 609
      end
      object pnlNewText: TPanel
        Left = 0
        Top = 401
        Width = 644
        Height = 200
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'pnlNewText'
        TabOrder = 0
        OnResize = pnlNewTextResize
        object Label5: TLabel
          Left = 0
          Top = 0
          Width = 644
          Height = 24
          Align = alTop
          AutoSize = False
          Caption = '  Enter Text of the Note:          (Optional)'
          Layout = tlCenter
          ExplicitWidth = 609
        end
        object memNewNoteText: TMemo
          Left = 38
          Top = 44
          Width = 518
          Height = 137
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object pnltitles: TPanel
        Left = 0
        Top = 0
        Width = 644
        Height = 394
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pnlTitles'
        Constraints.MinHeight = 280
        TabOrder = 1
        DesignSize = (
          644
          394)
        object Label2: TLabel
          Left = 12
          Top = 10
          Width = 31
          Height = 13
          Caption = 'Author'
        end
        object Label3: TLabel
          Left = 12
          Top = 68
          Width = 63
          Height = 13
          Caption = 'Visit Location'
        end
        object lbNewNoteTitle: TLabel
          Left = 216
          Top = 261
          Width = 61
          Height = 13
          Anchors = [akLeft, akBottom]
          Caption = '< Note Title>'
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clActiveCaption
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          ExplicitTop = 196
        end
        object Panel3: TPanel
          Left = 212
          Top = 30
          Width = 430
          Height = 222
          Anchors = [akLeft, akTop, akRight, akBottom]
          BevelOuter = bvNone
          Color = clAppWorkSpace
          TabOrder = 4
          ExplicitHeight = 224
          DesignSize = (
            430
            222)
          object mlvTitles: TMagListView
            Left = 0
            Top = -4
            Width = 430
            Height = 226
            Anchors = [akLeft, akTop, akRight, akBottom]
            Columns = <
              item
              end
              item
              end>
            TabOrder = 2
            OnChange = mlvTitlesChange
            OnDblClick = mlvTitlesDblClick
            OnEnter = mlvTitlesEnter
            OnKeyDown = mlvTitlesKeyDown
            OnKeyUp = mlvTitlesKeyUp
            OnSelectItem = mlvTitlesSelectItem
            ExplicitHeight = 228
          end
          object pnlScrollTxt: TPanel
            Left = 381
            Top = 18
            Width = 34
            Height = 21
            Anchors = [akTop, akRight]
            BevelInner = bvLowered
            Color = clInfoBk
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
            Visible = False
          end
          object scbarTitles: TScrollBar
            Left = 412
            Top = 0
            Width = 18
            Height = 222
            Align = alRight
            Kind = sbVertical
            LargeChange = 26
            Max = 676
            Min = 1
            PageSize = 0
            Position = 1
            TabOrder = 0
            TabStop = False
            OnEnter = scbarTitlesEnter
            OnKeyDown = scbarTitlesKeyDown
            OnScroll = scbarTitlesScroll
            ExplicitHeight = 224
          end
        end
        object btnNewNoteOK: TBitBtn
          Left = 256
          Top = 284
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          Caption = 'OK'
          Enabled = False
          TabOrder = 5
          OnClick = btnNewNoteOKClick
          Glyph.Data = {
            DE010000424DDE01000000000000760000002800000024000000120000000100
            0400000000006801000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            3333333333333333333333330000333333333333333333333333F33333333333
            00003333344333333333333333388F3333333333000033334224333333333333
            338338F3333333330000333422224333333333333833338F3333333300003342
            222224333333333383333338F3333333000034222A22224333333338F338F333
            8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
            33333338F83338F338F33333000033A33333A222433333338333338F338F3333
            0000333333333A222433333333333338F338F33300003333333333A222433333
            333333338F338F33000033333333333A222433333333333338F338F300003333
            33333333A222433333333333338F338F00003333333333333A22433333333333
            3338F38F000033333333333333A223333333333333338F830000333333333333
            333A333333333333333338330000333333333333333333333333333333333333
            0000}
          NumGlyphs = 2
          ExplicitTop = 286
        end
        object btnNewNoteCancel: TBitBtn
          Left = 382
          Top = 285
          Width = 75
          Height = 25
          Anchors = [akLeft, akBottom]
          TabOrder = 6
          Kind = bkCancel
          ExplicitTop = 287
        end
        object edtAuthor: TEdit
          Left = 12
          Top = 32
          Width = 157
          Height = 21
          Hint = 'Search for an Author'#39's last name that matches the entered text'
          TabOrder = 0
          OnEnter = edtAuthorEnter
          OnKeyDown = edtAuthorKeyDown
          OnKeyUp = edtAuthorKeyUp
        end
        object edtLoc: TEdit
          Left = 12
          Top = 92
          Width = 157
          Height = 21
          Hint = 'Search for a Hospital Location that matches the entered text'
          TabOrder = 1
          OnEnter = edtLocEnter
          OnKeyDown = edtLocKeyDown
          OnKeyUp = edtLocKeyUp
        end
        object rgrp2NewNoteStatus: TRadioGroup
          Left = 12
          Top = 144
          Width = 160
          Height = 111
          Caption = 'New Note &Status'
          ItemIndex = 0
          Items.Strings = (
            'Un-Signed'
            'Signed'
            'Electronically Filed')
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          TabStop = True
          OnClick = rgrp2NewNoteStatusClick
          OnEnter = rgrp2NewNoteStatusEnter
        end
        object edtTitle: TEdit
          Left = 213
          Top = 6
          Width = 411
          Height = 21
          Hint = 
            'Search Personnal title list, then list all titles, starting with' +
            ' title that matches the entered text'
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 3
          Text = ' <title>'
          OnEnter = edtTitleEnter
          OnExit = edtTitleExit
          OnKeyDown = edtTitleKeyDown
          OnKeyUp = edtTitleKeyUp
        end
        object btnAuthor: TBitBtn
          Left = 147
          Top = 34
          Width = 20
          Height = 18
          TabOrder = 7
          TabStop = False
          OnClick = btnAuthorClick
          Glyph.Data = {
            C6000000424DC60000000000000076000000280000000A0000000A0000000100
            0400000000005000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFF007FFFF00
            0000FF00777FFF000000F00FFF77FF00000000FFFFF77F000000000007777700
            0000FFFF07FFFF000000FFFF07FFFF000000FFFF07FFFF000000FFFF07FFFF00
            0000FFFF07FFFF000000}
        end
        object btnLoc: TBitBtn
          Left = 147
          Top = 94
          Width = 20
          Height = 18
          TabOrder = 8
          TabStop = False
          OnClick = btnLocClick
          Glyph.Data = {
            C6000000424DC60000000000000076000000280000000A0000000A0000000100
            0400000000005000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFF007FFFF00
            0000FF00777FFF000000F00FFF77FF00000000FFFFF77F000000000007777700
            0000FFFF07FFFF000000FFFF07FFFF000000FFFF07FFFF000000FFFF07FFFF00
            0000FFFF07FFFF000000}
        end
        object Button2: TButton
          Left = 4
          Top = 328
          Width = 213
          Height = 25
          Caption = 'Test : Set focus to 4th [3] item in list.'
          TabOrder = 9
          Visible = False
          OnClick = Button2Click
        end
      end
      object mlvAuthor: TMagListView
        Left = 31
        Top = 55
        Width = 311
        Height = 49
        BevelOuter = bvRaised
        BevelKind = bkSoft
        BorderWidth = 2
        Columns = <>
        TabOrder = 2
        TabStop = False
        Visible = False
        OnClick = mlvAuthorClick
        OnEnter = mlvAuthorEnter
        OnExit = mlvAuthorExit
        OnSelectItem = mlvAuthorSelectItem
      end
      object mlvLoc: TMagListView
        Left = 38
        Top = 114
        Width = 223
        Height = 48
        BevelOuter = bvRaised
        BevelKind = bkSoft
        BorderWidth = 2
        Columns = <>
        TabOrder = 3
        TabStop = False
        Visible = False
        OnClick = mlvLocClick
        OnEnter = mlvLocEnter
        OnExit = mlvLocExit
        OnSelectItem = mlvLocSelectItem
      end
    end
  end
  object btnVisit: TButton
    Left = 624
    Top = 324
    Width = 75
    Height = 25
    Caption = 'Visit...'
    TabOrder = 2
    TabStop = False
    Visible = False
    OnClick = btnVisitClick
  end
  object MainMenu1: TMainMenu
    Images = imglst16w
    Left = 214
    Top = 5
    object mnuFile: TMenuItem
      AutoHotkeys = maManual
      Caption = '&File'
      object mnuSave: TMenuItem
        Caption = 'Save'
        ShortCut = 16467
      end
      object mnuNewAddendum: TMenuItem
        Caption = 'Addendum Unsigned Note? --'
        Visible = False
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object mnuOptionsSelect: TMenuItem
      Caption = '&Options'
      object mnuNewNote: TMenuItem
        Caption = 'Create Note...'
        ImageIndex = 4
        OnClick = mnuNewNoteClick
      end
      object mnuAddendum: TMenuItem
        Caption = 'Make Addendum'
        ImageIndex = 3
        OnClick = mnuAddendumClick
      end
      object mnuSignNote: TMenuItem
        Caption = 'Sign Note...'
        OnClick = mnuSignNoteClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object mnuClearText: TMenuItem
        Caption = 'Clear Text'
        OnClick = mnuClearTextClick
      end
      object mnuEnableTextEntry: TMenuItem
        Caption = 'Enable Text Entry'
        Visible = False
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object mnuRefresh: TMenuItem
        Caption = 'Refresh '
        OnClick = mnuRefreshClick
      end
      object mnuPreviewNote: TMenuItem
        Caption = '&Preview Selection'
        OnClick = mnuPreviewNoteClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuFitToText: TMenuItem
        Caption = 'Fit Columns to Text'
        OnClick = mnuFitToTextClick
      end
      object mnuFitToWindow: TMenuItem
        Caption = 'Fit Columns to Window'
        OnClick = mnuFitToWindowClick
      end
      object SelectColumns1: TMenuItem
        Caption = 'Select Columns...'
        OnClick = SelectColumns1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuListOptions: TMenuItem
        Caption = 'List Options...'
        OnClick = mnuListOptionsClick
      end
      object mnuFont: TMenuItem
        Caption = '&Font...'
        OnClick = mnuFontClick
      end
      object mnuClearAuthor: TMenuItem
        Caption = '&Clear Author'
        Visible = False
        OnClick = mnuClearAuthorClick
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object ResetPanelsize2: TMenuItem
        Caption = 'Reset Panel Size'
        OnClick = ResetPanelsize2Click
      end
    end
    object mnuOptionsCreate: TMenuItem
      Caption = '&Options'
      Visible = False
      object mnuSelectNote: TMenuItem
        Caption = 'Select Note...'
        OnClick = mnuSelectNoteClick
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object ClearText1: TMenuItem
        Caption = 'Clear Text'
        GroupIndex = 1
        OnClick = ClearText1Click
      end
      object UserBoilerplateifexist1: TMenuItem
        Caption = 'User Boilerplate if any exists '
        GroupIndex = 1
        Visible = False
        OnClick = UserBoilerplateifexist1Click
      end
      object N10: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object mnuFitToTextm2: TMenuItem
        Caption = 'Fit Columns to Text'
        GroupIndex = 1
        OnClick = mnuFitToTextClick
      end
      object mnuFitToWindowm2: TMenuItem
        Caption = 'Fit Columns to Window'
        GroupIndex = 1
        OnClick = mnuFitToWindowClick
      end
      object N8: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object ListOptions1: TMenuItem
        Caption = 'List Options...'
        GroupIndex = 1
        OnClick = ListOptions1Click
      end
      object Font1: TMenuItem
        Caption = '&Font...'
        GroupIndex = 1
        OnClick = Font1Click
      end
      object N7: TMenuItem
        Caption = '-'
        GroupIndex = 1
      end
      object ResetPanelsize1: TMenuItem
        Caption = 'Reset Panel size'
        GroupIndex = 1
        OnClick = ResetPanelsize1Click
      end
    end
    object mnuView: TMenuItem
      Caption = '&View'
      OnClick = mnuViewClick
      object mnuSummaries: TMenuItem
        Caption = '&D/C Summaries'
        RadioItem = True
        Visible = False
      end
      object mnuConsults: TMenuItem
        Caption = 'Consul&ts'
        RadioItem = True
        Visible = False
      end
      object mnuShowAddendums: TMenuItem
        AutoCheck = True
        Caption = 'Show Related Notes/Addendums'
        Hint = 'Show related Notes or Addendums for signed/unsigned items'
        OnClick = mnuShowAddendumsClick
      end
      object N2: TMenuItem
        Caption = '-'
        RadioItem = True
      end
      object mnuMine: TMenuItem
        Caption = '&My Signed Notes'
        Hint = 'List all Signed Notes with you as the Author.'
        OnClick = mnuMineClick
      end
      object mnuSigned: TMenuItem
        Tag = 1
        Caption = '&Signed Notes (All)'
        Hint = 'List all Signed Notes.'
        OnClick = mnuSignedClick
      end
      object mnuUnSigned: TMenuItem
        Tag = 2
        Caption = '&UnSigned Notes'
        Hint = 'List all of your UnSigned Notes.'
        OnClick = mnuUnSignedClick
      end
      object mnuUnCosigned: TMenuItem
        Tag = 3
        Caption = 'Un&Cosigned Notes'
        Hint = 'List all of your UnCoSigned Notes.'
        OnClick = mnuUnCosignedClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mnuAuthor: TMenuItem
        Tag = 4
        Caption = 'Signed Notes by &Author...'
        Hint = 'List all Signed Notes of the selected Author.'
        OnClick = mnuAuthorClick
      end
      object tabbingseq1: TMenuItem
        Caption = 'tabbing seq'
        Visible = False
        OnClick = tabbingseq1Click
      end
    end
    object mnuHelp: TMenuItem
      Caption = '&Help'
      OnClick = mnuHelpClick
      object mnuHelpSelectProgressNote: TMenuItem
        Caption = '&Select Progress Note'
        HelpContext = 10156
        OnClick = mnuHelpSelectProgressNoteClick
      end
      object mnuTest: TMenuItem
        Caption = 'Test'
        Visible = False
        object mnuTestShowColumnWidths: TMenuItem
          Caption = 'Show Columns Widths'
          ShortCut = 49236
          OnClick = mnuTestShowColumnWidthsClick
        end
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    OnApply = FontDialog1Apply
    Left = 432
  end
  object imglst16w: TImageList
    Left = 236
    Top = 456
    Bitmap = {
      494C01011A001D00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000007000000001002000000000000070
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
      0000000000000000000000000000000000004040000040400000404000004040
      0000404000004040000040400000404000004040000040400000404000004040
      00000000000000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080400000B1DBDE00B1DBDE008040
      000080400000B1DBDE00B1DBDE00804000008040000080400000B1DBDE00B1DB
      DE000000000040808000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080400000B1DBDE0080400000B1DB
      DE00B1DBDE00B1DBDE0080400000B1DBDE00B1DBDE0080400000B1DBDE00B1DB
      DE00000000004080800000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080400000B1DBDE0080400000B1DB
      DE0080400000B1DBDE0080400000B1DBDE00B1DBDE0080400000B1DBDE00B1DB
      DE00000000004080800000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080400000B1DBDE00B1DBDE008040
      0000B1DBDE00B1DBDE00B1DBDE00804000008040000080400000B1DBDE00B1DB
      DE00000000004080800000000000000000000000000000000000000000000000
      0000000000000000000000FFFF000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080400000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE0080400000B1DBDE00B1DB
      DE00000000004080800000000000000000000000000000000000000000000000
      0000000000000000000000FFFF000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000080400000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE0080400000B1DBDE00B1DB
      DE00000000004080800000000000000000000000000000000000000000000000
      00000000000000FFFF000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE000000
      0000000000004080800000000000000000000000000000000000000000000000
      00000000000000FFFF000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004040000040400000404000004040
      0000404000004040000040400000404000004040000040400000404000004040
      0000408080004080800000000000000000000000000000000000000000000000
      0000C0C0C00000000000000000000000000000000000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004080800040808000408080004080
      8000408080004080800040808000408080004080800040808000408080004080
      8000408080000000000000000000000000000000000000000000000000000000
      00000000FF00000000000000000000000000000000000000FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000FF000000FF00000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000004040
      0000404000004040000040400000404000000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B1DBDE00B1DB
      DE0080400000804000008040000080400000B1DBDE00B1DBDE00B1DBDE008040
      0000B1DBDE00B1DBDE0080400000B1DBDE000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B1DBDE00B1DB
      DE0080400000B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE008040
      0000B1DBDE00B1DBDE0080400000B1DBDE000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B1DBDE00B1DB
      DE0080400000B1DBDE00B1DBDE00B1DBDE008040000080400000B1DBDE008040
      0000B1DBDE00B1DBDE0080400000B1DBDE000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B1DBDE00B1DB
      DE00804000008040000080400000B1DBDE00B1DBDE00B1DBDE00B1DBDE008040
      000080400000B1DBDE0080400000B1DBDE00000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B1DBDE00B1DB
      DE0080400000B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE008040
      0000B1DBDE00B1DBDE00B1DBDE00B1DBDE000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000B1DBDE00B1DB
      DE0080400000804000008040000080400000B1DBDE00B1DBDE00B1DBDE008040
      000080400000B1DBDE0080400000B1DBDE0000000000000000000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000404000004040000040400000404000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000408080004080
      8000408080004080800040808000408080004080800040808000408080004080
      8000408080004080800040808000408080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
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
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
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
      0000000000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000080000000800000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000080
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000080000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      000000800000008000000080000000800000800000000000000000FFFF000000
      00000000000000000000000000000000000000000000800000000080000000FF
      000000800000800000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000008000
      00000080000000FF000000800000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000080
      00000080000000FF00000080000000800000008000000000000000FFFF000000
      000000000000000000000000000000000000800000000080000000FF000000FF
      000000800000800000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000080
      000000FF000000FF000000800000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000080000000008000000080
      000000FF00000000000000FF00000080000000800000008000000000000000FF
      FF00000000000000000000000000000000000080000000FF0000000000000000
      000000FF000000800000800000000000000000000000000000000000000000FF
      FF000000000000000000000000000000000000000000000000000000000000FF
      0000000000000000000000FF0000008000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      00000000000000000000000000000000000000000000008000000080000000FF
      000000000000000000000000000000FF000000800000008000000000000000FF
      FF000000000000000000000000000000000000FF000000000000000000000000
      000000FF000000800000800000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000FF000000FF00000000
      00000000000000000000000000000000000000FF000000800000008000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000800000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000800000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF00000080
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000008000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000800000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000008000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000800000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000000000C0C0C000000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000080000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000080000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      00000000000000000000000000000000000000FF000000800000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
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
      0000000000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008000000000800000008000008000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      00000080000000800000008000000080000080000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00008000A00000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000080
      00000080000000FF000000800000008000000080000080000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000080000000008000000080
      000000FF00000000000000FF0000008000000080000000800000800000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      00000000000000000000000000000000000000000000008000000080000000FF
      000000000000000000000000000000FF00000080000000800000008000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000020A00000000000FFFFFF0000000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000FF000000FF00000000
      00000000000000000000000000000000000000FF000000800000008000008000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000000000000020A0000000000000000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008000000080
      00008000000000000000C0C0C000000000000000000000000000000000000000
      00000000000000000000FFFFFF00C0C0C000000000000020A00000000000C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF00000080
      000000800000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00C0C0C000000000000020A0000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000800000000000000000FF000000FF000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00C0C0C000000000000020
      A00000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000080000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      00000020A0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000020A00000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000020A000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF0000000000000000000000000000000000
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
      0000000000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000080000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000080
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      00000080000000FF000000800000800000000000000000000000000000000000
      00000000000000000000000000000000000000000000800000000080000000FF
      000000800000800000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      000000FF000000FF000000800000800000000000000000000000000000000000
      000000000000000000000000000000000000000000000080000000FF000000FF
      000000800000800000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      0000000000000000000000FF0000008000008000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000000000000000
      000000FF000000800000800000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000800000800000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000800000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000080000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000800000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000008000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000008000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000000000000000000000000
      00000000000000000000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000000000000000000000000
      000000000000000000000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000000000000000
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
      000000000000EDF8F800EDF8F800EDF8F800EDF8F800EDF8F800EDF8F800EDF8
      F800EDF8F8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EDF8F80000000000000000000000000000000000EDF8F800EDF8
      F800EDF8F80000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EDF8F800EDF8F800EDF8F800EDF8F800EDF8F800EDF8F800EDF8
      F800EDF8F8000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EDF8F80000000000000000000000000000000000000000000000
      0000EDF8F80000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EDF8F800EDF8F800EDF8F800EDF8F800EDF8F800EDF8F800EDF8
      F800EDF8F8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EDF8F80000000000000000000000000000000000000000000000
      0000EDF8F8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EDF8F800EDF8F800EDF8F800EDF8F800EDF8F800EDF8F800EDF8
      F800EDF8F8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      00000000000000000000000000000000000080C8DC0092DAE40092E7F40030C0
      F000A0F0FF00A0E8FF0090D8F0000000000000000000EDF8F800000000000000
      0000EDF8F8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C0000000000000FFFF00FFFF000000000000FFFF000000000000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000000000000000000000000000A6E3EB0030B8E00080E8FF0050C8
      F00090F0FF0020B8E00060C0FF00EDF8F800EDF8F800EDF8F800EDF8F800EDF8
      F800EDF8F8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C00000FFFF0000000000C0C0C000FFFF000000000000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000009EE8F50090F0FF00C0F8FF00B0E8
      F000C0F8FF0090F0FF00A0F0FF0000000000EDF8F80000000000000000000000
      0000EDF8F8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      800000000000C0C0C000C0C0C000FFFF000000000000FFFF000000000000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF0000000000000000000000000010B0E00050C0E000B0E8F000F0FF
      FF00B0F0FF0050C0E00030C0F000EDF8F800EDF8F800EDF8F800EDF8F800EDF8
      F800EDF8F8000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFF000000000000FFFF000000000000FFFF000000000000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009EE8F50090F0FF00C0F8FF00B0E8
      F000C0F8FF0090F0FF00A0F0FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A6E3EB0030B8E00090F0FF0050C8
      F00090F0FF0030B8E00090C8D000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000072C4DD0092DAE4009EE7F40020B0
      E00092E6F3009DDCE6008DC8D500000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FD
      FD00F4FDFD0000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FD
      FD00F4FDFD000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      00000080000000FF000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FD
      FD00F4FDFD0000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FF000000FF000000FF000000FF000000FF000000FF000000008000000080
      0000000000000000000000000000000000000000000000000000000000000080
      000000FF000000FF000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FD
      FD00F4FDFD000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFF0000FFFFFF00FFFF0000FFFFFF000080000000800000008000000080
      00000000000000000000000000000000000000000000000000000000000000FF
      0000000000000000000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F4FDFD00F4FDFD00F4FDFD0000000000F4FDFD00F4FDFD00F4FD
      FD00F4FDFD000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000008000000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F4FDFD00F4FDFD00F4FDFD0000000000F4FDFD00F4FDFD00F4FD
      FD00F4FDFD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFF0000C0C0C000C0C0C000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000F4FDFD000000000000000000000000000000000000000000F4FD
      FD00F4FDFD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C000FFFFFF0000FFFF00C0C0C000FFFFFF00FFFF0000FFFFFF00FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000000000000000000000000
      00000000000000000000000000000000000080C8DC0092DAE40092E7F40030C0
      F000A0F0FF00A0E8FF0090D8F000F4FDFD0000000000F4FDFD00F4FDFD00F4FD
      FD00F4FDFD000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000C0C0C00000FFFF00FFFFFF00C0C0C000FFFF0000FFFFFF00FFFF0000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000800000000000000000
      000000000000000000000000000000000000A6E3EB0030B8E00080E8FF0050C8
      F00090F0FF0020B8E00060C0FF00F4FDFD0000000000F4FDFD00F4FDFD00F4FD
      FD00F4FDFD000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000FFFFFF00C0C0C000C0C0C000FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000800000000000000000
      0000000000000000000000000000000000009EE8F50090F0FF00C0F8FF00B0E8
      F000C0F8FF0090F0FF00A0F0FF00F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FD
      FD00F4FDFD000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000008080
      8000FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFFFF00FFFF0000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000010B0E00050C0E000B0E8F000F0FF
      FF00B0F0FF0050C0E00030C0F000F4FDFD00F4FDFD00F4FDFD00F4FDFD00F4FD
      FD00F4FDFD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000009EE8F50090F0FF00C0F8FF00B0E8
      F000C0F8FF0090F0FF00A0F0FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000A6E3EB0030B8E00090F0FF0050C8
      F00090F0FF0030B8E00090C8D000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000072C4DD0092DAE4009EE7F40020B0
      E00092E6F3009DDCE6008DC8D500000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000700000000100010000000000800300000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFF800100000000
      FFFFFFFF00000000000FAF7B000000000007DE73000000000003AE7300000000
      0003FC63000000000003FC63000000000003F8C7000000000003F8C700000000
      0003F18F000000000003F18F000000000003E31F000000000007E31F00000000
      FFFFC21F00000000FFFFE73F00000000FEFFFFFFFFFFFFFFFCFF8001FFFFFFFF
      FCFFFFFFFFFFFFFFF8FFAFBFFFFFC000F8FFDF9FFFFF8000F1FFAF9FFF3F8000
      F1FFFF8FFFDF8000E3FFFF8F9B158000E3FFFFC7EAD58000C7FFFFC7BAD58000
      C7FFFFE3CB13800087FFFFE3FFFF8000CFFFFFF1FBFFC000FFFFFFF1FFFFC000
      FFFFFFF0FFFFFFFFFFFFFFF9FFFFFFFF00000000FFFFFEFFFFBFFFBFFFFFFE7F
      F99FE79FF9FFFE7FF09FC79FF1FFFE3FE00F838FE0FFFE3FC00F038FE0FFFF1F
      840731C7EC7FFF1F8E0771C7FC7FFF8F9F03F8E3FE3FFF8FFF83F8E3FE3FFFC7
      FFC1FC71FF1FFFC7FFE1FC71FF1FFFE3FFF0FE38FF9FFFE3FFF8FE38FF9FFFE1
      FFF8FF38FFFFFFF3FFFCFF3CFFFFFFFFFFFF00000000FFDFFFFFFEFFFEFFFFCF
      FFFFFE7FFE7FF9CFDFFFFE7FFE7FF0C7E781FE3FFE3FE047E000FE3FFE3FC023
      F000FF1FFF1F8403F800FF1FFF1F8E11F800FF8FFF8F9F01F800FF8FFF8FFF80
      F800FFC7FFC7FFC0FC00FFC7FFC7FFE0FE00FFC3FFE3FFF0FF00FFE7FFE3FFF8
      FF80FFFFFFE1FFFCFFF8FFFFFFF3FFFEFFFFFFFF00000000FE7FFFFFFFBFFE7F
      FE3FF9FFE79FFE3FFE3FF1FFC79FFE3FFE1FE0FF838FFE1FFE1FE0FF838FFE1F
      FF0FEC7FB1C7FF0FFF0FFC7FF1C7FF0FFF87FE3FF8E3FF87FF87FE3FF8E3FF87
      FFC3FF3FFC71FFC3FFC3FF3FFC71FFC3FFE1FFFFFE78FFE1FFE1FFFFFE78FFE1
      FFE0FFFFFFF8FFE0FFF1FFFFFFFCFFF1FFFFFFFFFFFFFEFFF0038001FFFFFE7F
      F003FFFFE007FE7FF003AFFFE007FE3FF003DFFFE00FFE3FF003AFFFE7F7FF1F
      F003FFFFE003FF1FF003FFFFE803FF8FF003FFFFE7F7FF8F0003FFFFE4AFFFC7
      0003FFFFE257FFC70003FFFFE8A7FFC30003FFFFE557FFE70003FFFFE007FFFF
      01FFFFFFFFFFFFFF01FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF803FFFFFFFFFF003
      FFFFE007FFFFF003AEFFE007FBFFF003DE7FE007F1FFF003AE7FE007E1FFF003
      FE3FE007ECFFF003FE3FE007FCFFF003FF1FE007FE7FF003FF1FE007FE7F0003
      FF8FE007FF3F0003FF8FE007FF3F0003FFC7E007FFFF0003FFC7E007FFFF0003
      FFC3FFFFFFFF01FFFFE7FFFFFFFF01FF00000000000000000000000000000000
      000000000000}
  end
  object timerLkp: TTimer
    Enabled = False
    Interval = 700
    OnTimer = timerLkpTimer
    Left = 296
    Top = 376
  end
  object imglstWide: TImageList
    Width = 32
    Left = 420
    Top = 461
    Bitmap = {
      494C010104000900040020001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000800000002000000001002000000000000040
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
      00000000000000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      0000000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000080000000FF
      00000080000000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000080000000FF
      00000080000000000000000000000000000000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080000000FF000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080000000FF000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000000000000000
      000000FF00000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000000000000000
      000000FF00000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF0000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000000000000000000000000000000000000000000000000000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF0000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000000000000000000000000000000000
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
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000080000000200000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      80000007FFFFFFFF8000000700000003FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      AFFFFEFFFFFFFFFFAFFF7EFFFCFFFFEFDFFFFE7FFFFFFFEFDFFF3E7FFF7FFFC7
      AFFFFE7FFFFEFFC7AFFF3E7F362B3187FFFFFE3FFFFEFF87FFFF1E3FD5AAEDB3
      FFFFFE3F99AA3623FFFF1E3FBAD556F3FFFFFF1F76AAD5D3FFFF8F1FCB13B8F9
      FFFFFF1F76AAD559FFFF8F1FFFFFFF79FFFFFF8F998636C9FFFFC78FFDFFFF7C
      FFFFFF8FFFFFF7DCFFFFC78FFFFFFFFCFFFFFFC7FFFFF7FCFFFFE3C7FFFFFFFF
      FFFFFFC7FFFFFFFFFFFFE3C7FFFFFFFFFFFFFFC3FFFFFFFFFFFFE1C3FFFFFFFF
      FFFFFFE7FFFFFFFFFFFFF3E7FFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object imglstWide2: TImageList
    Width = 56
    Left = 200
    Top = 547
    Bitmap = {
      494C010105000900040038001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000E00000002000000001002000000000000070
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000FF0000000000000000000000000000000000
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
      00000000000000000000FF000000000000000000000000000000000000000000
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
      000000000000FF00000000000000FF0000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
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
      00000000000000FFFF0000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000FFFF00000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
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
      0000000000000000000000FFFF00000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
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
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
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
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
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
      000000000000000000000000000000000000C0C0C00000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
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
      0000000000000000000000000000000000000000FF0000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
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
      0000000000000000000000000000000000000000FF000000FF00000000000000
      00000000000000000000000000000000FF000000FF0000000000000000000000
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
      0000000000000000000000000000000000000000000040400000404000004040
      0000404000004040000040400000404000004040000040400000404000004040
      0000404000004040000040400000404000004040000040400000404000004040
      0000404000004040000040400000404000004040000040400000404000004040
      0000404000004040000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000FF0000000000000000000000000000000000
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
      000000000000000000000080000000FF00000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000080000000FF00000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE0000000000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE0000000000B1DBDE0000000000B1DBDE00B1DBDE000000
      000000000000B1DBDE00B1DBDE00B1DBDE00000000000000000000000000B1DB
      DE00B1DBDE00B1DBDE0000000000408080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
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
      0000000000000080000000FF000000FF00000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080000000FF000000FF00000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE000000
      0000B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE0000000000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE0000000000B1DBDE0000000000B1DBDE0000000000B1DB
      DE00B1DBDE00B1DBDE00B1DBDE0000000000B1DBDE00B1DBDE0000000000B1DB
      DE00B1DBDE00B1DBDE0000000000408080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000FF0000000000000000000000000000000000
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
      00000000000000FF0000000000000000000000FF000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF0000000000000000000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE000000
      0000B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE000000
      000000000000B1DBDE00B1DBDE00B1DBDE0000000000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE0000000000B1DBDE0000000000B1DBDE00000000000000
      00000000000000000000B1DBDE0000000000B1DBDE00B1DBDE0000000000B1DB
      DE00B1DBDE00B1DBDE0000000000408080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE000000
      0000000000000000000000000000B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE000000000000000000000000000000
      0000B1DBDE00B1DBDE0000000000B1DBDE0000000000B1DBDE0000000000B1DB
      DE00B1DBDE0000000000B1DBDE0000000000B1DBDE00B1DBDE0000000000B1DB
      DE00B1DBDE00B1DBDE0000000000408080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE000000
      0000B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE0000000000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE0000000000B1DBDE0000000000B1DBDE00B1DBDE000000
      000000000000B1DBDE00B1DBDE00B1DBDE00000000000000000000000000B1DB
      DE00B1DBDE00B1DBDE0000000000408080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF0000008000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000080000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE000000
      0000B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE0000000000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE0000000000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE0000000000B1DB
      DE00B1DBDE00B1DBDE0000000000408080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF00000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE000000
      000000000000000000000000000000000000B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE000000000000000000000000000000
      000000000000B1DBDE0000000000B1DBDE0000000000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE0000000000B1DB
      DE00B1DBDE00B1DBDE0000000000408080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF00000080
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000800000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DBDE00B1DB
      DE00B1DBDE000000000000000000408080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000404000004040
      0000404000004040000040400000404000004040000040400000404000004040
      0000404000004040000040400000404000004040000040400000404000004040
      0000404000004040000040400000404000004040000040400000404000004040
      0000404000004040000040808000408080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      0000008000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FF0000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000004080800040808000408080004080
      8000408080004080800040808000408080004080800040808000408080004080
      8000408080004080800040808000408080004080800040808000408080004080
      8000408080004080800040808000408080004080800040808000408080004080
      8000408080004080800040808000408080004080800040808000408080004080
      8000408080004080800040808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF000000000000000000000000000000
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
      00000000000000000000000000000000FF000000FF0000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      28000000E0000000200000000100010000000000800300000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFFFF000000000000000000
      000000000000000000000000FFF80000007FFF00000000000000000000000000
      0000000000000000FFFFFFFFFFFFFF0000000000000000000000000000000000
      00000000FFFAFFF7EFFFFF000000000000000000000000000000000000000000
      FFFDFFF3E7FFFF000000000000000000000000000000000000000000FFFAFFF3
      E7FFFF000000000000000000000000000000000000000000FFFFFFF1E3FFFF00
      0000000000000000000000000000000000000000FFFFFFF1E3FFFF0000000000
      00000000000000000000000000000000FFFFFFF8F1FFFF000000000000000000
      000000000000000000000000FFFFFFF8F1FFFF00000000000000000000000000
      0000000000000000FFFFFFFC78FFFF0000000000000000000000000000000000
      00000000FFFFFFFC78FFFF000000000000000000000000000000000000000000
      FFFFFFFE3C7FFF000000000000000000000000000000000000000000FFFFFFFE
      3C7FFF000000000000000000000000000000000000000000FFFFFFFE1C3FFF00
      0000000000000000000000000000000000000000FFFFFFFF3E7FFF0000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFF80000007FFFFFFFFFFFFFFFFFFC00000001FFFFFF0000000003FFFFFFFF
      FFFFFFFFFFFFFDFFFFFEFFFFFFFFFFFFDFFFFE0000000001FFFFFAFFFFEFFFFF
      FFFFFDFFFFFC7FFFFF1FFFFF8FFFFE0000000000FFFFFDFFFFE7FFFFC38DB46C
      ECF87FFFFFF7FFFF0FFFFE0000000000FFFFFAFFFFE7FFFFBD75B5ABDBFB3FFF
      C6C5B38F67FFFE0000000000FFFFFFFFFFE3FFFFBF75B5A8587F3FFFDD5AD7B7
      E7FFFE0000000000FFFFFFFFFFE3FFFFBF75B5AB5B7F9FFFFD5AD0B7F3FFFE00
      00000000FFFFFFFFFFF1FFFFBF8C0C6CCCFF9FFFF1AD6B5BF3FFFE0000000000
      FFFFFFFFFFF1FFFFBDFFFFEFDFFFCFFFEFB11CE3F9FFFE0000000000FFFFFFFF
      FFF8FFFFC3FFFFEFFFFFCFFFF77FFFFDF9FFFE0000000000FFFFFFFFFFF8FFFF
      FFFFFFFFFFFFE7FFF8DFFFFDFCFFFF0000000000FFFFFFFFFFFC7FFFFFFFFFFF
      FFFFE7FFFFFFFFFFFCFFFF0000000001FFFFFFFFFFFC7FFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC3FFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFE7FFF00000000000000000000000000000000
      000000000000}
  end
end
