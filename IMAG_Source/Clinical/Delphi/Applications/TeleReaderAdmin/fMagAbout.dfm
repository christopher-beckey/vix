object frmAbout: TfrmAbout
  Left = 843
  Top = 264
  BorderIcons = [biSystemMenu]
  Caption = 'About: <Version Info : ProductName>'
  ClientHeight = 485
  ClientWidth = 402
  Color = clBtnFace
  Constraints.MaxWidth = 410
  Constraints.MinHeight = 463
  Constraints.MinWidth = 410
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object lbAlign: TLabel
    Left = 428
    Top = 223
    Width = 13
    Height = 10
    AutoSize = False
    Color = clRed
    ParentColor = False
    Visible = False
  end
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 402
    Height = 485
    Align = alClient
    BevelInner = bvLowered
    BorderWidth = 6
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TabStop = True
    DesignSize = (
      402
      485)
    object imgProgramIcon: TImage
      Left = 10
      Top = 120
      Width = 32
      Height = 32
      Transparent = True
      IsControl = True
    end
    object lbFileDescription: TStaticText
      Tag = 1
      Left = 53
      Top = 131
      Width = 199
      Height = 20
      Caption = '<Version Info: FileDescription>'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      TabStop = True
    end
    object lbInstalledVersions: TStaticText
      Left = 16
      Top = 344
      Width = 93
      Height = 18
      Caption = 'Installed Versions:'
      TabOrder = 6
    end
    object lbVerPatch: TStaticText
      Tag = 1
      Left = 312
      Top = 131
      Width = 67
      Height = 14
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = '<Version>'
      TabOrder = 3
      TabStop = True
    end
    object pnlTopwithLogo: TPanel
      Left = 8
      Top = 8
      Width = 386
      Height = 105
      Align = alTop
      BevelInner = bvLowered
      TabOrder = 1
      object imgVistALogo: TImage
        Left = 2
        Top = 22
        Width = 382
        Height = 81
        Align = alClient
        Picture.Data = {
          0A544A504547496D6167651A0C0000FFD8FFE000104A46494600010101006000
          600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C191213
          0F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F2739
          3D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232
          3232323232323232323232323232323232323232323232323232323232323232
          32323232323232323232323232FFC0001108006D01B403012200021101031101
          FFC4001F0000010501010101010100000000000000000102030405060708090A
          0BFFC400B5100002010303020403050504040000017D01020300041105122131
          410613516107227114328191A1082342B1C11552D1F02433627282090A161718
          191A25262728292A3435363738393A434445464748494A535455565758595A63
          6465666768696A737475767778797A838485868788898A92939495969798999A
          A2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6
          D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F01000301
          01010101010101010000000000000102030405060708090A0BFFC400B5110002
          0102040403040705040400010277000102031104052131061241510761711322
          328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728
          292A35363738393A434445464748494A535455565758595A636465666768696A
          737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7
          A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3
          E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F7FA
          2909A4CD002D2D37350DCDC476B6D24F33848D14B331EC2804AEEC882FF56B0D
          2D15AFAEA38158FCA5CF5ACE3E32F0F8E7FB56D71EBBEBC7F5ED424F1BF88E6D
          F7325BD9C45522C1001C9FBA727A9AE6B50D305C7880E95A6CD233176F358FDD
          8C67B7B0F535C6F1126FDD47BD4F2AA318BF6D269A577A68BCAFDCFA4B4ED6B4
          FD5E079EC2EA3B88918A33A1E01C6719A92CB54B1D4BCCFB15EDB5C889B6C9E4
          CA1F61F438E95E2DE20D66E741D0AD3C1FA113FDA37A9B085FF96319EA49F53D
          49F4ACFBBD71FC15A659F84F48BC5B19EE8A9B9BF7EABBBABFD7AFD2BD3A5869
          4E2AFF0013FCBB9E14DC399F26DE67BADFEBBA4E99FF001FFA9DA5B11CED9665
          53F91E699A7F88F46D565F2EC355B3B993FE79C73296FCBAD79968DF0D344BFB
          7F3FECC9A8C8FF007EEAEA632B39F5E0E07E02B06EBE1E6A1A37C44B1BED3614
          B4D3ADDD1F6C729CB37F16D1CE33C0A7ECE8D9AE677F42753DBE4D6F4A86468E
          4D4EC91D4E195A75041FA6690F88346070756B11F5B84FF1AF0CF1DF857C3FE1
          6D30DF1B576D42EF2B6C8F70EEEEE7F8BAFF00FACD33C2DF0AA1D434D56D5ADE
          49EF1BE673E73284CFF0F1E955ECA92829393D7CBFE086A7BB5BEB5A65E5C0B7
          B5D46D2798827CB8A6566C0EA700E69B77AF69562ECB75A95A40EA7044932A91
          F9D78A87D37C0D7D2D8F866DD5F55B91E5B323990A0F404E7FC2B9791AEF50F1
          2C3653CC6577B801CA9C838393F5E95E755AF18CF961AFA9EC6172A7529CAAD5
          972A4AF6EB63EA4460E81948652320839069F547497924B04794FCC466AF56E7
          9014514500145145001451450014514500145145001451450014514500145145
          0014514500145145001451450014514500145145001451450014514500145145
          001451450014514500145145001451450064F8825961D035092176591207652A
          70410335F3EBF8F3C4024206A772076FDE1AFA2F528BCED36EA2C7DF85D7F306
          BE52BBC09DB8C570E324D3563EA3872952AAAA29C53B5B73B9F07F8D35BB8F19
          69F15D5FCD340FB8346EE483F29C71F515D37C50F17ECB71A45B38CF06720F7C
          7DDAF27D23506D2B528AF910349103B01EC48233FAD457B7D2DEDC3CF3396639
          249FE7582AED43956ECF5E59541E31576928A4ACBCF52BB4CC1B2A49763C28EA
          49FEB5DF6991DBF823C3336B7A880F7927DD42726490F451EC3BD63F8434AB66
          99759D4E5482D5182C4D27033FDEFF000AD8D561D2354F15C17D7BE22B1B8D3E
          D71F65B44DC021F5624727B9AECC1429C1F3D476F23C6CE71557132F63462DC5
          6ED2DDFF00C020F0DFD9F4CD5ADF50F1034D2EB9ACCAA04489BDA3563F2AFB67
          BFD2BD1FC65F0E74AF14C70CCF6D99E34D8B346DB5B1E9EE3EB5E73E39D3344D
          5EEECB52D23C536F05EC0AAA41CE320E4303D41E69D6BE27F143DB8B59FE2058
          4310006F8ADF3211F52A2BD3954A72B4E35127D7FE05BA1F3FF54AFB723FB8E7
          BC4FE1CD47C0379649A46AD76B77712622B70FFBC1D3078EDF515EF565ADC16B
          E108F56D71D03DB5BAB5C484632E0738F72735E6DA15AF852CEF5AFAF75D4BBB
          F93FD65EDDC85E4C77007F08A7F8E6EB4BF113D8E9F6DE25B18F4380879ADD0B
          89256F738C62A6A6269D5718CA5A2EBD582C2575F61FDCCA3A325E78EFC532F8
          AB545D96884AD842FF0076341FC67E9D8FAD5FF147C4186D207D27422C540C4D
          3A0E5FE84741FCEAAEB1776371A7A5969FE24B1B4B60A14C51A1C91E99E98AD0
          F0CA78474DB6F2E5D62DA30796666CBB9F5240AE1AF5BDB4EC9DA27A587C32C3
          C555941CE5DACECBD7BB38FD07C416FA717964D32479981DF3B1396F6E9C0AB3
          E0980EAFE336B82388973F8B1FFF005D763E25B9F0ADEE892DB69DE21B58A672
          32CC19B80738E949F0AF414B6926B98EE52EA3924E2545207CBC639FC6B9E10F
          DE249DD23B7118B8BC24E4E2E3393B3DF6F99EBD6F1F970227A0C54B40E94577
          1F34145145001451450014514500145145001451450014514500145145001451
          4500145145001451450014514500145145001451450014514500145145001451
          45001451450014514500145145001451450044E331303E95F296B51F95AB5CC5
          8C6C91971F426BEAF35F2FF8C23F27C55A8C78C62E24FF00D0B35C58D5EEA67D
          370CCAD5671F2460E4818ABDA2E912EBDAA25AA03E4A90D2B0F4F4FA9AA2B1C9
          3CD1DBC0BBA595B6A8AF76F879E105D2ECA29594120EE6723EFB7AFD2B0C351E
          77CCF63D4CEF31F614FD941FBCFF00046E693E12B65D156DE7B789860612440C
          063A706A33E01B02726D6D33FF005C13FC2BB11D002734EAF4EC8F885526B667
          19FF00080D8FFCFB5A7FE03A7F8527FC2BED3874B5B4FA790BFE15D9D1472A0F
          6B53BB38CFF8406C874B5B3FFC074FF0A43E01B23FF2E967FF007E13FC2BB4A2
          8E541ED6A7767167C03627FE5D2CFF00EFC27F852FFC205623FE5D2CFF00F01D
          3FC2BB3A28B20F6B3EECE33FE102B23FF2EB67FF007E13FC2B6F45D123D222F2
          E354541D1514281F80AD8A28492D84E727BB168A28A648514514005145140051
          4514005145140051451400514514005145140051451400514514005145140051
          4514005145140051451400514514005145140051451400514514005145140051
          45140051451400DE98AF9B7E25AADBF8D351C8C7EF377E601FEB5F49639AF1AF
          18F85E6D67E244B33C4DF63448989FF9E8F8E07E95CF88839A49773D6CA3171C
          2D59CE5FCAFEFD2C657C36F08BDC4EB7F751E2493EE023EE27F89FE55EED6F02
          5BC0B120C2A8C0159DA1E949A759A8DA3791CE056B56D08282B23CFC4579D7A8
          EA4DEAC5A28A2A8C428A28A0028A28A0028A28A0028A28A0028A28A0028A28A0
          028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0
          028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0
          028A28A0028A28A0028A28A002AB49671493899D4165E95668A0028A28A0028A
          28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
          28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
          28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
          28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
          28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
          28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
          28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
          28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
          28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
          28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A28A0028A
          28A0028A28A00FFFD9}
        ExplicitLeft = 24
        ExplicitWidth = 360
      end
      object lbSilverSpringinfo: TStaticText
        Left = 122
        Top = 80
        Width = 136
        Height = 18
        Caption = 'Silver Spring OI Field Office'
        Color = clWhite
        ParentColor = False
        TabOrder = 3
        TabStop = True
      end
      object lbImagingProjectinfo: TStaticText
        Left = 122
        Top = 36
        Width = 174
        Height = 20
        Caption = 'Integrated Imaging Project'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        TabStop = True
      end
      object lbDevelopedbyinfo: TStaticText
        Left = 122
        Top = 64
        Width = 244
        Height = 18
        Caption = 'Developed by the Department of Veterans Affairs'
        Color = clWhite
        ParentColor = False
        TabOrder = 2
        TabStop = True
      end
      object lbVHAinfo: TStaticText
        Left = 2
        Top = 2
        Width = 382
        Height = 20
        Align = alTop
        Alignment = taCenter
        Caption = '  VHA OI - Health Systems Design && Development  '
        Color = clWhite
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        TabStop = True
      end
    end
    object pnlUnathorizedtext: TPanel
      Left = 8
      Top = 292
      Width = 385
      Height = 50
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      TabOrder = 5
      object lbUnauthorizedtextinfo: TMemo
        Left = 2
        Top = 2
        Width = 375
        Height = 45
        BorderStyle = bsNone
        Color = clBtnFace
        Lines.Strings = (
          
            'Unauthorized access or misuse of this system and/or its data is ' +
            'a federal '
          
            'crime.  Use of all data shall be in accordance with VA policy on' +
            ' security and '
          'privacy.')
        ReadOnly = True
        TabOrder = 0
        WantReturns = False
      end
    end
    object pnlComputedFields: TPanel
      Left = 8
      Top = 157
      Width = 385
      Height = 128
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      TabOrder = 4
      TabStop = True
      object lbfilenameprompt: TStaticText
        Left = 6
        Top = 3
        Width = 55
        Height = 18
        Caption = 'File name :'
        TabOrder = 0
        TabStop = True
      end
      object lbfilename: TStaticText
        Tag = 1
        Left = 62
        Top = 3
        Width = 190
        Height = 18
        Caption = '<full path and file name of executable>'
        TabOrder = 1
        TabStop = True
      end
      object lbVersionprompt: TStaticText
        Left = 6
        Top = 24
        Width = 48
        Height = 18
        Caption = 'Version :'
        TabOrder = 2
        TabStop = True
        IsControl = True
      end
      object lbversion: TStaticText
        Tag = 1
        Left = 62
        Top = 24
        Width = 51
        Height = 18
        Caption = '<Maj.Min>'
        TabOrder = 3
        TabStop = True
      end
      object lbPatchprompt: TStaticText
        Left = 118
        Top = 24
        Width = 34
        Height = 18
        Caption = 'Patch:'
        TabOrder = 4
        TabStop = True
        IsControl = True
      end
      object lbPatch: TStaticText
        Tag = 1
        Left = 150
        Top = 24
        Width = 53
        Height = 18
        Caption = '<P# Tver>'
        TabOrder = 5
        TabStop = True
      end
      object lbfiledateprompt: TStaticText
        Left = 6
        Top = 44
        Width = 50
        Height = 18
        Caption = 'Compiled:'
        TabOrder = 8
        TabStop = True
      end
      object lbfiledate: TStaticText
        Tag = 1
        Left = 62
        Top = 44
        Width = 89
        Height = 18
        Caption = '<date/time of file>'
        TabOrder = 9
        TabStop = True
      end
      object lbfilesizeprompt: TStaticText
        Left = 251
        Top = 44
        Width = 31
        Height = 18
        Caption = 'Size :'
        TabOrder = 10
        TabStop = True
      end
      object lbfilesize: TStaticText
        Tag = 1
        Left = 278
        Top = 44
        Width = 66
        Height = 18
        Caption = '<size of file>'
        TabOrder = 11
        TabStop = True
      end
      object lbCRCPrompt: TStaticText
        Left = 6
        Top = 65
        Width = 31
        Height = 18
        Caption = 'CRC: '
        TabOrder = 12
        TabStop = True
      end
      object lbCRC: TStaticText
        Tag = 1
        Left = 62
        Top = 65
        Width = 89
        Height = 18
        Caption = '<CRC32 Number>'
        TabOrder = 13
        TabStop = True
      end
      object lbServerVersionprmpt: TStaticText
        Left = 214
        Top = 24
        Width = 68
        Height = 18
        Caption = 'Req. Server :'
        TabOrder = 6
        TabStop = True
        IsControl = True
      end
      object lbServerVersion: TStaticText
        Tag = 1
        Left = 278
        Top = 24
        Width = 73
        Height = 18
        Caption = '<req Srv Ver>'
        TabOrder = 7
        TabStop = True
      end
      object lbDelphiVersionprompt: TStaticText
        Left = 196
        Top = 68
        Width = 86
        Height = 18
        Caption = 'Internal Version: '
        TabOrder = 14
        TabStop = True
      end
      object lbOSVersionPrompt: TStaticText
        Left = 6
        Top = 85
        Width = 66
        Height = 18
        Caption = 'OS Version: '
        TabOrder = 16
        TabStop = True
      end
      object lbDelphiVersion: TStaticText
        Tag = 1
        Left = 278
        Top = 65
        Width = 95
        Height = 18
        Caption = '<actual delphi ver>'
        TabOrder = 15
        TabStop = True
      end
      object lbOSVersion: TStaticText
        Tag = 1
        Left = 70
        Top = 85
        Width = 138
        Height = 18
        Caption = '<operation system version>'
        TabOrder = 17
        TabStop = True
      end
      object lbStatusPrompt: TStaticText
        Left = 8
        Top = 104
        Width = 80
        Height = 18
        Caption = 'Server Status : '
        TabOrder = 18
        TabStop = True
      end
      object lbStatus: TStaticText
        Tag = 1
        Left = 96
        Top = 104
        Width = 46
        Height = 18
        Caption = '<status>'
        TabOrder = 19
        TabStop = True
      end
    end
    object pnlOKbtn: TPanel
      Left = 8
      Top = 436
      Width = 386
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        386
        41)
      object btnOK: TBitBtn
        Left = 154
        Top = 6
        Width = 77
        Height = 27
        Anchors = []
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = btnOKClick
        Kind = bkOK
        Margin = 2
        Spacing = -1
        IsControl = True
      end
    end
    object lvVersions: TListView
      Left = 8
      Top = 360
      Width = 383
      Height = 77
      Anchors = [akLeft, akTop, akRight, akBottom]
      Columns = <>
      TabOrder = 7
      ViewStyle = vsReport
    end
  end
  object amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmAbout'
        'Status = stsDefault')
      (
        'Component = lbUnauthorizedtextinfo'
        'Status = stsDefault'))
  end
end
