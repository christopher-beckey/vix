Unit fMagDicomEntry;
 {CodeCR677  Captioned was also changed. to 'Dicom Header Data Entry' for CR677}
Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls,
  Buttons,
  ExtCtrls,
  ComCtrls,
  //va
  trpcb,
  //imaging
  cMagPat,
//p129  GEARLib_TLB ,
  cmag4VGear,
  magpositions,
  umagutils8    //p117
  ;


Type

  TfrmDICOMEntry = Class(TForm)
    PnlBottom: Tpanel;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    PageControl1: TPageControl;
    btnShow: TBitBtn;
    Procedure FormShow(Sender: Tobject);
    Procedure btnCancelClick(Sender: Tobject);
    Procedure EditChange(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure btnSaveClick(Sender: Tobject);
    Procedure btnShowClick(Sender: Tobject);
  Private
    { Private declarations }
//p117  gek - made public   slFields: Tstringlist;
//p117  gek - made public   slElements: Tstringlist;
    Procedure BuildDataEntryControls;
    Function AllMandatoryFieldsPopulated: Boolean;
//p117  gek - made public   Procedure AddSystemGenValsToResultSet;
//p117  gek - made public    Procedure GetDicomFieldsForSOP(Sl: Tstringlist);
    Function GetDefaultText(sElement: String): String;
    Procedure PopulateControlsWithDefaults;
    Procedure PassDefaultsToMainForm;
    Procedure PopStringListWithValues;
    Procedure SetFocusTo1stDataEntryControl;
    Procedure SetFormHeight;
    function SetFormWidth: integer;
  Public
    slFields: Tstringlist;
    slElements: Tstringlist;  
    
{ Public declarations }

    {//p117  this tells if result is 'User' selections or System Generated or all}    
    ResultDataSet : integer;     
    SeriesNum: String;
    StudyUID: String;
    slData: Tstringlist;
    GEARmg1 : Tmag4vGear; //p129 GEAR: TGear;
    Patient: TMag4Pat;
    SOP: String;
    Broker: TRPCBroker;
    ImageCTR: Integer;
    ConsultStr: String;
    Username: String;
    TRCSeriesUID: String;
    TRCSOPInstanceUID: String;
    slDefaults: Tstringlist;
    Description: string;
    ImageFileName: string;

{/p117 gek made public }
    Procedure AddSystemGenValsToResultSet;
    Procedure GetDicomFieldsForSOP(Sl: Tstringlist);

  End;

Var
  frmDICOMEntry: TfrmDICOMEntry;
   {/p117 constants for change in form to return only User Data, Generated Data or All Data}
const
  rdsAll : integer = 0;
  rdsUser : integer = 1;
  rdsGen : integer = 2;
Implementation

Uses
  StrUtils,
  uMAGDicomObj,
  uMAGDicomFunctions,
  MagFMComponents,
  DiTypLib,
  UMagDefinitions;

Const
  TOP_MARGIN = 50;
  EDIT_WIDTH = 500;
  LEFT_DEF = 50;
  SPACING = 75;
  Del = '^';
  LST_DEL = #13 + #10;

{$R *.dfm}

Procedure TfrmDICOMEntry.btnCancelClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmDICOMEntry.SetFocusTo1stDataEntryControl;
Var
  CTRL: TWinControl;
  Ts: TTabSheet;
  SB: TScrollBox;
  i: Integer;
Begin
  Ts := TTabSheet(PageControl1.Pages[0]);
  SB := TScrollBox(Ts.Controls[0]);
  For i := 0 To SB.ControlCount - 1 Do
  Begin
    CTRL := TWinControl(SB.Controls[i]);
    If (CTRL.ClassName = 'TDicomEdit') Or (CTRL.ClassName = 'TMemo') Or (CTRL.ClassName = 'TComboBox') Then Break;
  End;
  CTRL.SetFocus;
End;

Procedure TfrmDICOMEntry.SetFormHeight;
Var
  CTRL: TWinControl;
  Ts: TTabSheet;
  SB: TScrollBox;
  i, j, IHeight: Integer;
Begin
  IHeight := 0;
  For i := 0 To PageControl1.PageCount - 1 Do
  Begin
    Ts := TTabSheet(PageControl1.Pages[i]);
    SB := TScrollBox(Ts.Controls[0]);
    For j := 0 To SB.ControlCount - 1 Do
    Begin
      CTRL := TWinControl(SB.Controls[j]);
      If IHeight < CTRL.Top + CTRL.Height Then IHeight := CTRL.Top + CTRL.Height;
    End;
  End;
  IHeight := IHeight + PnlBottom.Height + 100;
  If IHeight < Screen.Height Then Self.Height := IHeight;
End;

function TfrmDICOMEntry.SetFormWidth: integer;
var i, j, iTemp: integer; SB: TScrollBox; CTRL: TWinControl;
const BUFFER = 50;
begin
  result := 0;
  for i := 0 to PageControl1.PageCount - 1 do
  begin
    SB := TScrollBox(PageControl1.Pages[i].Controls[0]);
    for j := 0 to SB.ControlCount - 1 do
    begin
      CTRL := TWinControl(SB.Controls[j]);
      iTemp := CTRL.Left + CTRL.Width;
      if iTemp > result then result := iTemp;
    end;
  end;
  result := result + BUFFER;
end;

Procedure TfrmDICOMEntry.FormShow(Sender: Tobject);
Var
  i, j: Integer;
  Ts: TTabSheet;
  SB: TScrollBox;
Begin
  GetDicomFieldsForSOP(slFields); {Makes RPC Call to load slFields.}
  BuildDataEntryControls;
  If PageControl1.PageCount > 0 Then
  Begin
    PageControl1.ActivePageIndex := 0;
    For i := 0 To PageControl1.ControlCount - 1 Do
    Begin
      Ts := TTabSheet(PageControl1.Controls[i]);
      SB := TScrollBox(Ts.Controls[0]);
      For j := 0 To SB.ControlCount - 1 Do
      Begin
        If SB.Controls[j] Is TDicomEdit Then TDicomEdit(SB.Controls[j]).OnChange := EditChange;
        If SB.Controls[j] Is TComboBox Then TComboBox(SB.Controls[j]).OnChange := EditChange;
        If SB.Controls[j] Is TMemo Then TMemo(SB.Controls[j]).OnChange := EditChange;
      End;
    End; //for i...
  End; //if PageControl1
  EditChange(Nil); //if no fields are mandatory then automatically set save button to enabled
  SetFormHeight;
  SetFocusTo1stDataEntryControl;
  btnShow.Visible := gDebugUser;
//106t11//  self.Width := SetFormWidth; 
End;

Procedure TfrmDICOMEntry.GetDicomFieldsForSOP(Sl: Tstringlist);
Begin
{ TODO -cRefactor: Broker Calls.  In Capture Application ... old task, keeps getting put off.}
{ for all Broker Calls,  move to cmagDBBroker, and cmagDBMVista.
              Use Try Except to handle the exception.  And handle Error From VistA.}
  Broker.REMOTEPROCEDURE := 'MAG3 DICOM CAPTURE GE LIST';
  Broker.PARAM[0].PTYPE := LITERAL;
  Broker.PARAM[0].Value := 'TELEDERM';
  Broker.LstCALL(Sl);
  Sl.Delete(0); //remove return result
  Sl.Delete(0); //remove column header
End;

//SOP COMMON^0008,0016^SOP Class UID^1^UI^N

Procedure GetFieldProperties(s: String; Var sMod, SName, Stype, sDataType, sCtrl, sElementTag: String);
Begin
  {/p117 gek }
  { TODO : the parameters have values when this call is made.
       by using the same variables,   not cleared between calls, if call fails, the varialbes have old values.
          may or may not be problem. }
  (*
  sMod := Copy(s, 1, Pos(Del, s) - 1);
  s := Copy(s, Pos(Del, s) + 1, Length(s) - Pos(Del, s));
  sElementTag := Copy(s, 1, Pos(Del, s) - 1);
  s := Copy(s, Pos(Del, s) + 1, Length(s) - Pos(Del, s));
  SName := Copy(s, 1, Pos(Del, s) - 1);
  s := Copy(s, Pos(Del, s) + 1, Length(s) - Pos(Del, s));
  Stype := Copy(s, 1, Pos(Del, s) - 1);
  s := Copy(s, Pos(Del, s) + 1, Length(s) - Pos(Del, s));
  sDataType := Copy(s, 1, Pos(Del, s) - 1);
  s := Copy(s, Pos(Del, s) + 1, Length(s) - Pos(Del, s));
  sCtrl := s;  *)

 {/p117 chng START}
 {/p117 gek 1/11/11  use existing utils,  easier to follow.
         example  s = 'GENERAL SERIES^0018,0015^Body Part Examined^3^CS^C' }
  sMod        := magpiece(s,'^',1);
  sElementTag := magpiece(s,'^',2);
  SName       := magpiece(s,'^',3);
  Stype       := magpiece(s,'^',4);
  sDataType   := magpiece(s,'^',5);
  sCtrl       := magpiece(s,'^',6);
End;

Procedure TfrmDICOMEntry.BuildDataEntryControls;
Var
  i, CTR, iTop: Integer;
  sLastMod: String;
  sMod, SName, Stype, sDataType, sCtrl, sElementTag: String;
  Ts: TTabSheet;
  SB: TScrollBox;
  Edit: TDicomEdit;
  Cmb: TComboBox;
  Memo: TMemo;
Begin
  sLastMod := emptystr;
  CTR := 0;
  SB := Nil; //ro remove compile warning
  For i := 0 To slFields.Count - 1 Do
  Begin
    If RightStr(slFields[i], 1) <> 'Z' Then //Z = None
    Begin
      GetFieldProperties(slFields[i], sMod, SName, Stype, sDataType, sCtrl, sElementTag);
      If sLastMod <> sMod Then
      Begin
        Ts := TTabSheet.Create(PageControl1);
        Ts.PageControl := PageControl1;
        Ts.caption := sMod;
        SB := TScrollBox.Create(Ts);
        Ts.InsertControl(SB);
        SB.Align := alClient;
        sLastMod := sMod;
        CTR := 0;
      End;
      Inc(CTR);
      If CTR = 1 Then
        iTop := TOP_MARGIN
      Else
        iTop := (CTR - 1) * SPACING + TOP_MARGIN;
      If sCtrl = 'E' Then //Edit
      Begin
        Edit := TDicomEdit.Create(SB, StrToDicomDataType(sDataType), SName);
        Edit.SetLabelCaption(SName, Stype = '1');
        //106t11// Edit.SetDimensions(iTop, LEFT_DEF, EDIT_WIDTH);
        Edit.SetDimensions(iTop, LEFT_DEF, self.Width- left_def - left_def);
        Edit.Text := emptystr;
        Edit.Hint := sElementTag;
      End
      Else
        If sCtrl = 'C' Then //Combo Box
        Begin
          Cmb := TComboBox.Create(Nil);
          //cmb.Style := csDropDown;
          cmb.Style := csDropDownList;  // p129t16  fix Remedy HD0000000583686
          //106t11// SetControlDimensions(Cmb, iTop, LEFT_DEF, EDIT_WIDTH);
          SetControlDimensions(Cmb, iTop, LEFT_DEF, self.Width- left_def - left_def);
          AddControlToDICOMForm(SB, Cmb, SName, Stype = '1');
          Cmb.Hint := sElementTag;
          cmb.AutoDropDown := true;//p106 rlm 20101228 CR643 "DICOM Dialog Combobox Dropdown"
          LoadComboBox(Cmb, Broker);
        End
        Else
          If sCtrl = 'M' Then //Memo
          Begin
            Memo := TMemo.Create(Nil);
            //106t11// SetControlDimensions(Memo, iTop, LEFT_DEF, EDIT_WIDTH);
            SetControlDimensions(Memo, iTop, LEFT_DEF, self.Width- left_def - left_def);
            AddControlToDICOMForm(SB, Memo, SName, Stype = '1');
            Case StrToDicomDataType(sDataType) Of
              ddtST: Memo.MaxLength := 1024;
              ddtLT: Memo.MaxLength := 10240;
            End;
            Memo.ScrollBars := SsVertical;
            Memo.Height := SPACING + 25;
            Inc(CTR); //memos take up twice as much real estate vertically
            Memo.Hint := sElementTag;
          End;
    End;
    slElements.Add(Copy(slFields[i], Pos(Del, slFields[i]) + 1, 9)); //SOP COMMON^0008,0016^SOP Class UID^1^UI^N
  End;
  PopulateControlsWithDefaults;
  If PageControl1.PageCount > 0 Then TDicomEdit(TScrollBox(PageControl1.Pages[0]).Controls[0]).SetFocus;
End;

Function TfrmDICOMEntry.AllMandatoryFieldsPopulated: Boolean;
Var
  i, j: Integer;
  Ts: TTabSheet;
  SB: TScrollBox;
Begin
  Result := True;
  For i := 0 To PageControl1.ControlCount - 1 Do
  Begin
    Ts := TTabSheet(PageControl1.Controls[i]);
    SB := TScrollBox(Ts.Controls[0]);
    For j := 0 To SB.ControlCount - 1 Do
    Begin
      If SB.Controls[j] Is Tlabel Then Continue;
      If (SB.Controls[j].Tag = 1) Then
      Begin
        If (SB.Controls[j] Is TDicomEdit) And (Length(Trim(TDicomEdit(SB.Controls[j]).Text)) = 0) Then Result := False;
        If (SB.Controls[j] Is TComboBox) And (Length(Trim(TComboBox(SB.Controls[j]).Text)) = 0) Then Result := False;
        If (SB.Controls[j] Is TMemo) And (Length(Trim(TMemo(SB.Controls[j]).Text)) = 0) Then Result := False;
        If Result = False Then Exit;
      End; // if (SB.Controls[j].Tag = 1)
    End; //for j...
  End; // for i...
End;

Procedure TfrmDICOMEntry.EditChange(Sender: Tobject);
Begin
  btnSave.Enabled := AllMandatoryFieldsPopulated;
End;

Procedure TfrmDICOMEntry.FormCreate(Sender: Tobject);
Begin
  getformposition(self as Tform);{//CodeCR677}
  slData := Tstringlist.Create;
  slFields := Tstringlist.Create;
  slElements := Tstringlist.Create;
  ResultDataSet := rdsAll;   {//p117, defalut is to get all data}
End;

Procedure TfrmDICOMEntry.FormDestroy(Sender: Tobject);
Begin
  saveformposition(self as Tform);{//CodeCR677}
  slData.Free;
  slFields.Free;
  slElements.Free;
End;

Procedure TfrmDICOMEntry.AddSystemGenValsToResultSet;
Begin
  //SOP COMMON MODULE
  If slElements.Indexof('0008,0012') > -1 Then slData.Add('0008,0012' + ' ' + 'Instance Creation Date=' + Get_Instance_Creation_Date(ImageFileName));
  If slElements.Indexof('0008,0013') > -1 Then slData.Add('0008,0013' + ' ' + 'Instance Creation Time=' + Get_Instance_Creation_Time(ImageFileName));
  If slElements.Indexof('0008,0016') > -1 Then slData.Add('0008,0016' + ' ' + 'SOP Class UID=' + Get_SOP_Class_UID(SOP));
  //If slElements.Indexof('0008,0018') > -1 Then slData.Add('0008,0018' + ' ' + 'SOP Instance UID=' + Get_SOP_Instance_UID(StudyUID, SeriesNum, ImageCTR));
  If slElements.Indexof('0008,0018') > -1 Then slData.Add('0008,0018' + ' ' + 'SOP Instance UID=' + TRCSOPInstanceUID);
  //PATIENT MODULE
  If slElements.Indexof('0010,0010') > -1 Then slData.Add('0010,0010' + ' ' + 'Patients Name=' + Get_Patients_Name(Patient));
  If slElements.Indexof('0010,0020') > -1 Then slData.Add('0010,0020' + ' ' + 'Patient ID=' + Get_Patient_ID(Patient));
  If slElements.Indexof('0010,0030') > -1 Then slData.Add('0010,0030' + ' ' + 'Patients Birth Date=' + Get_Patients_Birth_Date(Patient, Broker));
  If slElements.Indexof('0010,0040') > -1 Then slData.Add('0010,0040' + ' ' + 'Patients Sex=' + Get_Patients_Sex(Patient));
  If slElements.Indexof('0010,1000') > -1 Then slData.Add('0010,1000' + ' ' + 'Other Patient IDs=' + Get_Other_Patient_IDs(Patient, Broker));
  //GENERAL STUDY MODULE
  If slElements.Indexof('0008,0020') > -1 Then slData.Add('0008,0020' + ' ' + 'Study Date=' + Get_Study_Date(ConsultStr));
  If slElements.Indexof('0008,0030') > -1 Then slData.Add('0008,0030' + ' ' + 'Study Time=' + Get_Study_Time(ConsultStr));
  If slElements.Indexof('0008,0050') > -1 Then slData.Add('0008,0050' + ' ' + 'Accession Number=' + Get_Accession_Number(ConsultStr));
  If slElements.Indexof('0008,0090') > -1 Then slData.Add('0008,0090' + ' ' + 'Referring Physicians Name=' + Get_Referring_Physicians_Name(ConsultStr));
  If slElements.Indexof('0020,000D') > -1 Then slData.Add('0020,000D' + ' ' + 'Study Instance UID=' + StudyUID);
  If slElements.Indexof('0020,0010') > -1 Then slData.Add('0020,0010' + ' ' + 'Study ID=' + Get_Study_ID(ConsultStr));
  If slElements.Indexof('0008,1030') > -1 Then slData.Add('0008,1030' + ' ' + 'Study Description=' + self.Description);
  //GENERAL SERIES MODULE
  If slElements.Indexof('0008,0021') > -1 Then slData.Add('0008,0021' + ' ' + 'Series Date=' + Get_Series_Date);
  If slElements.Indexof('0008,0031') > -1 Then slData.Add('0008,0031' + ' ' + 'Series Time=' + Get_Series_Time);
  If slElements.Indexof('0008,1070') > -1 Then slData.Add('0008,1070' + ' ' + 'Operators Name=' + StringReplace(UserName, ',', '^', [RfReplaceAll]));
  //If slElements.Indexof('0020,000E') > -1 Then slData.Add('0020,000E' + ' ' + 'Series Instance UID=' + StudyUID + '.' + SeriesNum);
  If slElements.Indexof('0020,000E') > -1 Then slData.Add('0020,000E' + ' ' + 'Series Instance UID=' + TRCSeriesUID);
  //If slElements.Indexof('0020,0011') > -1 Then slData.Add('0020,0011' + ' ' + 'Series Number=' + trim(copy(SeriesNum, 5, 10)));
  If slElements.Indexof('0020,0011') > -1 Then slData.Add('0020,0011' + ' ' + 'Series Number=' + SeriesNum);
  If slElements.Indexof('0020,0013') > -1 Then slData.Add('0020,0013' + ' ' + 'Instance Number=' + Inttostr(ImageCTR));
  If slElements.Indexof('0008,0060') > -1 Then slData.Add('0008,0060' + ' ' + 'Modality=' + Get_Modality(SOP));
  //GENERAL EQUIPTMENT MODULE
  If slElements.Indexof('0008,0070') > -1 Then slData.Add('0008,0070' + ' ' + 'Manufacturer=' + Get_Manufacturer);
  If slElements.Indexof('0008,0080') > -1 Then slData.Add('0008,0080' + ' ' + 'Institution Name=' + Get_Institution_Name);
  If slElements.Indexof('0008,1010') > -1 Then slData.Add('0008,1010' + ' ' + 'Station Name=' + Get_Station_Name);
  If slElements.Indexof('0008,1090') > -1 Then slData.Add('0008,1090' + ' ' + 'Manufacturers Model Name=' + Get_Manufacturers_Model_Name);
  If slElements.Indexof('0018,1020') > -1 Then slData.Add('0018,1020' + ' ' + 'Software Version(s)=' + Get_Software_Version);
  //ACQUISITION CONTEXT MODULE
  If slElements.Indexof('0040,0556') > -1 Then slData.Add('0040,0556' + ' ' + 'Acquisition Context Description=' + Get_Acquisition_Context_Description(SOP));
  If slElements.Indexof('0040,0555') > -1 Then slData.Add('0040,0555' + ' ' + 'Acquisition Context Sequence=' + Get_Acquisition_Context_Sequence);
  //GENERAL IMAGE MODULE
  If slElements.Indexof('0008,0022') > -1 Then slData.Add('0008,0022' + ' ' + 'Acquisition Date=' + Get_Acquisition_Date(ImageFileName));
  If slElements.Indexof('0008,0032') > -1 Then slData.Add('0008,0032' + ' ' + 'Acquisition Time=' + Get_Acquisition_Time(ImageFileName));
  If slElements.Indexof('0020,0020') > -1 Then slData.Add('0020,0020' + ' ' + 'Patient Orientation=' + GetPatientOrientation(SOP));

  //IMAGE PIXEL MODULE
{ TODO -o129 : get the data for next two lines from IGPage}
  //p129 todo If slElements.Indexof('0028,0010') > -1 Then slData.Add('0028,0010' + ' ' + 'Rows=' + Get_Rows(GEAR));
  //p129 todo If slElements.Indexof('0028,0011') > -1 Then slData.Add('0028,0011' + ' ' + 'Columns=' + Get_Columns(GEAR));

{/ P122 T7 - JK 10/19/2011 - CR 889 - Bill Peterson determined that P106 should never have had the 0028,0030 tag in the header.
   When P122 tested telederm DICOM images, the pixel spacing was causing textual annotation scaling errors. /}
//-  If slElements.Indexof('0028,0030') > -1 Then slData.Add('0028,0030' + ' ' + 'Pixel Spacing=' + Get_Pixel_Spacing(GEAR));
  If slElements.Indexof('0028,0034') > -1 Then slData.Add('0028,0034' + ' ' + 'Pixel Aspect Ratio=' + Get_Pixel_Aspect_Ratio);
  //VL IMAGE MODULE
  If slElements.Indexof('0008,0008') > -1 Then slData.Add('0008,0008' + ' ' + 'Image Type=' + Get_Image_Type);
  {Items commented out below automatically written to header by toolkit}
  //If slElements.Indexof('0028,0002') > -1 Then slData.Add('0028,0002' + ' ' + 'Samples Per Pixel=' + Get_Samples_Per_Pixel(GEAR));
  //If slElements.Indexof('0028,0004') > -1 Then slData.Add('0028,0004' + ' ' + 'Photometric Interpretation=' + Get_Photometric_Interpretation(GEAR));
  If slElements.Indexof('0028,0006') > -1 Then slData.Add('0028,0006' + ' ' + 'Planar Configuration=' + Get_Planar_Configuration);
  {Items commented out below automatically written to header by toolkit}
  //If slElements.Indexof('0028,0100') > -1 Then slData.Add('0028,0100' + ' ' + 'Bits Allocated=' + Get_Bits_Allocated(GEAR));
  //If slElements.Indexof('0028,0101') > -1 Then slData.Add('0028,0101' + ' ' + 'Bits Stored=' + Get_Bits_Stored(GEAR));
  //If slElements.Indexof('0028,0102') > -1 Then slData.Add('0028,0102' + ' ' + 'High Bit=' + Get_High_Bit(GEAR));

{ TODO -o129 : get the data for next two lines from IGPage}
//p129 todo   If slElements.Indexof('0028,0103') > -1 Then slData.Add('0028,0103' + ' ' + 'Pixel Representation=' + Get_Pixel_Representation(GEAR));
//p129 todo   If slElements.Indexof('0028,2110') > -1 Then slData.Add('0028,2110' + ' ' + 'Lossy Image Compression=' + Get_Lossy_Image_Compression(GEAR));


  //Group 2 elements
  slData.Add('0002,0002' + ' ' + 'Media Storage SOP Class UID=' + Get_SOP_Class_UID(SOP));
  //slData.Add('0002,0003' + ' ' + 'Media Storage SOP Instance UID=' + Get_SOP_Instance_UID(StudyUID, SeriesNum, ImageCTR));
  slData.Add('0002,0003' + ' ' + 'Media Storage SOP Instance UID=' + TRCSOPInstanceUID);
  slData.Add('0002,0012' + ' ' + 'Implementation Class UID=' + '1.2.840.113754.2.1.3.0');
  slData.Add('0002,0001' + ' ' + 'File Meta Information Version=' + '0001');

End;

Procedure DisplayDICOMFields(Sl: Tstringlist);
Var
  frm: TForm;
  Memo: TMemo;
  i: Integer;
Begin
  frm := TForm.Create(Nil);
  Memo := TMemo.Create(Nil);
  Try
    frm.Position := poScreenCenter;
    frm.caption := 'DICOM Fields';
    //gek frm.Width := Round(Screen.Width / 3);
    frm.Width :=  600; {/p117 gek keep form small first time, then it'll open to same size}
    frm.Height := Round(Screen.Height / 1.25);
    frm.InsertControl(Memo);
    Memo.Align := alClient;
    Memo.ReadOnly := True;
    Memo.ScrollBars := SsBoth;
    For i := 0 To Sl.Count - 1 Do
      Memo.Lines.Add(Sl.Strings[i]);
    frm.Showmodal;
  Finally
    Memo.Free;
    frm.Free;
  End;
End;

{/p117 modification to call this function for just User Values or All }
    {ResultDataSet will be equal to rdsUser or rdsAll.
     If only Generated values wanted, then AddSystemGenValsToResultSet is called
     independently from this}
Procedure TfrmDICOMEntry.PopStringListWithValues;
Var
  i, j: Integer;
  Ts: TTabSheet;
  SB: TScrollBox;
Begin
  slData.Clear;
  {/p117 check the ResultDataSet to see what data is wanted}
  if (ResultDataSet = rdsall) or (ResultDataSet = rdsUser)  then
   begin
  For i := 0 To PageControl1.ControlCount - 1 Do
  Begin
    Ts := TTabSheet(PageControl1.Controls[i]);
    SB := TScrollBox(Ts.Controls[0]);
    For j := 0 To SB.ControlCount - 1 Do
    Begin
      If SB.Controls[j] Is TDicomEdit Then slData.Add(TDicomEdit(SB.Controls[j]).BldPairedStr);
      If SB.Controls[j] Is TComboBox Then slData.Add(SB.Controls[j].Hint + ' ' + TComboBox(SB.Controls[j]).Name + '=' + TComboBox(SB.Controls[j]).Text);
      If SB.Controls[j] Is TMemo Then slData.Add(SB.Controls[j].Hint + ' ' + TMemo(SB.Controls[j]).Name + '=' + TMemo(SB.Controls[j]).Text);
      //last minute fix for laterality BB 8/19/10
      if SB.Controls[j].Hint = '0020,0060' then slData.Strings[slData.Count - 1] :=
        copy(slData.Strings[slData.Count - 1], 1, pos('=', slData.Strings[slData.Count - 1]) + 1);
    End;
  End;
  end;

 {/p117 gek : get sytem genreated values - add to return all dicom data}
  if (ResultDataSet = rdsall)
      then  AddSystemGenValsToResultSet;
End;

Procedure TfrmDICOMEntry.btnSaveClick(Sender: Tobject);
Var
  i, j: Integer;
  Ts: TTabSheet;
  SB: TScrollBox;
Begin
  PopStringListWithValues;
  PassDefaultsToMainForm;
End;

Function TfrmDICOMEntry.GetDefaultText(sElement: String): String;
Var
  i, iPos: Integer;
Begin
  Result := '';
  For i := 0 To slDefaults.Count - 1 Do
  Begin
    If Copy(slDefaults.Strings[i], 1, 9) = sElement Then
    Begin
      iPos := Pos('=', slDefaults.Strings[i]);
      Result := Copy(slDefaults.Strings[i], iPos + 1, Length(slDefaults.Strings[i]) - iPos);
      Exit;
    End;
  End;
End;

Procedure TfrmDICOMEntry.PopulateControlsWithDefaults;
Var
  i, j: Integer;
  Ts: TTabSheet;
  SB: TScrollBox;
Begin
  For i := 0 To PageControl1.PageCount - 1 Do
  Begin
    Ts := TTabSheet(PageControl1.Pages[i]);
    SB := TScrollBox(Ts.Controls[0]);
    For j := 0 To SB.ControlCount - 1 Do
    Begin
      If (SB.Controls[j] Is TDicomEdit) Then TDicomEdit(SB.Controls[j]).Text := GetDefaultText(TDicomEdit(SB.Controls[j]).Hint);
      If (SB.Controls[j] Is TComboBox) Then
      Begin
        TComboBox(SB.Controls[j]).Text := GetDefaultText(TComboBox(SB.Controls[j]).Hint);
        TComboBox(SB.Controls[j]).ItemIndex := TComboBox(SB.Controls[j]).Items.Indexof(TComboBox(SB.Controls[j]).Text);
      End;
      If (SB.Controls[j] Is TMemo) Then TMemo(SB.Controls[j]).Text := GetDefaultText(TMemo(SB.Controls[j]).Hint);
    End; //for j...
  End; // for i...
End;

Procedure TfrmDICOMEntry.PassDefaultsToMainForm;
Var
  i, j: Integer;
  Ts: TTabSheet;
  SB: TScrollBox;
Begin
  slDefaults.Clear;
  For i := 0 To PageControl1.ControlCount - 1 Do
  Begin
    Ts := TTabSheet(PageControl1.Controls[i]);
    SB := TScrollBox(Ts.Controls[0]);
    For j := 0 To SB.ControlCount - 1 Do
    Begin
      If (SB.Controls[j] Is TDicomEdit) Then slDefaults.Add(TDicomEdit(SB.Controls[j]).BldPairedStr);
      If (SB.Controls[j] Is TComboBox) Then slDefaults.Add(SB.Controls[j].Hint + ' ' + TComboBox(SB.Controls[j]).Name + '=' + TComboBox(SB.Controls[j]).Text);
      If (SB.Controls[j] Is TMemo) Then slDefaults.Add(SB.Controls[j].Hint + ' ' + TMemo(SB.Controls[j]).Name + '=' + TMemo(SB.Controls[j]).Text);
    End; //for j...
  End; // for i...
End;

Procedure TfrmDICOMEntry.btnShowClick(Sender: Tobject);
Begin
  PopStringListWithValues;
  DisplayDICOMFields(slData);
End;

End.
