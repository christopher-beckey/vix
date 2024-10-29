object frmDirectoryDialog: TfrmDirectoryDialog
  Left = 597
  Top = 225
  Width = 632
  Height = 517
  BorderIcons = [biSystemMenu]
  Caption = 'Select Directory'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 450
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000088888888888800087777777777778083333333333337783388
    888888883378338888888888B37833B888888888B3773B3F88888888B8373838
    88888888B8373838FFFFFFFF8F3738B33333333333383888888FFFFF33803F88
    88F33333380003FFFF380000000000333380000000000000000000000000FFFF
    0000C00300008001000000000000000000000000000000000000000000000000
    00000000000000000000000100000003000080FF0000C1FF0000FFFF0000}
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 259
    Top = 0
    Width = 7
    Height = 377
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 259
    Height = 377
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'Panel1'
    ParentColor = True
    TabOrder = 0
    DesignSize = (
      259
      377)
    object ShellTreeView1: TShellTreeView
      Left = 5
      Top = 38
      Width = 255
      Height = 337
      AutoContextMenus = False
      ObjectTypes = [otFolders]
      Root = 'rfMyComputer'
      ShellComboBox = ShellComboBox1
      ShellListView = ShellListView1
      UseShellImages = True
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoRefresh = False
      Indent = 19
      ParentColor = False
      RightClickSelect = True
      ShowRoot = False
      TabOrder = 0
      OnChange = ShellTreeView1Change
    end
    object ShellComboBox1: TShellComboBox
      Left = 7
      Top = 7
      Width = 253
      Height = 22
      Root = 'rfMyComputer'
      ShellTreeView = ShellTreeView1
      ShellListView = ShellListView1
      UseShellImages = True
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 8
      TabOrder = 1
    end
  end
  object pnlShellList: TPanel
    Left = 270
    Top = 4
    Width = 237
    Height = 157
    BevelOuter = bvNone
    BorderWidth = 6
    Caption = 'pnlShellList'
    ParentColor = True
    TabOrder = 1
    DesignSize = (
      237
      157)
    object ShellListView1: TShellListView
      Left = 0
      Top = 7
      Width = 229
      Height = 151
      AutoContextMenus = False
      ObjectTypes = [otFolders, otNonFolders]
      Root = 'rfMyComputer'
      ShellTreeView = ShellTreeView1
      ShellComboBox = ShellComboBox1
      Sorted = True
      Anchors = [akLeft, akTop, akRight, akBottom]
      OnClick = ShellListView1Click
      ReadOnly = False
      HideSelection = False
      IconOptions.Arrangement = iaLeft
      PopupMenu = PopupMenu1
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 377
    Width = 624
    Height = 87
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object Label1: TLabel
      Left = 16
      Top = 14
      Width = 51
      Height = 13
      Caption = 'Directory : '
    end
    object lbSelectedDir: TLabel
      Left = 84
      Top = 14
      Width = 52
      Height = 13
      Caption = '<directory>'
    end
    object btnAdd: TBitBtn
      Left = 139
      Top = 44
      Width = 75
      Height = 25
      Caption = 'Add'
      Default = True
      Enabled = False
      TabOrder = 0
      OnClick = btnAddClick
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
    object BitBtn2: TBitBtn
      Left = 319
      Top = 44
      Width = 75
      Height = 25
      Caption = '&Close'
      ModalResult = 2
      TabOrder = 1
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
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 464
    Width = 624
    Height = 19
    Panels = <
      item
        Width = 10
      end
      item
        Width = 50
      end>
  end
  object ShellChangeNotifier1: TShellChangeNotifier
    NotifyFilters = [nfFileNameChange, nfDirNameChange]
    Root = 'C:\'
    WatchSubTree = True
    Left = 324
    Top = 248
  end
  object PopupMenu1: TPopupMenu
    Left = 348
    Top = 198
    object Icon1: TMenuItem
      Caption = 'Icon'
      RadioItem = True
      OnClick = Icon1Click
    end
    object List1: TMenuItem
      Caption = 'List'
      RadioItem = True
      OnClick = List1Click
    end
    object Report1: TMenuItem
      Caption = 'Report'
      Checked = True
      RadioItem = True
      OnClick = Report1Click
    end
    object SmallIcon1: TMenuItem
      Caption = 'Small Icon'
      RadioItem = True
      OnClick = SmallIcon1Click
    end
  end
end
