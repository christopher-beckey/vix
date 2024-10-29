object frmAddEditUnreadList: TfrmAddEditUnreadList
  Left = 711
  Top = 241
  BorderStyle = bsDialog
  Caption = 'TeleReader Consult Type'
  ClientHeight = 656
  ClientWidth = 567
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblSite: TLabel
    Left = 30
    Top = 370
    Width = 203
    Height = 16
    Caption = '5. Select: ACQUISITION SITE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblTrigger: TLabel
    Left = 30
    Top = 430
    Width = 241
    Height = 16
    Caption = '6. Select: UNREAD LIST TRIGGER'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblTIU: TLabel
    Left = 30
    Top = 490
    Width = 186
    Height = 16
    Caption = '7. Select: TIU NOTE TITLE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblInstruct: TLabel
    Left = 20
    Top = 10
    Width = 290
    Height = 16
    Caption = 'Follow the steps below in numerical order.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object imgSite: TImage
    Tag = 5
    Left = 510
    Top = 370
    Width = 17
    Height = 17
    Picture.Data = {
      07544269746D617036030000424D360300000000000036000000280000001000
      000010000000010018000000000000030000C20E0000C20E0000000000000000
      0000C0C0C0C0C0C0C0C0C0C0C0C0B3ABAA8669626E3D2E5E241358201061352A
      7B625FB0A9A9C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C5C4C39370638747
      29A55C33AC5D2FA95629A55123A34C1D923F175C200E775B56C4C3C3C0C0C0C0
      C0C0C0C0C0C5C4C39B6B55A96842B46E41B66F45CEA086CD9C81CB997EB7724C
      A44C1DA04617823613673F35C4C3C3C0C0C0C0C0C0B08C77B4754EBB794EB873
      47BE7F57FCFCFCFCFCFCFCFCFCD1A58CA75123A44C1CA14617833511795954C0
      C0C0C3BAB4B77C55BF845ABE7E53BA784EBF835CFCFCFCFCFCFCFCFCFCD2A88F
      AA5729A75022A44C1CA04416652510C0C0C0C3A187C58E65C28860BF8359BD7D
      53BC7B51C58D6BC28966C08561B67047AC5C2EA95628A75022A34B1B953F1577
      554DCB9C79C9956CC58E65C2885FBF8359BD7D52FBFAFAFCFCFCFCFCFCD1A68C
      AE6134AC5B2DA95628A64F21A14A1B67301ED0A581CC9972C7936AC58D64C288
      5FBF8258EAD8CCFCFCFCFCFCFCF7F0EDC48D6CAE6134AC5B2DA95527A54F216C
      2F17D4AE8DCE9F78CA9870C7936AC58D64C1875EC68F69F2E7E0FCFCFCFCFCFC
      FBFAFAD6B099AE6033AC5B2DA8542775361BD9BA9CD1A67FCD9D75CA9870C792
      69CD9D7BC8946FC0865DE4CBBAFCFCFCFCFCFCFCFCFCD3AB93AE6033AB5B2D83
      4328D9C6B1D5AE89D0A37BF2E8E0FCFCFCFCFCFCEDDED2C1875DBF8157F5EDE8
      FCFCFCFCFCFCEAD8CEB06539AB5E3398674FCEC9C4E0C2A4D3AA83E5CFBBFCFC
      FCFCFCFCFCFCFCF2E7E0EDDED2FCFCFCFCFCFCFCFCFCDEBFACB36B3EA55D35BB
      ACA6C0C0C0DFCFBCDBBA98D2AA84EDDFD1FCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
      FCFCFCECDCD1BD7D54B67145AF7A5CC0C0C0C0C0C0C9C8C8E6D2BBDCBA99D2A9
      83DAB89AE4CDB9E7D3C3E6D1C0E1C6B1CE9F7FBF8156BE8055BA7E58C7C5C4C0
      C0C0C0C0C0C0C0C0C9C8C8E3D4C2E4CBB0D7B08CD1A57ECE9E76CB9970C7936B
      C79269CA956EC59877C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D1CD
      C7E2D2BDE3CBB1E2C4A8DDBC9DD8B393D1AF93C9BBAFC0C0C0C0C0C0C0C0C0C0
      C0C0}
    OnClick = HelpClick
  end
  object imgTrigger: TImage
    Tag = 6
    Left = 510
    Top = 430
    Width = 17
    Height = 17
    Picture.Data = {
      07544269746D617036030000424D360300000000000036000000280000001000
      000010000000010018000000000000030000C20E0000C20E0000000000000000
      0000C0C0C0C0C0C0C0C0C0C0C0C0B3ABAA8669626E3D2E5E241358201061352A
      7B625FB0A9A9C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C5C4C39370638747
      29A55C33AC5D2FA95629A55123A34C1D923F175C200E775B56C4C3C3C0C0C0C0
      C0C0C0C0C0C5C4C39B6B55A96842B46E41B66F45CEA086CD9C81CB997EB7724C
      A44C1DA04617823613673F35C4C3C3C0C0C0C0C0C0B08C77B4754EBB794EB873
      47BE7F57FCFCFCFCFCFCFCFCFCD1A58CA75123A44C1CA14617833511795954C0
      C0C0C3BAB4B77C55BF845ABE7E53BA784EBF835CFCFCFCFCFCFCFCFCFCD2A88F
      AA5729A75022A44C1CA04416652510C0C0C0C3A187C58E65C28860BF8359BD7D
      53BC7B51C58D6BC28966C08561B67047AC5C2EA95628A75022A34B1B953F1577
      554DCB9C79C9956CC58E65C2885FBF8359BD7D52FBFAFAFCFCFCFCFCFCD1A68C
      AE6134AC5B2DA95628A64F21A14A1B67301ED0A581CC9972C7936AC58D64C288
      5FBF8258EAD8CCFCFCFCFCFCFCF7F0EDC48D6CAE6134AC5B2DA95527A54F216C
      2F17D4AE8DCE9F78CA9870C7936AC58D64C1875EC68F69F2E7E0FCFCFCFCFCFC
      FBFAFAD6B099AE6033AC5B2DA8542775361BD9BA9CD1A67FCD9D75CA9870C792
      69CD9D7BC8946FC0865DE4CBBAFCFCFCFCFCFCFCFCFCD3AB93AE6033AB5B2D83
      4328D9C6B1D5AE89D0A37BF2E8E0FCFCFCFCFCFCEDDED2C1875DBF8157F5EDE8
      FCFCFCFCFCFCEAD8CEB06539AB5E3398674FCEC9C4E0C2A4D3AA83E5CFBBFCFC
      FCFCFCFCFCFCFCF2E7E0EDDED2FCFCFCFCFCFCFCFCFCDEBFACB36B3EA55D35BB
      ACA6C0C0C0DFCFBCDBBA98D2AA84EDDFD1FCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
      FCFCFCECDCD1BD7D54B67145AF7A5CC0C0C0C0C0C0C9C8C8E6D2BBDCBA99D2A9
      83DAB89AE4CDB9E7D3C3E6D1C0E1C6B1CE9F7FBF8156BE8055BA7E58C7C5C4C0
      C0C0C0C0C0C0C0C0C9C8C8E3D4C2E4CBB0D7B08CD1A57ECE9E76CB9970C7936B
      C79269CA956EC59877C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D1CD
      C7E2D2BDE3CBB1E2C4A8DDBC9DD8B393D1AF93C9BBAFC0C0C0C0C0C0C0C0C0C0
      C0C0}
    OnClick = HelpClick
  end
  object imgTIU: TImage
    Tag = 7
    Left = 510
    Top = 490
    Width = 17
    Height = 17
    Picture.Data = {
      07544269746D617036030000424D360300000000000036000000280000001000
      000010000000010018000000000000030000C20E0000C20E0000000000000000
      0000C0C0C0C0C0C0C0C0C0C0C0C0B3ABAA8669626E3D2E5E241358201061352A
      7B625FB0A9A9C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C5C4C39370638747
      29A55C33AC5D2FA95629A55123A34C1D923F175C200E775B56C4C3C3C0C0C0C0
      C0C0C0C0C0C5C4C39B6B55A96842B46E41B66F45CEA086CD9C81CB997EB7724C
      A44C1DA04617823613673F35C4C3C3C0C0C0C0C0C0B08C77B4754EBB794EB873
      47BE7F57FCFCFCFCFCFCFCFCFCD1A58CA75123A44C1CA14617833511795954C0
      C0C0C3BAB4B77C55BF845ABE7E53BA784EBF835CFCFCFCFCFCFCFCFCFCD2A88F
      AA5729A75022A44C1CA04416652510C0C0C0C3A187C58E65C28860BF8359BD7D
      53BC7B51C58D6BC28966C08561B67047AC5C2EA95628A75022A34B1B953F1577
      554DCB9C79C9956CC58E65C2885FBF8359BD7D52FBFAFAFCFCFCFCFCFCD1A68C
      AE6134AC5B2DA95628A64F21A14A1B67301ED0A581CC9972C7936AC58D64C288
      5FBF8258EAD8CCFCFCFCFCFCFCF7F0EDC48D6CAE6134AC5B2DA95527A54F216C
      2F17D4AE8DCE9F78CA9870C7936AC58D64C1875EC68F69F2E7E0FCFCFCFCFCFC
      FBFAFAD6B099AE6033AC5B2DA8542775361BD9BA9CD1A67FCD9D75CA9870C792
      69CD9D7BC8946FC0865DE4CBBAFCFCFCFCFCFCFCFCFCD3AB93AE6033AB5B2D83
      4328D9C6B1D5AE89D0A37BF2E8E0FCFCFCFCFCFCEDDED2C1875DBF8157F5EDE8
      FCFCFCFCFCFCEAD8CEB06539AB5E3398674FCEC9C4E0C2A4D3AA83E5CFBBFCFC
      FCFCFCFCFCFCFCF2E7E0EDDED2FCFCFCFCFCFCFCFCFCDEBFACB36B3EA55D35BB
      ACA6C0C0C0DFCFBCDBBA98D2AA84EDDFD1FCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
      FCFCFCECDCD1BD7D54B67145AF7A5CC0C0C0C0C0C0C9C8C8E6D2BBDCBA99D2A9
      83DAB89AE4CDB9E7D3C3E6D1C0E1C6B1CE9F7FBF8156BE8055BA7E58C7C5C4C0
      C0C0C0C0C0C0C0C0C9C8C8E3D4C2E4CBB0D7B08CD1A57ECE9E76CB9970C7936B
      C79269CA956EC59877C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D1CD
      C7E2D2BDE3CBB1E2C4A8DDBC9DD8B393D1AF93C9BBAFC0C0C0C0C0C0C0C0C0C0
      C0C0}
    OnClick = HelpClick
  end
  object cmbSite: TComboBox
    Left = 30
    Top = 390
    Width = 500
    Height = 21
    DropDownCount = 1000
    ItemHeight = 13
    TabOrder = 2
    OnChange = SetSaveButton
  end
  object cmbTrigger: TComboBox
    Left = 30
    Top = 450
    Width = 500
    Height = 21
    DropDownCount = 1000
    ItemHeight = 13
    TabOrder = 3
    OnChange = SetSaveButton
  end
  object cmbTIU: TComboBox
    Left = 30
    Top = 510
    Width = 500
    Height = 21
    DropDownCount = 1000
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
    OnChange = SetSaveButton
  end
  object btnSave: TBitBtn
    Left = 196
    Top = 588
    Width = 75
    Height = 25
    Caption = '&Save'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 5
    OnClick = btnSaveClick
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
  object btnCancel: TBitBtn
    Left = 296
    Top = 588
    Width = 75
    Height = 25
    Caption = '&Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = btnCancelClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
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
    NumGlyphs = 2
  end
  object gpConsult: TGroupBox
    Left = 20
    Top = 40
    Width = 525
    Height = 150
    Caption = 'Consult'
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    object lblName: TLabel
      Left = 10
      Top = 25
      Width = 181
      Height = 16
      Caption = '1. Select: SERVICE NAME'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object imgName: TImage
      Tag = 1
      Left = 490
      Top = 25
      Width = 17
      Height = 17
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000C20E0000C20E0000000000000000
        0000C0C0C0C0C0C0C0C0C0C0C0C0B3ABAA8669626E3D2E5E241358201061352A
        7B625FB0A9A9C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C5C4C39370638747
        29A55C33AC5D2FA95629A55123A34C1D923F175C200E775B56C4C3C3C0C0C0C0
        C0C0C0C0C0C5C4C39B6B55A96842B46E41B66F45CEA086CD9C81CB997EB7724C
        A44C1DA04617823613673F35C4C3C3C0C0C0C0C0C0B08C77B4754EBB794EB873
        47BE7F57FCFCFCFCFCFCFCFCFCD1A58CA75123A44C1CA14617833511795954C0
        C0C0C3BAB4B77C55BF845ABE7E53BA784EBF835CFCFCFCFCFCFCFCFCFCD2A88F
        AA5729A75022A44C1CA04416652510C0C0C0C3A187C58E65C28860BF8359BD7D
        53BC7B51C58D6BC28966C08561B67047AC5C2EA95628A75022A34B1B953F1577
        554DCB9C79C9956CC58E65C2885FBF8359BD7D52FBFAFAFCFCFCFCFCFCD1A68C
        AE6134AC5B2DA95628A64F21A14A1B67301ED0A581CC9972C7936AC58D64C288
        5FBF8258EAD8CCFCFCFCFCFCFCF7F0EDC48D6CAE6134AC5B2DA95527A54F216C
        2F17D4AE8DCE9F78CA9870C7936AC58D64C1875EC68F69F2E7E0FCFCFCFCFCFC
        FBFAFAD6B099AE6033AC5B2DA8542775361BD9BA9CD1A67FCD9D75CA9870C792
        69CD9D7BC8946FC0865DE4CBBAFCFCFCFCFCFCFCFCFCD3AB93AE6033AB5B2D83
        4328D9C6B1D5AE89D0A37BF2E8E0FCFCFCFCFCFCEDDED2C1875DBF8157F5EDE8
        FCFCFCFCFCFCEAD8CEB06539AB5E3398674FCEC9C4E0C2A4D3AA83E5CFBBFCFC
        FCFCFCFCFCFCFCF2E7E0EDDED2FCFCFCFCFCFCFCFCFCDEBFACB36B3EA55D35BB
        ACA6C0C0C0DFCFBCDBBA98D2AA84EDDFD1FCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
        FCFCFCECDCD1BD7D54B67145AF7A5CC0C0C0C0C0C0C9C8C8E6D2BBDCBA99D2A9
        83DAB89AE4CDB9E7D3C3E6D1C0E1C6B1CE9F7FBF8156BE8055BA7E58C7C5C4C0
        C0C0C0C0C0C0C0C0C9C8C8E3D4C2E4CBB0D7B08CD1A57ECE9E76CB9970C7936B
        C79269CA956EC59877C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D1CD
        C7E2D2BDE3CBB1E2C4A8DDBC9DD8B393D1AF93C9BBAFC0C0C0C0C0C0C0C0C0C0
        C0C0}
      OnClick = HelpClick
    end
    object lblProcedure: TLabel
      Left = 10
      Top = 85
      Width = 236
      Height = 16
      Caption = '2. Select: PROCEDURE (Optional)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object imgProcedure: TImage
      Tag = 2
      Left = 490
      Top = 85
      Width = 17
      Height = 17
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000C20E0000C20E0000000000000000
        0000C0C0C0C0C0C0C0C0C0C0C0C0B3ABAA8669626E3D2E5E241358201061352A
        7B625FB0A9A9C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C5C4C39370638747
        29A55C33AC5D2FA95629A55123A34C1D923F175C200E775B56C4C3C3C0C0C0C0
        C0C0C0C0C0C5C4C39B6B55A96842B46E41B66F45CEA086CD9C81CB997EB7724C
        A44C1DA04617823613673F35C4C3C3C0C0C0C0C0C0B08C77B4754EBB794EB873
        47BE7F57FCFCFCFCFCFCFCFCFCD1A58CA75123A44C1CA14617833511795954C0
        C0C0C3BAB4B77C55BF845ABE7E53BA784EBF835CFCFCFCFCFCFCFCFCFCD2A88F
        AA5729A75022A44C1CA04416652510C0C0C0C3A187C58E65C28860BF8359BD7D
        53BC7B51C58D6BC28966C08561B67047AC5C2EA95628A75022A34B1B953F1577
        554DCB9C79C9956CC58E65C2885FBF8359BD7D52FBFAFAFCFCFCFCFCFCD1A68C
        AE6134AC5B2DA95628A64F21A14A1B67301ED0A581CC9972C7936AC58D64C288
        5FBF8258EAD8CCFCFCFCFCFCFCF7F0EDC48D6CAE6134AC5B2DA95527A54F216C
        2F17D4AE8DCE9F78CA9870C7936AC58D64C1875EC68F69F2E7E0FCFCFCFCFCFC
        FBFAFAD6B099AE6033AC5B2DA8542775361BD9BA9CD1A67FCD9D75CA9870C792
        69CD9D7BC8946FC0865DE4CBBAFCFCFCFCFCFCFCFCFCD3AB93AE6033AB5B2D83
        4328D9C6B1D5AE89D0A37BF2E8E0FCFCFCFCFCFCEDDED2C1875DBF8157F5EDE8
        FCFCFCFCFCFCEAD8CEB06539AB5E3398674FCEC9C4E0C2A4D3AA83E5CFBBFCFC
        FCFCFCFCFCFCFCF2E7E0EDDED2FCFCFCFCFCFCFCFCFCDEBFACB36B3EA55D35BB
        ACA6C0C0C0DFCFBCDBBA98D2AA84EDDFD1FCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
        FCFCFCECDCD1BD7D54B67145AF7A5CC0C0C0C0C0C0C9C8C8E6D2BBDCBA99D2A9
        83DAB89AE4CDB9E7D3C3E6D1C0E1C6B1CE9F7FBF8156BE8055BA7E58C7C5C4C0
        C0C0C0C0C0C0C0C0C9C8C8E3D4C2E4CBB0D7B08CD1A57ECE9E76CB9970C7936B
        C79269CA956EC59877C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D1CD
        C7E2D2BDE3CBB1E2C4A8DDBC9DD8B393D1AF93C9BBAFC0C0C0C0C0C0C0C0C0C0
        C0C0}
      OnClick = HelpClick
    end
    object cmbName: TComboBox
      Left = 10
      Top = 45
      Width = 500
      Height = 21
      DropDownCount = 1000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnChange = cmbNameChange
    end
    object cmbProcedure: TComboBox
      Tag = 1
      Left = 10
      Top = 105
      Width = 500
      Height = 21
      DropDownCount = 1000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 1
      OnChange = SetSaveButton
    end
  end
  object gpImaging: TGroupBox
    Left = 20
    Top = 200
    Width = 525
    Height = 150
    Caption = 'Imaging'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object lblSpecialtyIndex: TLabel
      Left = 10
      Top = 25
      Width = 200
      Height = 16
      Caption = '3. Select: SPECIALTY INDEX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblProcedureIndex: TLabel
      Left = 10
      Top = 85
      Width = 269
      Height = 16
      Caption = '4. Select: PROCEDURE/EVENT INDEX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object imgSpecialtyIndex: TImage
      Tag = 3
      Left = 490
      Top = 25
      Width = 17
      Height = 17
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000C20E0000C20E0000000000000000
        0000C0C0C0C0C0C0C0C0C0C0C0C0B3ABAA8669626E3D2E5E241358201061352A
        7B625FB0A9A9C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C5C4C39370638747
        29A55C33AC5D2FA95629A55123A34C1D923F175C200E775B56C4C3C3C0C0C0C0
        C0C0C0C0C0C5C4C39B6B55A96842B46E41B66F45CEA086CD9C81CB997EB7724C
        A44C1DA04617823613673F35C4C3C3C0C0C0C0C0C0B08C77B4754EBB794EB873
        47BE7F57FCFCFCFCFCFCFCFCFCD1A58CA75123A44C1CA14617833511795954C0
        C0C0C3BAB4B77C55BF845ABE7E53BA784EBF835CFCFCFCFCFCFCFCFCFCD2A88F
        AA5729A75022A44C1CA04416652510C0C0C0C3A187C58E65C28860BF8359BD7D
        53BC7B51C58D6BC28966C08561B67047AC5C2EA95628A75022A34B1B953F1577
        554DCB9C79C9956CC58E65C2885FBF8359BD7D52FBFAFAFCFCFCFCFCFCD1A68C
        AE6134AC5B2DA95628A64F21A14A1B67301ED0A581CC9972C7936AC58D64C288
        5FBF8258EAD8CCFCFCFCFCFCFCF7F0EDC48D6CAE6134AC5B2DA95527A54F216C
        2F17D4AE8DCE9F78CA9870C7936AC58D64C1875EC68F69F2E7E0FCFCFCFCFCFC
        FBFAFAD6B099AE6033AC5B2DA8542775361BD9BA9CD1A67FCD9D75CA9870C792
        69CD9D7BC8946FC0865DE4CBBAFCFCFCFCFCFCFCFCFCD3AB93AE6033AB5B2D83
        4328D9C6B1D5AE89D0A37BF2E8E0FCFCFCFCFCFCEDDED2C1875DBF8157F5EDE8
        FCFCFCFCFCFCEAD8CEB06539AB5E3398674FCEC9C4E0C2A4D3AA83E5CFBBFCFC
        FCFCFCFCFCFCFCF2E7E0EDDED2FCFCFCFCFCFCFCFCFCDEBFACB36B3EA55D35BB
        ACA6C0C0C0DFCFBCDBBA98D2AA84EDDFD1FCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
        FCFCFCECDCD1BD7D54B67145AF7A5CC0C0C0C0C0C0C9C8C8E6D2BBDCBA99D2A9
        83DAB89AE4CDB9E7D3C3E6D1C0E1C6B1CE9F7FBF8156BE8055BA7E58C7C5C4C0
        C0C0C0C0C0C0C0C0C9C8C8E3D4C2E4CBB0D7B08CD1A57ECE9E76CB9970C7936B
        C79269CA956EC59877C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D1CD
        C7E2D2BDE3CBB1E2C4A8DDBC9DD8B393D1AF93C9BBAFC0C0C0C0C0C0C0C0C0C0
        C0C0}
      OnClick = HelpClick
    end
    object imgProcedureIndex: TImage
      Tag = 4
      Left = 492
      Top = 85
      Width = 17
      Height = 17
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000C20E0000C20E0000000000000000
        0000C0C0C0C0C0C0C0C0C0C0C0C0B3ABAA8669626E3D2E5E241358201061352A
        7B625FB0A9A9C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C5C4C39370638747
        29A55C33AC5D2FA95629A55123A34C1D923F175C200E775B56C4C3C3C0C0C0C0
        C0C0C0C0C0C5C4C39B6B55A96842B46E41B66F45CEA086CD9C81CB997EB7724C
        A44C1DA04617823613673F35C4C3C3C0C0C0C0C0C0B08C77B4754EBB794EB873
        47BE7F57FCFCFCFCFCFCFCFCFCD1A58CA75123A44C1CA14617833511795954C0
        C0C0C3BAB4B77C55BF845ABE7E53BA784EBF835CFCFCFCFCFCFCFCFCFCD2A88F
        AA5729A75022A44C1CA04416652510C0C0C0C3A187C58E65C28860BF8359BD7D
        53BC7B51C58D6BC28966C08561B67047AC5C2EA95628A75022A34B1B953F1577
        554DCB9C79C9956CC58E65C2885FBF8359BD7D52FBFAFAFCFCFCFCFCFCD1A68C
        AE6134AC5B2DA95628A64F21A14A1B67301ED0A581CC9972C7936AC58D64C288
        5FBF8258EAD8CCFCFCFCFCFCFCF7F0EDC48D6CAE6134AC5B2DA95527A54F216C
        2F17D4AE8DCE9F78CA9870C7936AC58D64C1875EC68F69F2E7E0FCFCFCFCFCFC
        FBFAFAD6B099AE6033AC5B2DA8542775361BD9BA9CD1A67FCD9D75CA9870C792
        69CD9D7BC8946FC0865DE4CBBAFCFCFCFCFCFCFCFCFCD3AB93AE6033AB5B2D83
        4328D9C6B1D5AE89D0A37BF2E8E0FCFCFCFCFCFCEDDED2C1875DBF8157F5EDE8
        FCFCFCFCFCFCEAD8CEB06539AB5E3398674FCEC9C4E0C2A4D3AA83E5CFBBFCFC
        FCFCFCFCFCFCFCF2E7E0EDDED2FCFCFCFCFCFCFCFCFCDEBFACB36B3EA55D35BB
        ACA6C0C0C0DFCFBCDBBA98D2AA84EDDFD1FCFCFCFCFCFCFCFCFCFCFCFCFCFCFC
        FCFCFCECDCD1BD7D54B67145AF7A5CC0C0C0C0C0C0C9C8C8E6D2BBDCBA99D2A9
        83DAB89AE4CDB9E7D3C3E6D1C0E1C6B1CE9F7FBF8156BE8055BA7E58C7C5C4C0
        C0C0C0C0C0C0C0C0C9C8C8E3D4C2E4CBB0D7B08CD1A57ECE9E76CB9970C7936B
        C79269CA956EC59877C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0D1CD
        C7E2D2BDE3CBB1E2C4A8DDBC9DD8B393D1AF93C9BBAFC0C0C0C0C0C0C0C0C0C0
        C0C0}
      OnClick = HelpClick
    end
    object cmbSpecialtyIndex: TComboBox
      Left = 10
      Top = 45
      Width = 500
      Height = 21
      DropDownCount = 1000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 0
      OnChange = cmbSpecialtyIndexChange
    end
    object cmbProcedureIndex: TComboBox
      Left = 10
      Top = 105
      Width = 500
      Height = 21
      DropDownCount = 1000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 1
      OnChange = SetSaveButton
    end
  end
  object amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = frmAddEditUnreadList'
        'Status = stsDefault'))
  end
end
