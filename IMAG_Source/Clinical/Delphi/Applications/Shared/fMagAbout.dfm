object frmAbout: TfrmAbout
  Left = 638
  Top = 267
  Width = 410
  Height = 519
  BorderIcons = [biSystemMenu]
  Caption = 'About: <Version Info : ProductName>'
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
    Left = 4
    Top = 2
    Width = 396
    Height = 473
    BevelInner = bvLowered
    BorderWidth = 6
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      396
      473)
    object imgProgramIcon: TImage
      Left = 10
      Top = 120
      Width = 32
      Height = 32
      Transparent = True
      IsControl = True
    end
    object lbFileDescription: TLabel
      Left = 53
      Top = 131
      Width = 195
      Height = 16
      Caption = '<Version Info: FileDescription>'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbInstalledVersions: TLabel
      Left = 16
      Top = 344
      Width = 89
      Height = 14
      Caption = 'Installed Versions:'
    end
    object lbVerPatch: TLabel
      Left = 306
      Top = 131
      Width = 67
      Height = 14
      Anchors = [akTop, akRight]
      AutoSize = False
      Caption = '<Version>'
    end
    object pnlTopwithLogo: TPanel
      Left = 8
      Top = 8
      Width = 380
      Height = 105
      Align = alTop
      BevelInner = bvLowered
      TabOrder = 0
      object imgVistALogo: TImage
        Left = 2
        Top = 18
        Width = 376
        Height = 85
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
      end
      object lbSilverSpringinfo: TLabel
        Left = 122
        Top = 80
        Width = 132
        Height = 14
        Caption = 'Silver Spring OI Field Office'
        Color = clWhite
        ParentColor = False
      end
      object lbImagingProjectinfo: TLabel
        Left = 122
        Top = 36
        Width = 170
        Height = 16
        Caption = 'Integrated Imaging Project'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
      end
      object lbDevelopedbyinfo: TLabel
        Left = 122
        Top = 64
        Width = 240
        Height = 14
        Caption = 'Developed by the Department of Veterans Affairs'
        Color = clWhite
        ParentColor = False
      end
      object lbVHAinfo: TLabel
        Left = 2
        Top = 2
        Width = 376
        Height = 16
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
        Layout = tlCenter
      end
    end
    object pnlUnathorizedtext: TPanel
      Left = 8
      Top = 292
      Width = 379
      Height = 50
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      TabOrder = 1
      DesignSize = (
        379
        50)
      object lbUnauthorizedtextinfo: TLabel
        Left = 8
        Top = 2
        Width = 356
        Height = 42
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 
          'Unauthorized access or misuse of this system and/or its data is ' +
          'a federal crime.  Use of all data shall be in accordance with VA' +
          ' policy on security and privacy.'
        WordWrap = True
      end
    end
    object pnlComputedFields: TPanel
      Left = 8
      Top = 160
      Width = 379
      Height = 121
      Anchors = [akLeft, akTop, akRight]
      BevelInner = bvLowered
      TabOrder = 2
      object lbfilenameprompt: TLabel
        Left = 6
        Top = 3
        Width = 51
        Height = 14
        Caption = 'File name :'
      end
      object lbfilename: TLabel
        Left = 62
        Top = 3
        Width = 186
        Height = 14
        Caption = '<full path and file name of executable>'
      end
      object lbVersionprompt: TLabel
        Left = 6
        Top = 24
        Width = 44
        Height = 14
        Caption = 'Version :'
        IsControl = True
      end
      object lbversion: TLabel
        Left = 62
        Top = 24
        Width = 47
        Height = 14
        Caption = '<Maj.Min>'
      end
      object lbPatchprompt: TLabel
        Left = 118
        Top = 24
        Width = 30
        Height = 14
        Caption = 'Patch:'
        IsControl = True
      end
      object lbPatch: TLabel
        Left = 150
        Top = 24
        Width = 49
        Height = 14
        Caption = '<P# Tver>'
      end
      object lbfiledateprompt: TLabel
        Left = 6
        Top = 44
        Width = 46
        Height = 14
        Caption = 'Compiled:'
      end
      object lbfiledate: TLabel
        Left = 62
        Top = 44
        Width = 85
        Height = 14
        Caption = '<date/time of file>'
      end
      object lbfilesizeprompt: TLabel
        Left = 251
        Top = 44
        Width = 27
        Height = 14
        Caption = 'Size :'
      end
      object lbfilesize: TLabel
        Left = 278
        Top = 44
        Width = 62
        Height = 14
        Caption = '<size of file>'
      end
      object lbCRCPrompt: TLabel
        Left = 6
        Top = 65
        Width = 27
        Height = 14
        Caption = 'CRC: '
      end
      object lbCRC: TLabel
        Left = 62
        Top = 65
        Width = 85
        Height = 14
        Caption = '<CRC32 Number>'
      end
      object lbServerVersionprmpt: TLabel
        Left = 214
        Top = 24
        Width = 64
        Height = 14
        Caption = 'Req. Server :'
        IsControl = True
      end
      object lbServerVersion: TLabel
        Left = 278
        Top = 24
        Width = 69
        Height = 14
        Caption = '<req Srv Ver>'
      end
      object lbDelphiVersionprompt: TLabel
        Left = 196
        Top = 65
        Width = 82
        Height = 14
        Caption = 'Internal Version: '
      end
      object lbOSVersionPrompt: TLabel
        Left = 6
        Top = 85
        Width = 62
        Height = 14
        Caption = 'OS Version: '
      end
      object lbDelphiVersion: TLabel
        Left = 278
        Top = 65
        Width = 91
        Height = 14
        Caption = '<actual delphi ver>'
      end
      object lbOSVersion: TLabel
        Left = 70
        Top = 85
        Width = 134
        Height = 14
        Caption = '<operation system version>'
      end
      object lbStatusPrompt: TLabel
        Left = 8
        Top = 104
        Width = 76
        Height = 14
        Caption = 'Server Status : '
      end
      object lbStatus: TLabel
        Left = 96
        Top = 104
        Width = 42
        Height = 14
        Caption = '<status>'
      end
    end
    object pnlOKbtn: TPanel
      Left = 8
      Top = 420
      Width = 380
      Height = 45
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      DesignSize = (
        380
        45)
      object btnOK: TBitBtn
        Left = 135
        Top = 11
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
    object pnlListViewLite: TPanel
      Left = 8
      Top = 366
      Width = 380
      Height = 58
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      Color = clInfoBk
      TabOrder = 4
    end
  end
end
