object frmIconLegend: TfrmIconLegend
  Left = -1137
  Top = 201
  Width = 772
  Height = 699
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'ShortCut Key Legend'
  Color = clBtnFace
  Constraints.MinHeight = 417
  Constraints.MinWidth = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ValueListEditor1: TValueListEditor
    Left = 0
    Top = 25
    Width = 764
    Height = 575
    Align = alClient
    Strings.Strings = (
      ' = *** Image Functions ***'
      'Shift+Ctrl + S=Reset Image to initial settings'
      'Shift+Ctrl + I=Zoom In'
      'Shift+Ctrl + O=Zoom Out'
      'Shift+Ctrl + W=Fit Image to Width'
      'Shift+Ctrl + A=Zoom Image to Actual Size'
      'Shift+Ctrl + Left=Scroll Left'
      'Shift+Ctrl + Right=Scroll Right'
      'Shift+Ctrl + Up=Scroll Up'
      'Shift+Ctrl + Down=Scroll Down'
      'Shift+Ctrl + Home=Scroll to Top Left'
      'Shift+Ctrl + Pg Up=Scroll to Top Right'
      'Shift+Ctrl + Pg Down=Scroll to Bottom Right'
      'Shift+Ctrl + End=Scroll to Bottom Left'
      'Shift+Ctrl + J=More Contrast'
      'Shift+Ctrl + K=Less Contrast'
      'Shift+Ctrl + N=More Brightness'
      'Shift+Ctrl + M=Less Brightness'
      'Shift+Ctrl + R=Rotate Right 90'
      ' ='
      ' = *** Image Viewer ***'
      'Ctrl+Alt + P=Previous Page Images'
      'Ctrl+Alt + N=Next Page Images'
      'Ctrl + P=Previous Image'
      'Ctrl + N=Next Image'
      ' ='
      ' = *** Image List Window ***'
      'Ctrl + F5=Active Control: Abstracts'
      'Ctrl + F6=Active Control: Tree View'
      'Ctrl + F7=Active Control: List View'
      'Ctrl + F8=Active Control: Full Resolution'
      ' ='
      ' = *** Radiology Viewer ***'
      'Ctrl + P=Previous Image'
      'Ctrl + N=Next Image'
      'Ctrl + F=First Image'
      'Ctrl + L=Last Image'
      'Ctrl + C=Cine Tool Focus'
      'Shift+Ctrl + D=More Window Value'
      'Shift+Ctrl + F=Less Window Value'
      'Shift+Ctrl + C=More Level Value'
      'Shift+Ctrl + V=Less Level Value'
      'Shift+Ctrl + T=Start Stack Cine'
      'Shift+Ctrl + Y=Stop Stack Cine'
      'Shift+Ctrl + G=Slow Down Stack Cine'
      'Shift+Ctrl + H=Speed Up Stack Cine'
      ' ='
      ' = *** Cine Viewer ***'
      'Ctrl + C=Switch to Radiology Viewer'
      ' ='
      ' = *** Abstracts Windows'
      'Ctrl + O=Smaller Abstracts'
      'Ctrl + I=Larger Abstracts'
      'Ctrl+Alt + P=Previous Page Abstracts'
      'Ctrl+Alt + N=Next Page Abstracts'
      'Ctrl + P=Previous Abstract'
      'Ctrl + N=Next Abstract'
      ' ='
      ' = *** Page Functions ***'
      'Ctlr + Alt + Left=Goto First Page'
      'Ctrl + Alt + Down=Goto Previous Page'
      'Ctrl + Alt + Up=Goto Next Page'
      'Ctrl + Alt + Right=Goto Last Page'
      ' ='
      ' = *** Activate Windows ***'
      'Ctrl + L=Image List Filters'
      'Ctrl + M=Goto Main Window'
      'Ctrl + W=Switch to an Active Window'
      'Alt  + F6=Switch to Last Active Window'
      ' ='
      ' = *** Miscellaneous ***'
      'Ctrl + T=Hide/Show ToolBar'
      'Ctrl + R=Refresh Abstracts/Images'
      'Ctrl+Alt + M=Open Popup Menu'
      ' ='
      ' = *** Help Topics ***'
      'F1=Open Help for the current control'
      ' ='
      ' = *** Menu Option access ***'
      'Alt, F10=Press the Alt or F10 Key'
      ' =(you don'#39't need to hold it down)'
      ' = The Menu keys are now active.'
      ' = Press the underlined characters'
      ' = to navigate the menu'
      'Alt, Space=System menu for the window'
      ' ='
      ' = *** Closing Dialog Windows ***'
      'Alt+F4=Close the Active Window.'
      ' ='
      ' = *** Controls with Popup Menu ***'
      'Mouse <Right-Click>=Abstract Window'
      '(or Ctrl+Shift + M)=Group Abstract Window'
      ' =Full Res Window'
      ' =Image List Window - Image List'
      ' =Radiology List Window - Exam List'
      ' =Image Filter Window - Filter List'
      ' ='
      ' = *** End ***')
    TabOrder = 0
    TitleCaptions.Strings = (
      'Key Combination'
      'Function')
    ColWidths = (
      126
      615)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 764
    Height = 25
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '  ShortCut Keys'
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 600
    Width = 764
    Height = 65
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      764
      65)
    object BitBtn1: TBitBtn
      Left = 54
      Top = 20
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      TabOrder = 0
      OnClick = BitBtn1Click
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 632
      Top = 20
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Print'
      TabOrder = 1
      OnClick = BitBtn2Click
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000000000000000000000000000000000004080FF4080FF
        4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080
        FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF40
        80FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF
        7F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B
        004080FF4080FF4080FF4080FF7F5B00E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3
        C1A4E3C1A4E3C1A4E3C1A47F5B00D9A77D7F5B004080FF4080FF7F5B007F5B00
        7F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B007F5B
        00D9A77D7F5B004080FF7F5B00E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4FF
        FF99FFFF99FFFF99E3C1A4E3C1A47F5B007F5B007F5B004080FF7F5B00E3C1A4
        E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4D9A77DD9A77DD9A77DE3C1A4E3C1A47F5B
        00D9A77D7F5B004080FF7F5B007F5B007F5B007F5B007F5B007F5B007F5B007F
        5B007F5B007F5B007F5B007F5B007F5B00E3C1A4D9A77D7F5B007F5B00E3C1A4
        E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4E3C1A4D9A77DE3C1A47F5B
        007F5B00E3C1A47F5B004080FF7F5B007F5B007F5B007F5B007F5B007F5B007F
        5B007F5B007F5B007F5B00D9A77DE3C1A47F5B007F5B007F5B004080FF4080FF
        7F5B00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F5B00D9A7
        7DE3C1A4D9A77D7F5B004080FF4080FF4080FF7F5B00FFFFFF7F5B007F5B007F
        5B007F5B007F5B00FFFFFF7F5B007F5B007F5B007F5B004080FF4080FF4080FF
        4080FF7F5B00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F5B
        004080FF4080FF4080FF4080FF4080FF4080FF4080FF7F5B00FFFFFF7F5B007F
        5B007F5B007F5B007F5B00FFFFFF7F5B004080FF4080FF4080FF4080FF4080FF
        4080FF4080FF7F5B00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FF7F5B004080FF4080FF4080FF4080FF4080FF4080FF4080FF7F5B007F5B007F
        5B007F5B007F5B007F5B007F5B007F5B007F5B004080FF4080FF}
    end
  end
  object MainMenu1: TMainMenu
    Left = 174
    Top = 3
    object File1: TMenuItem
      Caption = 'File'
      Visible = False
      object SwitchtoActiveWindow1: TMenuItem
        Caption = 'Switch to Active Window'
        ShortCut = 16471
        OnClick = SwitchtoActiveWindow1Click
      end
      object GotoMainWindow1: TMenuItem
        Caption = 'Goto Main Window'
        ShortCut = 16461
        OnClick = GotoMainWindow1Click
      end
    end
  end
end
