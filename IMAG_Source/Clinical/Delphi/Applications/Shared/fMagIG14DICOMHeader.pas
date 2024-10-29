Unit Fmagig14dicomheader;

Interface

Uses

  ComCtrls,
  Controls,
  Forms,
  GearMEDLib_TLB,
  Stdctrls,
  Classes
, imaginterfaces
  ;


Type
  TfrmIG14DICOMHeader = Class(TForm)
    TxtTagName: TEdit;
    btnOK: TButton;
    LstHeaders: TListBox;
    PcHeader: TPageControl;
    TsHeader: TTabSheet;
    TsGroup2: TTabSheet;
    LstGroup2: TListBox;
    LblGroup2Header: Tlabel;
    LblHeaderHeader: Tlabel;
    Button1: TButton;
    Procedure btnOKClick(Sender: Tobject);
    Procedure LstHeadersClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure Button1Click(Sender: Tobject);
    Procedure PcHeaderChange(Sender: Tobject);
    Procedure LstGroup2Click(Sender: Tobject);
  Private
    FCurrentMedPage: IGMedPage;
    FMedDataDict: IGMedDataDict;

    FGroup2Present: Boolean;
    FHeaderPresent: Boolean;
    Procedure LoadHeader(DataSet: IGMedElemList; CurrentMedPage: IGMedPage;
      MedDataDict: IGMedDataDict; ListBox: TListBox);
    { Private declarations }
  Public
    Procedure ShowHeader(CurrentMedPage: IGMedPage; MedDataDict: IGMedDataDict);
    { Public declarations }
  End;

Function LZStr(Str: String): String;

//var
//  frmIG14DICOMHeader: TfrmIG14DICOMHeader;

Implementation
Uses
  GearFORMATSLib_TLB,
  SysUtils
  ;

{$R *.dfm}


Procedure TfrmIG14DICOMHeader.LoadHeader(DataSet: IGMedElemList;
  CurrentMedPage: IGMedPage; MedDataDict: IGMedDataDict; ListBox: TListBox);
Var
  CurrentElem: IGMedDataElem;
  ListStr: String;
  TagIndex, SpaceCntr,
    ItemIndex: Integer;
  VRInfo: IGMedVRInfo;
Begin
  CurrentElem := DataSet.CurrentElem;

  For TagIndex := 0 To DataSet.ElemCount - 1 Do
  Begin
    VRInfo := MedDataDict.GetVRInfo(CurrentElem.ValueRepresentation);

    ListStr := '';
    For SpaceCntr := 0 To DataSet.CurrentLevel Do
      ListStr := ListStr + ' ';

    ListStr := ListStr + '(' + LZStr(Format('%4x', [MedDataDict.GetTagGroup(CurrentElem.Tag)])) +
    ',' + LZStr(Format('%4x', [MedDataDict.GetTagElement(CurrentElem.Tag)])) + ')  ';

    If ((CurrentElem.Tag = DCM_TAG_PixelData) And
      (DataSet.CurrentLevel = 0)) Then

      // Pixel Data

      ListStr := ListStr +
        VRInfo.StringID + ' ' +
        '<Pixel Data> bytes=' +
        LZStr(Format('%3d', [CurrentElem.ValueLength]))

    Else
      If (CurrentElem.Tag = DCM_TAG_ItemItem) Or
        (CurrentElem.Tag = DCM_TAG_ItemDelimitationItem) Or
        (CurrentElem.Tag = DCM_TAG_SequenceDelimitationItem) Then

      // Sequence
      Else
      Begin

        // Other Data elements
        ListStr := ListStr +
          VRInfo.StringID +
          ' ' + LZStr(Format('%3.d', [CurrentElem.ValueLength])) +
          ' ' + LZStr(Format('%2.d', [CurrentElem.ValueMultiplicity])) +
          ' ' + LZStr(Format('%1.d', [DataSet.CurrentLevel])) + ' ';

        If ((CurrentElem.ValueRepresentation = MED_DCM_VR_OB) Or
          (CurrentElem.ValueRepresentation = MED_DCM_VR_OW) Or
          (CurrentElem.ValueRepresentation = MED_DCM_VR_UN)) Then
                         // Binary VRs
        Begin
          ItemIndex := 0;
          While ((ItemIndex < CurrentElem.ItemCount) And (Length(ListStr) < 100)) Do
          Begin
            If (CurrentElem.ValueRepresentation = MED_DCM_VR_OW) Then
              ListStr := ListStr + '&h' +
                LZStr(Format('%4x', [CurrentElem.Long[ItemIndex]])) + ' '
            Else
              ListStr := ListStr + '&h' +
                LZStr(Format('%2x', [CurrentElem.Long[ItemIndex]])) + ' ';

            ItemIndex := ItemIndex + 1;
          End;
        End
        Else
          If (VRInfo.ItemType = AM_TID_META_STRING) Then
          Begin
            // String VRs

            ListStr := ListStr + '|';
            ItemIndex := 0;
            While ((ItemIndex < CurrentElem.ItemCount) And (Length(ListStr) < 100)) Do
            Begin
              If (ItemIndex < (CurrentElem.ItemCount - 1)) Then
                ListStr := ListStr + CurrentElem.String_[ItemIndex] + '\'
              Else
                ListStr := ListStr + CurrentElem.String_[ItemIndex];

              ItemIndex := ItemIndex + 1;
            End;
            ListStr := ListStr + '|';
          End
          Else
          // The simplest way - output data as string
          // This works for all VRs
            ListStr := ListStr + CurrentElem.OutputDataToString(0, -1, '\', 100);
      End;
          //lstHeaders.Items.Add( ListStr );
    ListBox.Items.Add(ListStr);
    DataSet.MoveNext(MED_DCM_MOVE_LEVEL_FLOAT);
  End;
End;

Procedure TfrmIG14DICOMHeader.ShowHeader(CurrentMedPage: IGMedPage; MedDataDict: IGMedDataDict);
Var
  DataSet: IGMedElemList;
  CurrentElem: IGMedDataElem;
  ListStr: String;
  TagIndex, SpaceCntr,
    ItemIndex: Integer;
  VRInfo: IGMedVRInfo;

Begin
  Try

    FCurrentMedPage := CurrentMedPage;
    FMedDataDict := MedDataDict;
//  self.Caption := FileTitle;

    TxtTagName.Text := '';
    FHeaderPresent := False;
    FGroup2Present := False;
    If (Not CurrentMedPage.IsDICOMStructurePresent(MED_STRUCTURE_TYPE_DATASET)) Then
      LstHeaders.Items.Add('Current image does not contain a DataSet')
    Else
    Begin
      DataSet := CurrentMedPage.DataSet;

      If ((DataSet = Nil) Or (DataSet.ElemCount <= 0)) Then
        LstHeaders.Items.Add('Tag list is empty')
      Else
      Begin
        DataSet.MoveFirst(MED_DCM_MOVE_LEVEL_FLOAT);
        LoadHeader(DataSet, CurrentMedPage, MedDataDict, LstHeaders);
        FHeaderPresent := True;
      End; // tag list isn't empty

      DataSet := CurrentMedPage.FileMetaInfo;

//        If (Not (DataSet.ElemCount > 0)) Then
      If ((DataSet = Nil) Or (DataSet.ElemCount <= 0)) Then
        LstGroup2.Items.Add('Tag list is empty')
      Else
      Begin
        DataSet.MoveFind(MED_DCM_MOVE_LEVEL_FLOAT, DCM_TAG_FileMetaInformationVersion);
        LoadHeader(DataSet, CurrentMedPage, MedDataDict, LstGroup2);
        FGroup2Present := True;
      End; // tag list isn't empty
    End; // DataSet is present
  Except
    On e: Exception Do
    Begin
      magAppMsg('s', 'Exception loading DICOM header, ' + e.Message, MagmsgERROR);
    End;
  End;
  Self.Showmodal();
//  self.FormStyle := fsStayOnTop;

End;

Procedure TfrmIG14DICOMHeader.btnOKClick(Sender: Tobject);
Begin
  ModalResult := MrOK;
End;

Function LZStr(Str: String): String;
Var
  i: Integer;
  StrOut: String;
Begin
  Result := '';
  For i := 1 To Length(Str) Do
  Begin
    If (Str[i] <> ' ') Then
      Result := Result + Str[i]
    Else
      Result := Result + '0';

  End;
End;

{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TfrmIG14DICOMHeader.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(FOnLogEvent) then
//    FOnLogEvent(self, MsgType, Msg, Priority);
//end;

Procedure TfrmIG14DICOMHeader.LstHeadersClick(Sender: Tobject);
Var
  TagInfo: IGMedTagInfo;
  Index,
    Tag: Integer;
Begin
  If (FCurrentMedPage.IsDICOMStructurePresent(MED_STRUCTURE_TYPE_DATASET) And FHeaderPresent) Then
  Begin
    Index := LstHeaders.ItemIndex;

    If (Index <> -1) Then
    Begin
            // Move the current tag to the tag selected
      FCurrentMedPage.DataSet.CurrentIndex := Index;
            //FCurrentMedPage.FileMetaInfo.CurrentIndex := Index;
      Tag := FCurrentMedPage.DataSet.CurrentElem.Tag;

            // Look up info about this tag
      TagInfo := FMedDataDict.GetTagInfo(Tag);

            // Form and print the string
      TxtTagName.Text := Format('%3d', [Index]) + ' ' +
        TagInfo.Name;

    End;
  End;
End;

Procedure TfrmIG14DICOMHeader.FormCreate(Sender: Tobject);
Begin
  // getformposition ?
  LblHeaderHeader.caption := 'Tag              VR    VL   Ct    L   Data Value';
  LblGroup2Header.caption := 'Tag              VR    VL   Ct    L   Data Value';
  PcHeader.ActivePageIndex := 0;
End;

Procedure TfrmIG14DICOMHeader.Button1Click(Sender: Tobject);
Begin
  LstHeaders.Items.SaveToFile('c:\dicomheader.txt');
End;

Procedure TfrmIG14DICOMHeader.PcHeaderChange(Sender: Tobject);
Begin
  TxtTagName.Text := '';
End;

Procedure TfrmIG14DICOMHeader.LstGroup2Click(Sender: Tobject);
Var
  TagInfo: IGMedTagInfo;
  Index,
    Tag: Integer;
Begin
  If (FCurrentMedPage.IsDICOMStructurePresent(MED_STRUCTURE_TYPE_DATASET) And FGroup2Present) Then
  Begin
    Index := LstGroup2.ItemIndex;

    If (Index <> -1) Then
    Begin
            // Move the current tag to the tag selected
      FCurrentMedPage.FileMetaInfo.CurrentIndex := Index;
      Tag := FCurrentMedPage.FileMetaInfo.CurrentElem.Tag;

            // Look up info about this tag
      TagInfo := FMedDataDict.GetTagInfo(Tag);

            // Form and print the string
      TxtTagName.Text := Format('%3d', [Index]) + ' ' +
        TagInfo.Name;

    End;
  End;

End;

End.
