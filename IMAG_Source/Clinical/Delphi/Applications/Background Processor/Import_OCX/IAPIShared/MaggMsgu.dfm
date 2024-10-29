object MaggMsgf: TMaggMsgf
  Left = 301
  Top = 170
  HelpContext = 10124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Imaging Session:  Message History'
  ClientHeight = 729
  ClientWidth = 718
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MsgMemo: TMemo
    Left = 0
    Top = 0
    Width = 718
    Height = 710
    Align = alClient
    Lines.Strings = (
      'Imaging Session : message history.')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    WordWrap = False
  end
  object FileListBox1: TFileListBox
    Left = 320
    Top = 40
    Width = 145
    Height = 97
    ItemHeight = 13
    TabOrder = 1
    Visible = False
  end
  object DirectoryListBox1: TDirectoryListBox
    Left = 240
    Top = 104
    Width = 89
    Height = 81
    ItemHeight = 16
    TabOrder = 2
    Visible = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 710
    Width = 718
    Height = 19
    Panels = <
      item
        Text = 'Log Cnt = 0'
        Width = 125
      end
      item
        Width = 600
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
    ExplicitTop = 682
  end
  object pnlHidden: TPanel
    Left = 348
    Top = 262
    Width = 246
    Height = 66
    Caption = 'pnlHidden'
    TabOrder = 4
    Visible = False
    object tbSysMemo: TCheckBox
      Left = 110
      Top = 2
      Width = 119
      Height = 19
      Caption = 'System messages'
      TabOrder = 0
      Visible = False
      OnClick = tbSysMemoClick
    end
    object tbWrap: TCheckBox
      Left = 5
      Top = 2
      Width = 97
      Height = 19
      Caption = 'Word Wrap'
      TabOrder = 1
      OnClick = tbWrapClick
    end
  end
  object reMemo: TRichEdit
    Left = 0
    Top = 0
    Width = 718
    Height = 710
    Align = alClient
    Color = 11009263
    Lines.Strings = (
      'Imaging Session : message history.')
    PopupMenu = pmuClipboard
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 5
    WantTabs = True
    WordWrap = False
    OnKeyDown = reMemoKeyDown
    OnKeyUp = reMemoKeyUp
  end
  object ListBox1: TListBox
    Left = 552
    Top = 16
    Width = 73
    Height = 184
    ItemHeight = 13
    TabOrder = 6
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 126
    Top = 282
  end
  object cd1: TColorDialog
    Left = 160
    Top = 280
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 68
    Top = 284
    object mMsgcount: TMenuItem
      Caption = 'retain the last xxx messages...'
    end
    object SaveMessagehistorylisttofile1: TMenuItem
      Caption = 'Save Message history to file.'
    end
    object SaveSystemMessagetoFile1: TMenuItem
      Caption = 'Save System Message history to File'
      Visible = False
    end
    object FindText1: TMenuItem
      Caption = 'Find Text'
      OnClick = FindText1Click
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.log'
    FileName = 'VistaImaging.log'
    Title = 'Open VistaImaging Log File'
    Left = 96
    Top = 284
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 288
    object mnuFile: TMenuItem
      Caption = 'File'
      object SaveLogToFile1: TMenuItem
        Caption = 'Log To Disk'
        Visible = False
        OnClick = SaveLogToFile1Click
      end
      object PrintTheLogFile1: TMenuItem
        Caption = 'Print The Formatted Log'
        Visible = False
        OnClick = PrintTheLogFile1Click
      end
      object mnuSnapshot: TMenuItem
        Caption = '&Snapshot'
        Visible = False
        OnClick = mnuSnapshotClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object mnuExit: TMenuItem
        Caption = 'Exit'
        OnClick = mnuExitClick
      end
    end
    object mnuOptions: TMenuItem
      Caption = 'Options'
      OnClick = mnuOptionsClick
      object mnuiSystemmessages: TMenuItem
        Caption = 'System messages'
        OnClick = mnuiSystemmessagesClick
      end
      object mnuWordWrap: TMenuItem
        Caption = 'Word Wrap'
        OnClick = mnuWordWrapClick
      end
      object mnuFont: TMenuItem
        Caption = 'Font'
        OnClick = mnuFontClick
      end
      object mnuColor: TMenuItem
        Caption = 'Background Color'
        OnClick = mnuColorClick
      end
      object mnuStayonTop: TMenuItem
        Caption = 'Stay on Top'
        OnClick = mnuStayonTopClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object mnuClearhistory: TMenuItem
        Caption = 'Clear history'
        OnClick = mnuClearhistoryClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object FindText2: TMenuItem
        Caption = 'Find Text'
        OnClick = FindText2Click
      end
    end
    object mnuFilter: TMenuItem
      Caption = 'F&ilter'
      object mnuFilter_AllMessages: TMenuItem
        AutoCheck = True
        Caption = 'Show All Messages'
        Default = True
        OnClick = mnuFilter_AllMessagesClick
      end
      object mnuFilter_SuppressDebugMsgs: TMenuItem
        AutoCheck = True
        Caption = 'Suppress Debug Messages'
        Checked = True
        OnClick = mnuFilter_SuppressDebugMsgsClick
      end
      object mnuFilter_SuppressInfoMsgs: TMenuItem
        AutoCheck = True
        Caption = 'Suppress Info Messages'
        OnClick = mnuFilter_SuppressInfoMsgsClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mnuFilter_AllComm: TMenuItem
        AutoCheck = True
        Caption = 'Show All Comm Messages'
        Checked = True
        OnClick = mnuFilter_AllCommClick
      end
      object mnuFilter_OnlyComm: TMenuItem
        AutoCheck = True
        Caption = 'Show Only Comm Messages'
        OnClick = mnuFilter_OnlyCommClick
      end
      object mnuFilter_NoComm: TMenuItem
        AutoCheck = True
        Caption = 'Suppress Comm Messages'
        OnClick = mnuFilter_NoCommClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object mnuFilter_AllCCOW: TMenuItem
        AutoCheck = True
        Caption = 'All CCOW Messages'
        Checked = True
        OnClick = mnuFilter_AllCCOWClick
      end
      object mnuFilter_OnlyCCOW: TMenuItem
        AutoCheck = True
        Caption = 'Show Only CCOW Messages'
        OnClick = mnuFilter_OnlyCCOWClick
      end
      object mnuFilter_NoCCOW: TMenuItem
        AutoCheck = True
        Caption = 'Suppress CCOW Messages'
        OnClick = mnuFilter_NoCCOWClick
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object mnuFilter_HighlightErrors: TMenuItem
        AutoCheck = True
        Caption = 'Highlight Error Messages'
        Checked = True
        OnClick = mnuFilter_HighlightErrorsClick
      end
      object mnuShowLogLevels: TMenuItem
        Caption = 'Show Log Levels'
        OnClick = mnuShowLogLevelsClick
      end
    end
    object Refresh1: TMenuItem
      Caption = '&Refresh'
      object RefreshDisplay1: TMenuItem
        Caption = 'Refresh Display'
        OnClick = RefreshDisplay1Click
      end
      object TMenuItem
        Caption = '-'
      end
      object AutoUpdate1: TMenuItem
        AutoCheck = True
        Caption = 'AutoUpdate'
        Checked = True
      end
    end
    object mnuHelp: TMenuItem
      Caption = 'Help'
      object mnuMessageHistoryHelp: TMenuItem
        Caption = 'Message History Window'
        OnClick = mnuMessageHistoryHelpClick
      end
      object DebugHALT1: TMenuItem
        Caption = 'Debug: HALT'
        Visible = False
        OnClick = DebugHALT1Click
      end
      object RunError1: TMenuItem
        Caption = 'Run Error'
        Visible = False
        OnClick = RunError1Click
      end
    end
  end
  object pmuClipboard: TPopupMenu
    OnPopup = pmuClipboardPopup
    Left = 224
    Top = 280
    object itemUndo: TMenuItem
      Caption = 'Undo'
      OnClick = itemUndoClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object itemCut: TMenuItem
      Caption = 'Cut'
      Enabled = False
      OnClick = itemCutClick
    end
    object itemCopy: TMenuItem
      Caption = 'Copy'
      OnClick = itemCopyClick
    end
    object itemPaste: TMenuItem
      Caption = 'Paste'
      Enabled = False
      OnClick = itemPasteClick
    end
    object itemDelete: TMenuItem
      Caption = 'Delete'
      Enabled = False
      OnClick = itemDeleteClick
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object itemSelectAll: TMenuItem
      Caption = 'Select All'
      OnClick = itemSelectAllClick
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object FindText3: TMenuItem
      Caption = 'Find Text'
      OnClick = FindText3Click
    end
    object AddMarkerToText1: TMenuItem
      Caption = 'Add Marker To Text'
      OnClick = AddMarkerToText1Click
    end
    object RefreshDisplay2: TMenuItem
      Caption = 'Refresh Display'
      OnClick = RefreshDisplay2Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 256
    Top = 280
  end
  object FindDialog1: TFindDialog
    OnShow = FindDialog1Show
    Options = [frDown, frHideMatchCase, frHideWholeWord, frHideUpDown, frDisableMatchCase, frDisableUpDown, frDisableWholeWord]
    OnFind = FindDialog1Find
    Left = 296
    Top = 280
  end
  object VCLZip1: TVCLZip
    ThisReleaseLevel = 'Release'
    Recurse = True
    StorePaths = True
    MultiZipInfo.BlockSize = 1457600
    Left = 296
    Top = 368
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = ApplicationEvents1Exception
    Left = 368
    Top = 280
  end
  object VCLZip2: TVCLZip
    ThisReleaseLevel = 'Release'
    MultiZipInfo.BlockSize = 1457600
    Left = 328
    Top = 368
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = '.zip'
    Filter = '*.ZIP|*.zip'
    Left = 404
    Top = 280
  end
end
