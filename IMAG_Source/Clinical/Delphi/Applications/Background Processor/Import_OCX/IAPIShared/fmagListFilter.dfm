object frmListFilter: TfrmListFilter
  Left = 552
  Top = 197
  Width = 728
  Height = 797
  HelpContext = 10093
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Image Filter Add/Edit:'
  Color = clBtnFace
  Constraints.MinHeight = 412
  Constraints.MinWidth = 580
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 265
    Width = 720
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 677
    Width = 720
    Height = 47
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object btnOK: TBitBtn
      Left = 22
      Top = 11
      Width = 75
      Height = 25
      Caption = '&OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
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
      Left = 391
      Top = 11
      Width = 75
      Height = 25
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 3
      OnClick = btnCancelClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
        F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
        000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
        338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
        45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
        3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
        F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
        000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
        338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
        4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
        8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
        333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
        0000}
      NumGlyphs = 2
    end
    object btnSave: TBitBtn
      Left = 144
      Top = 11
      Width = 75
      Height = 25
      Caption = '&Save...'
      TabOrder = 1
      OnClick = btnSaveClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333FFFFFFFFFFFFF33000077777770033377777777777773F000007888888
        00037F3337F3FF37F37F00000780088800037F3337F77F37F37F000007800888
        00037F3337F77FF7F37F00000788888800037F3337777777337F000000000000
        00037F3FFFFFFFFFFF7F00000000000000037F77777777777F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF00037F7F333333337F7F000FFFFFFFFF
        00037F7F333333337F7F000FFFFFFFFF07037F7F33333333777F000FFFFFFFFF
        0003737FFFFFFFFF7F7330099999999900333777777777777733}
      NumGlyphs = 2
    end
    object btnSaveAs: TBitBtn
      Left = 267
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Save &As...'
      TabOrder = 2
      OnClick = btnSaveAsClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
    end
  end
  object statbarWinMsg: TStatusBar
    Left = 0
    Top = 724
    Width = 720
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 720
    Height = 265
    Align = alTop
    Caption = 'pnlTop'
    TabOrder = 2
    object pgctrlFltList: TPageControl
      Left = 1
      Top = 1
      Width = 167
      Height = 263
      ActivePage = pgctrlFltListPublic
      Align = alLeft
      MultiLine = True
      TabOrder = 0
      OnChange = pgctrlFltListChange
      OnChanging = pgctrlFltListChanging
      object pgctrlFltListPrivate: TTabSheet
        Caption = 'Private'
        object lstFltListPrivate: TListBox
          Left = 0
          Top = 0
          Width = 159
          Height = 235
          Align = alClient
          ItemHeight = 13
          PopupMenu = mnuPrivatePopup
          Sorted = True
          TabOrder = 0
          OnClick = lstFltListPrivateClick
          OnDblClick = lstFltListPrivateDblClick
        end
      end
      object pgctrlFltListPublic: TTabSheet
        Caption = 'Public'
        object lstFltListPublic: TListBox
          Left = 0
          Top = 0
          Width = 159
          Height = 235
          Align = alClient
          ItemHeight = 13
          PopupMenu = mnuPrivatePopup
          Sorted = True
          TabOrder = 0
          OnClick = lstFltListPublicClick
          OnDblClick = lstFltListPublicDblClick
        end
      end
    end
    object pnlDetails: TPanel
      Left = 436
      Top = 20
      Width = 265
      Height = 225
      Caption = 'pnlDetails'
      TabOrder = 1
      Visible = False
      object lvDetails: TMagListView
        Left = 44
        Top = 44
        Width = 220
        Height = 180
        Color = clInfoBk
        Columns = <
          item
            Caption = 'Property'
          end
          item
            AutoSize = True
            Caption = 'Value'
          end>
        TabOrder = 0
      end
    end
    object lstDetails: TListBox
      Left = 212
      Top = 24
      Width = 161
      Height = 209
      Color = clInfoBk
      ItemHeight = 13
      TabOrder = 2
      OnClick = lstDetailsClick
    end
  end
  object Panel1: TPanel
    Left = 16
    Top = 268
    Width = 673
    Height = 387
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 3
    object pgctrlProps: TPageControl
      Left = 4
      Top = 0
      Width = 633
      Height = 373
      ActivePage = tsAdmin
      MultiLine = True
      TabOrder = 0
      object tsGeneral: TTabSheet
        Caption = 'General properties'
        ImageIndex = 2
        DesignSize = (
          625
          345)
        object Bevel1: TBevel
          Left = 295
          Top = 105
          Width = 270
          Height = 20
          Anchors = [akLeft, akTop, akRight]
        end
        object lbOriginValue: TLabel
          Left = 303
          Top = 106
          Width = 40
          Height = 13
          AutoSize = False
          Color = clActiveCaption
          ParentColor = False
          Layout = tlCenter
        end
        object lbOriginValueDefault: TLabel
          Left = 303
          Top = 106
          Width = 29
          Height = 13
          Caption = '<any>'
          Layout = tlCenter
        end
        object lbOrigin: TLabel
          Left = 20
          Top = 111
          Width = 92
          Height = 13
          Caption = 'Origin of the Image:'
        end
        object Bevel8: TBevel
          Left = 295
          Top = 23
          Width = 270
          Height = 20
          Anchors = [akLeft, akTop, akRight]
        end
        object lbClass: TLabel
          Left = 20
          Top = 27
          Width = 77
          Height = 13
          Caption = 'Class of Images:'
        end
        object lbCurFltClass: TLabel
          Left = 303
          Top = 24
          Width = 129
          Height = 18
          AutoSize = False
          Caption = '<selected class>'
          Layout = tlCenter
        end
        object cmboxDateRange: TComboBox
          Left = 117
          Top = 65
          Width = 130
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 3
          OnChange = cmboxDateRangeChange
          OnKeyDown = cmboxDateRangeKeyDown
          Items.Strings = (
            '1 Month'
            '3 Months'
            '6 Months'
            '1 Year'
            '2 Years'
            '5 Years'
            'All Dates'
            '<Select a Date Range>')
        end
        object pnlDateRangeLb: TPanel
          Left = 23
          Top = 65
          Width = 73
          Height = 21
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'Date Range:  '
          ParentColor = True
          TabOrder = 5
          object SpeedButton4: TSpeedButton
            Left = 76
            Top = 2
            Width = 21
            Height = 19
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000C0000000D0000000100
              04000000000068000000C40E0000C40E00001000000000000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
              0000888888888888000088888888888800008888888888880000888888888888
              0000888880888888000088880008888800008880000088880000880000000888
              0000888888888888000088888888888800008888888888880000888888888888
              0000}
            OnClick = SpeedButton4Click
          end
        end
        object pnlDateStuff1: TPanel
          Left = 295
          Top = 63
          Width = 233
          Height = 23
          BevelOuter = bvNone
          Color = clSkyBlue
          TabOrder = 6
          object pnlDateRange: TPanel
            Left = 2
            Top = 4
            Width = 201
            Height = 17
            BevelOuter = bvNone
            Color = clHighlightText
            TabOrder = 0
            OnClick = pnlDateRangeClick
            object lbRelativeRange: TLabel
              Left = 0
              Top = 0
              Width = 89
              Height = 13
              Align = alLeft
              Alignment = taCenter
              Caption = '<date range desc>'
              Layout = tlCenter
              OnClick = lbRelativeRangeClick
            end
          end
          object pnlDateSelect: TPanel
            Left = 2
            Top = 4
            Width = 205
            Height = 17
            BevelOuter = bvNone
            ParentColor = True
            TabOrder = 1
            OnClick = pnlDateSelectClick
            object Label2: TLabel
              Left = 2
              Top = 1
              Width = 26
              Height = 13
              Caption = 'From:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              OnClick = Label2Click
            end
            object Label3: TLabel
              Left = 104
              Top = 1
              Width = 16
              Height = 13
              Caption = 'To:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              OnClick = Label3Click
            end
            object lbValDtFrom: TLabel
              Left = 30
              Top = 1
              Width = 73
              Height = 13
              AutoSize = False
              Color = clHighlightText
              ParentColor = False
              OnClick = lbValDtFromClick
            end
            object lbValDtTo: TLabel
              Left = 122
              Top = 1
              Width = 77
              Height = 13
              AutoSize = False
              Color = clHighlightText
              ParentColor = False
              OnClick = lbValDtToClick
            end
          end
        end
        object btnSelect: TBitBtn
          Left = 135
          Top = 105
          Width = 75
          Height = 25
          Caption = 'Select...'
          TabOrder = 4
          OnClick = btnSelectClick
        end
        object btnClassClin: TBitBtn
          Left = 105
          Top = 21
          Width = 55
          Height = 25
          Caption = 'Clinical'
          TabOrder = 0
          OnClick = btnClassClinClick
        end
        object btnClassAdmin: TBitBtn
          Left = 165
          Top = 21
          Width = 75
          Height = 25
          Caption = 'Administrative'
          TabOrder = 1
          OnClick = btnClassAdminClick
        end
        object btnClassAny: TBitBtn
          Left = 246
          Top = 21
          Width = 37
          Height = 25
          Caption = 'Any'
          TabOrder = 2
          OnClick = btnClassAnyClick
        end
      end
      object tsAdmin: TTabSheet
        Caption = 'Admin properties'
        ImageIndex = 3
        DesignSize = (
          625
          345)
        object Label6: TLabel
          Left = 28
          Top = 34
          Width = 24
          Height = 13
          Caption = 'Type'
        end
        object SpeedButton1: TSpeedButton
          Left = 242
          Top = 88
          Width = 23
          Height = 22
          Caption = '>'
          OnClick = SpeedButton1Click
        end
        object SpeedButton2: TSpeedButton
          Left = 242
          Top = 120
          Width = 23
          Height = 22
          Caption = '<'
          OnClick = SpeedButton2Click
        end
        object SpeedButton3: TSpeedButton
          Left = 242
          Top = 153
          Width = 23
          Height = 22
          Caption = '<<'
          OnClick = SpeedButton3Click
        end
        object lbSelectedTypes: TLabel
          Left = 276
          Top = 34
          Width = 77
          Height = 13
          Caption = 'Selected Types:'
        end
        object cbAdminAll: TCheckBox
          Left = 8
          Top = 8
          Width = 185
          Height = 17
          Caption = 'All Administrative Documents'
          TabOrder = 0
          OnClick = cbAdminAllClick
        end
        object lstAdminTypes: TListBox
          Left = 27
          Top = 56
          Width = 199
          Height = 281
          Anchors = [akLeft, akTop, akBottom]
          Constraints.MinHeight = 50
          ItemHeight = 13
          Sorted = True
          TabOrder = 1
          OnDblClick = lstAdminTypesDblClick
          OnKeyDown = lstAdminTypesKeyDown
        end
        object lstAdminTypesSel: TListBox
          Left = 280
          Top = 56
          Width = 193
          Height = 281
          Anchors = [akLeft, akTop, akBottom]
          Constraints.MinHeight = 50
          ItemHeight = 13
          Sorted = True
          TabOrder = 2
          OnDblClick = lstAdminTypesSelDblClick
          OnKeyDown = lstAdminTypesSelKeyDown
        end
      end
      object tsClin: TTabSheet
        Caption = 'Clinical properties'
        ImageIndex = 4
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 625
          Height = 345
          Align = alClient
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          DesignSize = (
            625
            345)
          object lbClinProperty: TLabel
            Left = 8
            Top = 32
            Width = 75
            Height = 13
            Caption = 'VistA Packages'
          end
          object Bevel9: TBevel
            Left = 132
            Top = 40
            Width = 453
            Height = 5
          end
          object cbClinAll: TCheckBox
            Left = 8
            Top = 8
            Width = 109
            Height = 17
            Caption = 'All Clinical Images'
            TabOrder = 0
            OnClick = cbClinAllClick
          end
          object lstSpecs: TListBox
            Left = 132
            Top = 52
            Width = 201
            Height = 281
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            Sorted = True
            TabOrder = 2
            OnDblClick = lstSpecsDblClick
            OnKeyDown = lstSpecsKeyDown
          end
          object lstSpecsSel: TListBox
            Left = 372
            Top = 52
            Width = 209
            Height = 281
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            Sorted = True
            TabOrder = 3
            OnDblClick = lstSpecsSelDblClick
            OnKeyDown = lstSpecsSelKeyDown
          end
          object lstProcs: TListBox
            Left = 132
            Top = 52
            Width = 201
            Height = 281
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            Sorted = True
            TabOrder = 4
            OnDblClick = lstProcsDblClick
            OnKeyDown = lstProcsKeyDown
          end
          object lstProcsSel: TListBox
            Left = 372
            Top = 52
            Width = 209
            Height = 281
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            Sorted = True
            TabOrder = 5
            OnDblClick = lstProcsSelDblClick
            OnKeyDown = lstProcsSelKeyDown
          end
          object lstClinTypes: TListBox
            Left = 132
            Top = 52
            Width = 201
            Height = 281
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            Sorted = True
            TabOrder = 6
            OnDblClick = lstClinTypesDblClick
            OnKeyDown = lstClinTypesKeyDown
          end
          object lstClinTypesSel: TListBox
            Left = 372
            Top = 52
            Width = 209
            Height = 281
            Anchors = [akLeft, akTop, akBottom]
            ItemHeight = 13
            Sorted = True
            TabOrder = 7
            OnDblClick = lstClinTypesSelDblClick
            OnKeyDown = lstClinTypesSelKeyDown
          end
          object pnlPkgs: TPanel
            Left = 172
            Top = 52
            Width = 381
            Height = 77
            BevelOuter = bvNone
            BiDiMode = bdLeftToRight
            ParentBiDiMode = False
            ParentColor = True
            TabOrder = 8
            object cbRad: TCheckBox
              Left = 24
              Top = 10
              Width = 71
              Height = 17
              Hint = 'Images attached to Radiology Reports'
              Caption = 'Radiology'
              TabOrder = 0
              OnClick = cbPackageClick
            end
            object cbNote: TCheckBox
              Left = 24
              Top = 34
              Width = 51
              Height = 17
              Hint = 'Images attached to TIU Notes'
              Caption = 'Note'
              TabOrder = 1
              OnClick = cbPackageClick
            end
            object cbMed: TCheckBox
              Left = 105
              Top = 10
              Width = 63
              Height = 17
              Hint = 'Images attached to Medicine Reports'
              Caption = 'Medicine'
              TabOrder = 2
              OnClick = cbPackageClick
            end
            object cbCP: TCheckBox
              Left = 105
              Top = 34
              Width = 51
              Height = 13
              Hint = 'Images attached to the Clinical Procedures Package'
              Caption = 'CP'
              TabOrder = 3
              OnClick = cbPackageClick
            end
            object cbCnslt: TCheckBox
              Left = 185
              Top = 34
              Width = 59
              Height = 17
              Hint = 'unavailable'
              Caption = 'Consult'
              Enabled = False
              TabOrder = 5
              OnClick = cbPackageClick
            end
            object cbLab: TCheckBox
              Left = 266
              Top = 10
              Width = 45
              Height = 17
              Hint = 'Images attached to Lab'
              Caption = 'Lab'
              TabOrder = 6
              OnClick = cbPackageClick
            end
            object cbNone: TCheckBox
              Left = 266
              Top = 34
              Width = 97
              Height = 17
              Hint = 'Images that are not attached to a VistA Package'
              Caption = 'Un-Associated'
              TabOrder = 7
              OnClick = cbPackageClick
            end
            object cbSur: TCheckBox
              Left = 185
              Top = 10
              Width = 63
              Height = 17
              Hint = 'Images attached to Surgery Operations'
              Caption = 'Surgery'
              TabOrder = 4
              OnClick = cbPackageClick
            end
          end
          object pnlMoveBtns: TPanel
            Left = 339
            Top = 80
            Width = 30
            Height = 137
            BevelOuter = bvNone
            TabOrder = 9
            object sbtnClinSelOne: TSpeedButton
              Left = 2
              Top = 34
              Width = 23
              Height = 23
              Caption = '>'
              OnClick = sbtnClinSelOneClick
            end
            object sbtnClinUnSelOne: TSpeedButton
              Left = 2
              Top = 66
              Width = 23
              Height = 23
              Caption = '<'
              OnClick = sbtnClinUnSelOneClick
            end
            object sbtnClinSelAll: TSpeedButton
              Left = 2
              Top = 2
              Width = 23
              Height = 23
              Caption = '>>'
              Visible = False
              OnClick = sbtnClinSelAllClick
            end
            object sbtnClinUnSelAll: TSpeedButton
              Left = 2
              Top = 98
              Width = 23
              Height = 23
              Caption = '<<'
              OnClick = sbtnClinUnSelAllClick
            end
          end
          object TabControl1: TTabControl
            Left = 129
            Top = 9
            Width = 457
            Height = 22
            Style = tsButtons
            TabOrder = 1
            Tabs.Strings = (
              'Packages'
              'Clinical Types'
              'Specialty/SubSpec'
              'Procedure/Event')
            TabIndex = 0
            OnChange = TabControl1Change
          end
        end
      end
      object tsAdvanced: TTabSheet
        Caption = 'Advanced properties'
        ImageIndex = 3
        DesignSize = (
          625
          345)
        object Bevel15: TBevel
          Left = 260
          Top = 100
          Width = 361
          Height = 29
          Anchors = [akLeft, akTop, akRight]
        end
        object lbSavedByValue: TLabel
          Left = 268
          Top = 108
          Width = 3
          Height = 13
          Color = clMedGray
          ParentColor = False
        end
        object Bevel12: TBevel
          Left = 260
          Top = 68
          Width = 361
          Height = 29
          Anchors = [akLeft, akTop, akRight]
        end
        object lbStatusValueDefault: TLabel
          Left = 272
          Top = 76
          Width = 32
          Height = 13
          Caption = ' <any>'
        end
        object lbSavedByValueDefault: TLabel
          Left = 272
          Top = 108
          Width = 32
          Height = 13
          Caption = ' <any>'
        end
        object lbStaus: TLabel
          Left = 2
          Top = 79
          Width = 65
          Height = 13
          Caption = 'Image Status:'
        end
        object lbShortDescHas: TLabel
          Left = 2
          Top = 50
          Width = 99
          Height = 13
          Caption = 'Description contains:'
        end
        object Label17: TLabel
          Left = 2
          Top = 108
          Width = 80
          Height = 13
          Caption = 'Image Saved by:'
        end
        object lbStatusValue: TLabel
          Left = 268
          Top = 76
          Width = 3
          Height = 13
          Color = clMedGray
          ParentColor = False
        end
        object Label7: TLabel
          Left = 2
          Top = 22
          Width = 61
          Height = 13
          Caption = 'Date Range:'
        end
        object cbCaptureDate: TCheckBox
          Left = 108
          Top = 20
          Width = 221
          Height = 17
          Caption = 'Use Capture Date for Date Range'
          TabOrder = 0
          OnClick = cbCaptureDateClick
        end
        object edtShortDescHas: TEdit
          Left = 108
          Top = 44
          Width = 513
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
          OnChange = edtShortDescHasChange
          OnExit = edtShortDescHasExit
          OnKeyDown = edtShortDescHasKeyDown
        end
        object btnStatusSelect: TBitBtn
          Left = 102
          Top = 72
          Width = 69
          Height = 25
          Caption = 'Select...'
          TabOrder = 2
          OnClick = btnStatusSelectClick
        end
        object btnStatusAny: TBitBtn
          Left = 180
          Top = 72
          Width = 40
          Height = 25
          Caption = 'Any'
          TabOrder = 3
          OnClick = btnStatusAnyClick
        end
        object btnSavedby: TBitBtn
          Left = 102
          Top = 105
          Width = 69
          Height = 25
          Caption = 'Select...'
          TabOrder = 4
          OnClick = btnSavedbyClick
        end
        object btnSavedAny: TBitBtn
          Left = 180
          Top = 105
          Width = 40
          Height = 25
          Caption = 'Any'
          TabOrder = 5
          OnClick = btnSavedAnyClick
        end
      end
    end
    object pnlFilterstatus: TPanel
      Left = 404
      Top = 0
      Width = 100
      Height = 17
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = '   Filter :  '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Images = ImageList1
    Left = 402
    Top = 108
    object mnuFile: TMenuItem
      Caption = '&File'
      OnClick = mnuFileClick
      object New2: TMenuItem
        Caption = '&New'
        ImageIndex = 0
        OnClick = New2Click
      end
      object mnuSave: TMenuItem
        Caption = '&Save...'
        ImageIndex = 1
        OnClick = mnuSaveClick
      end
      object mnuSaveAs: TMenuItem
        Caption = 'Save &As...'
        ImageIndex = 2
        OnClick = mnuSaveAsClick
      end
      object mnuSaveAsPublic: TMenuItem
        Caption = 'Save As &Public...'
        OnClick = mnuSaveAsPublicClick
      end
      object N0: TMenuItem
        Caption = '-'
        Visible = False
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object N2: TMenuItem
        Caption = '-'
        Visible = False
      end
      object Exit2: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit2Click
      end
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      OnClick = Edit1Click
      object mnuDeleteCurrentFilter: TMenuItem
        Caption = '&Delete Filter...'
        Enabled = False
        OnClick = mnuDeleteCurrentFilterClick
      end
    end
    object Options1: TMenuItem
      Caption = 'O&ptions'
      object SelectAll1: TMenuItem
        Caption = '&Select All'
        Visible = False
        OnClick = SelectAll1Click
      end
      object ClearAll1: TMenuItem
        Caption = '&Clear All'
        OnClick = ClearAll1Click
      end
      object Refresh1: TMenuItem
        Caption = 'Refresh Drop Down &Lists'
        OnClick = Refresh1Click
      end
      object StrictlyCLINorADMIN1: TMenuItem
        Caption = 'Strictly CLIN or ADMIN'
        Visible = False
      end
      object mnuRefreshFilterlists: TMenuItem
        Caption = 'Refresh &Filter lists'
        OnClick = mnuRefreshFilterlistsClick
      end
      object RefreshDetails1: TMenuItem
        Caption = 'Refresh Details'
        OnClick = RefreshDetails1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object Help2: TMenuItem
        Caption = 'Image &Filter...'
        HelpContext = 999
        OnClick = Help2Click
      end
    end
    object Other1: TMenuItem
      Caption = 'Other'
      Visible = False
      object mnuAddTypes: TMenuItem
        Caption = 'mnuAddTypes'
        OnClick = mnuAddTypesClick
      end
      object mnuRemoveTypes: TMenuItem
        Caption = 'mnuRemoveTypes'
        OnClick = mnuRemoveTypesClick
      end
      object mnuRemoveAllTypes: TMenuItem
        Caption = 'mnuRemoveAllTypes'
        OnClick = mnuRemoveAllTypesClick
      end
    end
  end
  object ImageList1: TImageList
    Left = 382
    Top = 38
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B000000
      00007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00007B7B7B007B7B7B007B7B7B0000FFFF0000FFFF007B7B7B007B7B7B007B7B
      7B007B7B7B0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD000000
      0000BDBDBD00BDBDBD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000BDBDBD00BDBD
      BD00BDBDBD00BDBDBD0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD000000000000000000BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD000000000000000000BDBDBD00BDBDBD00BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000007B7B7B00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000BDBDBD0000000000FF000000FF000000FF00
      00000000FF00FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000FFFF0000FFFF0000FFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF0000000000FFFFFF00000000000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000FF000000FF000000
      FF000000FF000000FF000000FF000000FF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000000000FF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FF
      FF0000FFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00FFFFFF000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000007B7B7B00000000000000000000000000FFFFFF0000000000BDBD
      BD00FFFFFF0000000000FFFFFF000000000000000000000000007B7B7B000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      00000000000000FFFF0000FFFF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FF7EFFFFFF00000090018003FF000000
      C0030001FF000000E0030001FF000000E003000100000000E003000100000000
      E00300010000000000010001000000008000000100230000E007000100010000
      E00F000100000000E00F000100230000E027000100630000C073000100C30000
      9E790001010700007EFE800303FF000000000000000000000000000000000000
      000000000000}
  end
  object mnuPrivatePopup: TPopupMenu
    OnPopup = mnuPrivatePopupPopup
    Left = 377
    Top = 162
    object mnuDeletePrivateFilter: TMenuItem
      Caption = 'Delete...'
      OnClick = mnuDeletePrivateFilterClick
    end
  end
end
