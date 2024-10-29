object frmMagImageInfoSys: TfrmMagImageInfoSys
  Left = 493
  Top = 276
  BorderIcons = [biSystemMenu]
  Caption = 'Image Information/properties'
  ClientHeight = 514
  ClientWidth = 678
  Color = clBtnFace
  Constraints.MinHeight = 182
  Constraints.MinWidth = 389
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poDefault
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 678
    Height = 514
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Memo1: TMemo
      Left = 0
      Top = 202
      Width = 678
      Height = 293
      Align = alClient
      Color = 11009263
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        '')
      ParentFont = False
      ParentShowHint = False
      PopupMenu = PopupMenu1
      ReadOnly = True
      ScrollBars = ssVertical
      ShowHint = True
      TabOrder = 0
      WordWrap = False
      OnKeyDown = Memo1KeyDown
      ExplicitTop = 238
      ExplicitHeight = 257
    end
    object Panel2: TPanel
      Left = 0
      Top = 33
      Width = 678
      Height = 169
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      ExplicitTop = 69
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 647
        Height = 169
        Align = alClient
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          'button    ^MAG(2005'
          
            '      <click>        Displays the global node of the IEN in the ' +
            'edit box.  If edit box is null,'
          
            '                         the Last IEN in the Image File will be ' +
            'used.'
          ''
          'Edit box'
          '      <up arrow>       Display the Next Image IEN'
          '      <down arrow>  Display the Previous Image IEN'
          '      <F5>  Display the Group Node of the current IEN.'
          
            '     <dbl Click>  Display the global node of the IEN in the Edit' +
            ' Box.  '
          '                same as clicking the button.'
          ''
          'Field Values '
          
            '    calls GETS^DIQ to display all Field Values.  the flags param' +
            'eter is optional, it defaluts to IENR.'
          '  I= show Internal values '
          '  E= show External values'
          '  N=  Null fields not displayed'
          '  R= ShowField Names'
          ''
          ''
          'Memo box : '
          '      <up arrow>       Display the Next Image IEN'
          '      <down arrow>  Display the Previous Image IEN'
          '      <F5>  Display the Group Node of the current IEN.'
          ''
          'Popup menu option  <right click>'
          ''
          'run NetConnect  '
          
            '      will execute the Connection to the Image server for the Ab' +
            'stract, and the Full Resolution Image. '
          '       it will display the results.'
          ''
          ''
          'TImageData Object'
          
            '     will display the internal data that the Delphi Application ' +
            'has stored for the current Image.'
          '')
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Panel4: TPanel
        Left = 647
        Top = 0
        Width = 31
        Height = 169
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object SpeedButton1: TSpeedButton
          Left = 2
          Top = 1
          Width = 25
          Height = 30
          Glyph.Data = {
            DE010000424DDE01000000000000760000002800000024000000120000000100
            0400000000006801000000000000000000001000000010000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            333333333333333333333333000033338833333333333333333F333333333333
            0000333911833333983333333388F333333F3333000033391118333911833333
            38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
            911118111118333338F3338F833338F3000033333911111111833333338F3338
            3333F8330000333333911111183333333338F333333F83330000333333311111
            8333333333338F3333383333000033333339111183333333333338F333833333
            00003333339111118333333333333833338F3333000033333911181118333333
            33338333338F333300003333911183911183333333383338F338F33300003333
            9118333911183333338F33838F338F33000033333913333391113333338FF833
            38F338F300003333333333333919333333388333338FFF830000333333333333
            3333333333333333333888330000333333333333333333333333333333333333
            0000}
          Layout = blGlyphTop
          NumGlyphs = 2
          OnClick = SpeedButton1Click
        end
      end
    end
    object StatusBar1: TStatusBar
      Left = 0
      Top = 495
      Width = 678
      Height = 19
      Panels = <>
    end
    object ToolBar1: TToolBar
      Left = 0
      Top = 0
      Width = 678
      Height = 33
      AutoSize = True
      BorderWidth = 2
      ButtonHeight = 21
      ButtonWidth = 72
      Caption = 'ToolBar1'
      Color = clBtnShadow
      EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
      EdgeOuter = esRaised
      ParentColor = False
      ShowCaptions = True
      TabOrder = 3
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Hint = 'Display the Global Node from the IMAGE File for the IEN'
        Caption = '^MAG(2005..'
        ImageIndex = 0
        OnClick = ToolButton1Click
      end
      object ToolButton2: TToolButton
        Left = 72
        Top = 0
        Width = 8
        Caption = 'ToolButton2'
        ImageIndex = 1
        Style = tbsSeparator
      end
      object eMagNode: TEdit
        Left = 80
        Top = 0
        Width = 97
        Height = 21
        Hint = 'IEN of the Image.'
        TabOrder = 0
        OnDblClick = eMagNodeDblClick
        OnKeyDown = eMagNodeKeyDown
        OnMouseDown = eMagNodeMouseDown
      end
      object ToolButton5: TToolButton
        Left = 177
        Top = 0
        Width = 10
        Caption = 'ToolButton5'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object ToolButton6: TToolButton
        Left = 187
        Top = 0
        Hint = 'Get the Next IEN in the Image File'
        AutoSize = True
        Caption = ' Next '
        ImageIndex = 3
        OnClick = ToolButton6Click
      end
      object ToolButton7: TToolButton
        Left = 226
        Top = 0
        Hint = 'Get the Previous IEN in the Image File'
        AutoSize = True
        Caption = ' Prev '
        ImageIndex = 4
        OnClick = ToolButton7Click
      end
      object ToolButton8: TToolButton
        Left = 265
        Top = 0
        Hint = 'Get the Group IEN for current IEN'
        AutoSize = True
        Caption = ' Group '
        ImageIndex = 5
        OnClick = ToolButton8Click
      end
      object ToolButton9: TToolButton
        Left = 311
        Top = 0
        Hint = 'Display internal TImageData for current IEN'
        AutoSize = True
        Caption = ' TImageData '
        ImageIndex = 6
        OnClick = ToolButton9Click
      end
      object ToolButton11: TToolButton
        Left = 387
        Top = 0
        Hint = 'Show the TXT file associated with the Image'
        AutoSize = True
        Caption = ' .TXT '
        ImageIndex = 3
        OnClick = ToolButton11Click
      end
      object ToolButton10: TToolButton
        Left = 428
        Top = 0
        Hint = 'Display summary Image information.'
        AutoSize = True
        Caption = ' Info '
        ImageIndex = 7
        OnClick = ToolButton10Click
      end
      object ToolButton3: TToolButton
        Left = 463
        Top = 0
        Width = 20
        Caption = 'ToolButton3'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object ToolButton4: TToolButton
        Left = 483
        Top = 0
        Hint = 'Calls GETS^DIQ to display all Field Values for the Image.'
        Caption = 'Field Values'
        ImageIndex = 2
        OnClick = ToolButton4Click
      end
      object Label1: TLabel
        Left = 555
        Top = 0
        Width = 40
        Height = 21
        Alignment = taCenter
        AutoSize = False
        Caption = 'flags'
        Layout = tlCenter
      end
      object eFlags: TEdit
        Left = 595
        Top = 0
        Width = 61
        Height = 21
        Hint = 
          'I= show Internal values,   E= show External values,   N=  Null f' +
          'ields not displayed,   R= ShowField Names'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnDblClick = eFlagsDblClick
      end
    end
  end
  object fd1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 156
    Top = 103
  end
  object cd1: TColorDialog
    Left = 266
    Top = 89
  end
  object PopupMenu1: TPopupMenu
    Left = 224
    Top = 113
    object mnuImageTXTFile: TMenuItem
      Caption = 'Image Text File'
      OnClick = mnuImageTXTFileClick
    end
    object ImageDataObject1: TMenuItem
      Caption = 'TImageData Object'
      OnClick = ImageDataObject1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object GroupIENofCurrentIEN1: TMenuItem
      Caption = 'Group IEN of Current IEN'
      OnClick = GroupIENofCurrentIEN1Click
    end
    object PreviousIEN1: TMenuItem
      Caption = 'Previous IEN'
      OnClick = PreviousIEN1Click
    end
    object NextIEN1: TMenuItem
      Caption = 'Next IEN'
      OnClick = NextIEN1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Font1: TMenuItem
      Caption = 'Font...'
      OnClick = Font1Click
    end
    object C: TMenuItem
      Caption = 'Color...'
      OnClick = CClick
    end
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
    object runNetConnectforAbsandFull1: TMenuItem
      Caption = 'run NetConnect'
      OnClick = runNetConnectforAbsandFull1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StayonTop1: TMenuItem
      Caption = 'Stay on Top'
      OnClick = StayonTop1Click
    end
    object WordWrap1: TMenuItem
      Caption = 'Word Wrap'
      OnClick = WordWrap1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Help1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
  end
end
