object frameIndexFields: TframeIndexFields
  Left = 0
  Top = 0
  Width = 675
  Height = 275
  Color = clBtnFace
  ParentColor = False
  TabOrder = 0
  object lbClass: TLabel
    Left = 643
    Top = 293
    Width = 25
    Height = 13
    Caption = 'Class'
    Visible = False
  end
  object lboldType: TLabel
    Left = 151
    Top = 70
    Width = 57
    Height = 13
    Cursor = crHandPoint
    Caption = '<old Type>'
    OnClick = lboldTypeClick
  end
  object lboldSpec: TLabel
    Left = 151
    Top = 95
    Width = 56
    Height = 13
    Cursor = crHandPoint
    Caption = '<old Spec>'
    OnClick = lboldSpecClick
  end
  object lboldProc: TLabel
    Left = 151
    Top = 119
    Width = 54
    Height = 13
    Cursor = crHandPoint
    Caption = '<old Proc>'
    OnClick = lboldProcClick
  end
  object lboldShortDesc: TLabel
    Left = 151
    Top = 144
    Width = 82
    Height = 13
    Cursor = crHandPoint
    Caption = '<old ShortDesc>'
    OnClick = lboldShortDescClick
  end
  object lboldOrigin: TLabel
    Left = 151
    Top = 46
    Width = 61
    Height = 13
    Cursor = crHandPoint
    Caption = '<old Origin>'
    OnClick = lboldOriginClick
  end
  object lboldClass: TLabel
    Left = 639
    Top = 309
    Width = 55
    Height = 13
    Caption = '<oldClass>'
    Visible = False
  end
  object lbPackage: TLabel
    Left = 252
    Top = 320
    Width = 40
    Height = 13
    Caption = 'Package'
    Visible = False
  end
  object lbOldSensitive: TLabel
    Left = 151
    Top = 169
    Width = 76
    Height = 13
    Cursor = crHandPoint
    Caption = '<old Sensitive>'
    OnClick = lbOldSensitiveClick
  end
  object lbOldStatus: TLabel
    Left = 151
    Top = 193
    Width = 64
    Height = 13
    Cursor = crHandPoint
    Caption = '<old Status>'
    OnClick = lbOldStatusClick
  end
  object lbOldStatusReason: TLabel
    Left = 151
    Top = 218
    Width = 100
    Height = 13
    Cursor = crHandPoint
    Caption = '<old StatusReason>'
    OnClick = lbOldStatusReasonClick
  end
  object lbOldImageCreationDate: TLabel
    Left = 151
    Top = 243
    Width = 127
    Height = 13
    Cursor = crHandPoint
    Caption = '<old ImageCreationDate>'
    OnClick = lbOldImageCreationDateClick
  end
  object lbImageDescription: TLabel
    Left = 0
    Top = 0
    Width = 675
    Height = 37
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = '<Image Description>'
    Layout = tlCenter
    WordWrap = True
  end
  object Bevel1: TBevel
    Left = 0
    Top = 37
    Width = 675
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object Bevel2: TBevel
    Left = 0
    Top = 273
    Width = 675
    Height = 2
    Align = alBottom
    Shape = bsTopLine
  end
  object cmbType: TComboBox
    Left = 355
    Top = 66
    Width = 310
    Height = 21
    Style = csDropDownList
    DropDownCount = 30
    Enabled = False
    ItemHeight = 13
    TabOrder = 3
    OnKeyDown = cmbTypeKeyDown
  end
  object cmbSpecSubSpec: TComboBox
    Left = 355
    Top = 91
    Width = 310
    Height = 21
    Style = csDropDownList
    DropDownCount = 30
    Enabled = False
    ItemHeight = 13
    TabOrder = 5
    OnChange = cmbSpecSubSpecChange
    OnKeyDown = cmbSpecSubSpecKeyDown
  end
  object cmbProcEvent: TComboBox
    Left = 355
    Top = 115
    Width = 310
    Height = 21
    Style = csDropDownList
    DropDownCount = 30
    Enabled = False
    ItemHeight = 13
    TabOrder = 7
    OnChange = cmbProcEventChange
    OnKeyDown = cmbProcEventKeyDown
  end
  object cmbOrigin: TComboBox
    Left = 355
    Top = 42
    Width = 119
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    TabOrder = 1
    OnKeyDown = cmbOriginKeyDown
  end
  object edtshortdesc: TEdit
    Left = 355
    Top = 140
    Width = 310
    Height = 21
    Enabled = False
    MaxLength = 60
    TabOrder = 9
    OnKeyDown = edtshortdescKeyDown
  end
  object rbClin: TRadioButton
    Left = 647
    Top = 263
    Width = 91
    Height = 17
    Caption = 'Clinical Types'
    Checked = True
    TabOrder = 18
    TabStop = True
    Visible = False
    OnClick = rbClinClick
  end
  object rbAdmin: TRadioButton
    Left = 653
    Top = 254
    Width = 91
    Height = 17
    Caption = 'Admin Types'
    TabOrder = 19
    Visible = False
    OnClick = rbAdminClick
  end
  object cbType: TCheckBox
    Left = 7
    Top = 66
    Width = 134
    Height = 17
    Cursor = crHandPoint
    Caption = 'Type'
    TabOrder = 2
    OnClick = cbTypeClick
  end
  object cbSpecSubSpec: TCheckBox
    Left = 7
    Top = 91
    Width = 134
    Height = 17
    Cursor = crHandPoint
    Caption = 'Spec/SubSpec'
    TabOrder = 4
    OnClick = cbSpecSubSpecClick
  end
  object cbProcEvent: TCheckBox
    Left = 7
    Top = 116
    Width = 134
    Height = 17
    Cursor = crHandPoint
    Caption = 'Procedure/Event'
    TabOrder = 6
    OnClick = cbProcEventClick
  end
  object cbShortDesc: TCheckBox
    Left = 7
    Top = 141
    Width = 134
    Height = 17
    Cursor = crHandPoint
    Caption = 'Short Desc'
    TabOrder = 8
    OnClick = cbShortDescClick
  end
  object cbOrigin: TCheckBox
    Left = 7
    Top = 42
    Width = 134
    Height = 17
    Cursor = crHandPoint
    Caption = 'Origin'
    TabOrder = 0
    OnClick = cbOriginClick
  end
  object cmbSensitive: TComboBox
    Left = 355
    Top = 165
    Width = 65
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 11
  end
  object cmbStatus: TComboBox
    Left = 355
    Top = 189
    Width = 158
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 13
  end
  object cmbStatusReason: TComboBox
    Left = 355
    Top = 214
    Width = 310
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 15
  end
  object edtImageCreationDate: TEdit
    Left = 355
    Top = 239
    Width = 145
    Height = 21
    Enabled = False
    TabOrder = 17
  end
  object cbSensitive: TCheckBox
    Left = 7
    Top = 165
    Width = 134
    Height = 17
    Cursor = crHandPoint
    Caption = 'Controlled Image'
    TabOrder = 10
    OnClick = cbSensitiveClick
  end
  object cbStatus: TCheckBox
    Left = 7
    Top = 190
    Width = 134
    Height = 17
    Cursor = crHandPoint
    Caption = 'Status'
    TabOrder = 12
    OnClick = cbStatusClick
  end
  object cbStatusReason: TCheckBox
    Left = 7
    Top = 215
    Width = 134
    Height = 17
    Cursor = crHandPoint
    Caption = 'Status Reason'
    TabOrder = 14
    OnClick = cbStatusReasonClick
  end
  object cbImageCreationDate: TCheckBox
    Left = 7
    Top = 240
    Width = 134
    Height = 17
    Cursor = crHandPoint
    Caption = 'Image Creation Date'
    TabOrder = 16
    OnClick = cbImageCreationDateClick
  end
end
