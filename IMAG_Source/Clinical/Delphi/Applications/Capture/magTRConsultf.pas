Unit magTRConsultf;
{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 8/12/2009
Site Name: Silver Spring, OIFO
Developers: Richard Maley
Description: Consult Selection window.
Note:
}
(*
;; +---------------------------------------------------------------------------------------------------+
;; Property of the US Government.
;; No permission to copy or redistribute this software is given.
;; Use of unreleased versions of this software requires the user
;;  to execute a written test agreement with the VistA Imaging
;;  Development Office of the Department of Veterans Affairs,
;;  telephone (301) 734-0100.
;;
;; The Food and Drug Administration classifies this software as
;; a medical device.  As such, it may not be changed
;; in any way.  Modifications to this software may result in an
;; adulterated medical device under 21CFR820, the use of which
;; is considered to be a violation of US Federal Statutes.
;; +---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Buttons,
  Classes,
  cMagLVutils,
  cMagPat,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls   ,
  imaginterfaces
  ;

Type
  TmagTRConsult = Class(TForm)
    btnCancel: TBitBtn;
    btnOKCP: TBitBtn;
    Exit1: TMenuItem;
    File1: TMenuItem;
    LblPatName: Tlabel;
    LblRequests: Tlabel;
    LvRequests: TListView;
    LvRequestsutils: TMagLVutils;
    MainMenu1: TMainMenu;
    Options1: TMenuItem;
    Pnlhidden: Tpanel;
    RefreshRequests1: TMenuItem;
    ResizeGrid1: TMenuItem;
    StatusBar1: TStatusBar;
    Procedure btnOKCPClick(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure LvRequestsChange(Sender: Tobject; Item: TListItem; Change: TItemChange);
    Procedure LvRequestsColumnClick(Sender: Tobject; Column: TListColumn);
    Procedure LvRequestsCompare(Sender: Tobject; Item1, Item2: TListItem; Data: Integer; Var Compare: Integer);
    procedure lvRequestsDblClick(Sender: TObject);//p106 rlm 20101124 Fix Garrett's "Double click needed in Consult Selection"
    Procedure RefreshRequests1Click(Sender: Tobject);
    Procedure ResizeGrid1Click(Sender: Tobject);
  Private
    Function GetConsultPhysician: String;
    Function GetConsultTime: String;
  Protected
    FColWidths: Array[0..4] Of Integer;
    Fcomplete: String;
    FConsultSelected: Boolean;
    FData: Tstringlist;
    FDataString: String;
    FDebug: Boolean;
    FDFN: String;
    FMagpat: TMag4Pat;
    FPatient: String;
    FPhysician: String;
    FRawData: String;
    FReqDate: String;
    FReqTime: String;
    FReqIEN: String;
    FReqProcedure: String;
    FReqService: String;
    FSuccess: Boolean;
    FVstring: String;
    Function GetColWidthsTotal(): Integer;
    Function GetConsultDate: String;
    Function GetConsultIEN: String;
    Function GetConsultProcedure: String;
    Function GetConsultService: String;
    Function GetData: Tstringlist;
    Function GetDebug: Boolean;
    Function GetNumberOfConsults: Integer;
    Function GetPatient: TMag4Pat;
    Function NumberOfRequests(): Integer;
    Procedure AdjustColWidths();
    Procedure ClearComplete;
    Procedure ClearRequests;
    Procedure ClearRequestSelection;
    Procedure ClearWinMsg;
    Procedure GetConsultNumber;
    Procedure GetConsultRequests;
    Procedure InitializePatient(VMagPat: TMag4Pat);
    Procedure PurgeCompletedConsults();
    Procedure SetDebug(Const Value: Boolean);
    Procedure SetPatient(Const Value: TMag4Pat);
    Procedure SetPatientName(XMagPat: TMag4Pat);
    Procedure TryToEnabledOK;
    Procedure WinMsg(s: String);
  Public
    Procedure ClearAll;
  Published
    Property ConsultDate: String Read GetConsultDate;
    Property ConsultTime: String Read GetConsultTime;
    Property ConsultIEN: String Read GetConsultIEN;
    Property ConsultNumber: String Read FReqIEN Write FReqIEN;
    Property ConsultProcedure: String Read GetConsultProcedure;
    Property ConsultService: String Read GetConsultService;
    Property Physician: String Read GetConsultPhysician;
    Property Data: Tstringlist Read GetData;
    Property DataString: String Read FDataString;
    Property Debug: Boolean Read GetDebug Write SetDebug;
    Property NumberOfConsults: Integer Read GetNumberOfConsults;
    Property Patient: TMag4Pat Read GetPatient Write SetPatient;
    Property Success: Boolean Read FSuccess;
  End;

Var
  magTRConsult: TmagTRConsult;
Function TRConsultExecute(Pat: TMag4Pat; Out TRConsultDataString, TRConsultDate, TRConsultService: String): Boolean;

Implementation

Uses
  Dialogs,
  MagBroker,
  Magpositions,
  Math,
  Umagutils8,
    ImagDMinterface, //DmSingle,
  SysUtils;

{$R *.DFM}

Procedure TmagTRConsult.SetPatientName(XMagPat: TMag4Pat);
Begin
  If (XMagPat.M_DFN <> FDFN) Then
  Begin
    ClearAll;
    LblPatName.caption := XMagPat.M_NameDisplay;
    FPatient := XMagPat.M_NameDisplay;
    InitializePatient(XMagPat);
    GetConsultRequests;
  End
  Else
  Begin
    ClearRequestSelection;
    ClearComplete;
    ClearWinMsg;
    If (NumberOfRequests = 0) Then
    Begin
      MagAppMsg('D', 'There are no Consults for Patient : ' + XMagPat.M_NameDisplay);
    End;
  End;
End;

Procedure TmagTRConsult.InitializePatient(VMagPat: TMag4Pat);
Begin
  FDFN := VMagPat.M_DFN;
  FMagpat := VMagPat;
End;

Procedure TmagTRConsult.ClearAll;
Begin
  LvRequests.Clear();
  FConsultSelected := False;
  //FReqNumNotes     := '';
  FReqProcedure := '';
  ClearComplete;
  ClearRequests;
  ClearWinMsg;
End;

Procedure TmagTRConsult.ClearComplete;
Begin
  Fcomplete := '-1';
End;

Procedure TmagTRConsult.ClearRequests;
Begin
  ClearWinMsg;
  LvRequestsutils.ClearItems;
  FReqIEN := '';
  FReqDate := '';
  FReqTime := '';
  FPhysician := '';
  FReqService := '';
  FDataString := '';
End;

Procedure TmagTRConsult.ClearWinMsg;
Begin
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';
End;

Procedure TmagTRConsult.ClearRequestSelection;
Begin
  LvRequests.Selected := Nil;
  FPhysician := '';
  FReqDate := '';
  FReqTime := '';
  FReqIEN := '';
  FReqService := '';
End;

Procedure TmagTRConsult.btnOKCPClick(Sender: Tobject);
Begin
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Update;
  If Fcomplete = '-1' Then
  Begin
    WinMsg('Select a Consult.');
  End
  Else
    If Trim(ConsultNumber) <> '' Then
    Begin
      FSuccess := True;
      Try
        ModalResult := MrOK;
      Except
      End;
    End;
End;

Procedure TmagTRConsult.GetConsultNumber;
Var
  Li: TListItem;
Begin
  Li := LvRequests.Selected;
  If (Li <> Nil) Then
  Begin
    FReqIEN := Li.caption;
    FReqDate := Li.SubItems[0];
    FReqTime := Li.SubItems[1];
    FReqService := Li.SubItems[2];
    FReqProcedure := Li.SubItems[3];
    FPhysician := Li.SubItems[4];
    FDataString :=
      FReqIEN + '^' +
      FReqDate + '^' +
      FReqTime + '^' +
      FReqService + '^' +
      FReqProcedure + '^' +
      FPhysician + '|' +
      FReqIEN;
    btnOKCP.Enabled := True;
  End
  Else
  Begin
    FReqDate := '';
    FReqTime := '';
    FReqIEN := '';
    FReqProcedure := '';
    FReqService := '';
    FPhysician := '';
    FDataString := '';
    btnOKCP.Enabled := False;
  End;
End;

Procedure TmagTRConsult.WinMsg(s: String);
Begin
  StatusBar1.Panels[1].Text := s;
End;

Procedure TmagTRConsult.Exit1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TmagTRConsult.LvRequestsColumnClick(Sender: Tobject;
  Column: TListColumn);
Begin
  LvRequestsutils.DoColumnSort(Sender, Column);
End;

Procedure TmagTRConsult.LvRequestsCompare(Sender: Tobject; Item1,
  Item2: TListItem; Data: Integer; Var Compare: Integer);
Begin
  LvRequestsutils.DoCompare(Sender, Item1, Item2, Data, Compare);
End;

procedure TmagTRConsult.lvRequestsDblClick(Sender: TObject);
begin
  btnOKCPClick(Sender); //p106 rlm 20101117 Fix Garrett's "Double click needed in Consult Selection"
end;

Procedure TmagTRConsult.RefreshRequests1Click(Sender: Tobject);
Begin
  GetConsultRequests;
End;

Procedure TmagTRConsult.ResizeGrid1Click(Sender: Tobject);
Begin
  LvRequestsutils.ResizeColumns;
End;

Procedure TmagTRConsult.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
  FreeAndNil(FData);
End;

Procedure TmagTRConsult.LvRequestsChange(Sender: Tobject; Item: TListItem;
  Change: TItemChange);
Begin
  GetConsultNumber;
  WinMsg('');
  TryToEnabledOK;
  If Trim(FReqIEN) <> '' Then Fcomplete := '1';
End;

Procedure TmagTRConsult.TryToEnabledOK;
Begin
  btnOKCP.Enabled := (LvRequests.Selected <> Nil);
End;

Function TmagTRConsult.NumberOfRequests: Integer;
Begin
  Result := LvRequests.Items.Count;
End;

Procedure TmagTRConsult.FormShow(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
End;

Procedure TmagTRConsult.FormCreate(Sender: Tobject);
Begin
  FRawData := '';
  FColWidths[0] := 30;
  FColWidths[1] := 30;
  FColWidths[2] := 30;
  FColWidths[3] := 30;
  FColWidths[4] := 30;
  FDebug := False;
  FReqDate := '';
  FReqTime := '';
  FReqIEN := '';
  FReqProcedure := '';
  FReqService := '';
  FPhysician := '';
  FConsultSelected := False;
  FData := Tstringlist.Create();
End;

Procedure TmagTRConsult.GetConsultRequests;
Var
  Rstat: Boolean;
  Rmsg: String;
Begin
  ClearWinMsg;
  idmodobj.GetMagDBBroker1.RPTeleReaderConsultListRequests(Rstat, Rmsg, FData, FDFN);
  FRawData := FData.Text;
  If (Not Rstat) Or (FData.Count < 2) Then
  Begin
    //p106 rlm 20101118 Fix Garrett's "Title of Dialog box"
    MagAppMsg('d', 'There are no Consult Requests for this Patient');
    Exit;
  End;
  If Debug Then
    //p106 rlm 20101118 Fix Garrett's "Title of Dialog box"
    MagAppMsg('d', Data.Text);
  LvRequestsutils.LoadListFromStrings(FData);
  AdjustColWidths();
End;

Function TmagTRConsult.GetPatient: TMag4Pat;
Begin
  Result := FMagpat;
End;

Procedure TmagTRConsult.SetPatient(Const Value: TMag4Pat);
Begin
  FMagpat := Value;
  SetPatientName(FMagpat);
End;

Function TmagTRConsult.GetData: Tstringlist;
Begin
  Result := FData;
End;

Function TmagTRConsult.GetConsultDate: String;
Begin
  Result := FReqDate;
End;

Function TmagTRConsult.GetConsultIEN: String;
Begin
  Result := FReqIEN;
End;

Function TmagTRConsult.GetConsultProcedure: String;
Begin
  Result := FReqProcedure;
End;

Function TmagTRConsult.GetConsultService: String;
Begin
  Result := FReqService;
End;

Procedure TmagTRConsult.PurgeCompletedConsults;
Var
  i: Integer;
  SgTemp: String;
Begin

  If FData.Count > 0 Then
  Begin
    If Debug Then
    Begin
      //p106 rlm 20101118 Fix Garrett's "Title of Dialog box"
      MagAppMsg('d', FData.Text);
      //p106 rlm 20101118 Fix Garrett's "Title of Dialog box"
      MagAppMsg('d',MagPiece(FData[FData.Count - 1], '^', 4));
    End;
    For i := (FData.Count - 1) Downto 1 Do
    Begin
      SgTemp := MagPiece(FData[i], '^', 4);
      SgTemp := Uppercase(SgTemp);
      If SgTemp = 'COMPLETE' Then FData.Delete(i);
    End;
  End;
End;

Function TmagTRConsult.GetDebug: Boolean;
Begin
  Result := FDebug;
End;

Procedure TmagTRConsult.SetDebug(Const Value: Boolean);
Begin
  FDebug := Value;
End;
//RCA  CHANGED VAR parameter Pat:Tmag4Pat to normal, (non-var) parameter
Function TRConsultExecute(Pat: TMag4Pat; Out TRConsultDataString, TRConsultDate, TRConsultService: String): Boolean;
Var
  f: TmagTRConsult;
Begin
  Result := False;
  TRConsultDataString := '';
  TRConsultDate := '';
  TRConsultService := '';
  f := TmagTRConsult.Create(Nil);
  Try
    f.ClearAll;
    f.Patient := Pat;
    If (f.NumberOfConsults = 0) Then Exit;
    f.Showmodal;
    If f.ModalResult = MrOK Then
    Begin
      TRConsultDataString := f.DataString;
      TRConsultDate := f.ConsultDate;
      TRConsultService := f.ConsultService;
      Result := True;
    End;
  Finally
    FreeAndNil(f);
  End;
End;

Function TmagTRConsult.GetNumberOfConsults: Integer;
Begin
  Result := LvRequests.Items.Count;
End;

Procedure TmagTRConsult.AdjustColWidths;
Var
  i: Integer;
  inCol: Integer;
  inPos: Integer;
  inTot: Integer;
  inWidth: Integer;
  Lab: Tlabel;
  Lst: Tstringlist;
  sgNum: String;
  SgTemp: String;
Begin
  Lst := Tstringlist.Create();
  Lab := Tlabel.Create(Nil);
  Try
    sgNum := '125';
    Lab.Font.Assign(LvRequests.Font);
    Lst.SetText(PAnsiChar(FRawData));
    If Debug Then
      //p106 rlm 20101118 Fix Garrett's "Title of Dialog box"
      MagAppMsg(
        'd',
        Lst.Text);
    For i := 0 To Lst.Count - 1 Do
    Begin
      SgTemp := Lst[i];
      inPos := Pos('|', SgTemp);
      If inPos <> 0 Then
      Begin
        Lst[i] := Copy(SgTemp, 1, inPos - 1);
      End;
    End;
    For inCol := 0 To 4 Do
    Begin
      inWidth := 1;
      For i := 0 To Lst.Count - 1 Do
      Begin
        SgTemp := Lst[i];
        inPos := Pos('^', SgTemp);
        If inPos <> 0 Then
        Begin
          Lst[i] := Copy(SgTemp, inPos + 1, Length(SgTemp) - (inPos + 1) + 1);
          SgTemp := Copy(SgTemp, 1, inPos - 1);
        End;
        Lab.caption := SgTemp;
        Application.Processmessages();
        If Lab.Width > inWidth Then inWidth := Lab.Width;

      End;
      FColWidths[inCol] := (inWidth * Strtoint(sgNum)) Div 100;
      LvRequests.Column[inCol].Width := FColWidths[inCol];
    End;
    inTot := GetColWidthsTotal() + 34;
    If (inTot < Screen.Width) And (inTot > 400) Then Width := inTot;
    (*
    While True Do
    Begin
      If (MessageDlg('Do you want to try again?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) Then Break;
      sgNum:=InputBox('Enter Percent Change','Change Percent',sgNum);
      sgNum:=Trim(sgNum);
      sgNum:=StringReplace(sgNum,'%','',[rfReplaceAll]);
      If sgNum='' Then Break;
      If sgNum='100' Then Break;
      For inCol:=0 To 4 Do
      Begin
        lvRequests.Column[inCol].Width:=(FColWidths[inCol]*StrToInt(sgNum))div 100;
        Application.ProcessMessages();
      End;
    End;
    *)
  Finally
    FreeAndNil(Lst);
    FreeAndNil(lab);
  End;
End;

Function TmagTRConsult.GetColWidthsTotal: Integer;
Var
  i: Integer;
Begin
  Result := 0;
  For i := 0 To 4 Do
    Result := Result + FColWidths[i];
End;

Function TmagTRConsult.GetConsultPhysician: String;
Begin
  Result := FPhysician;
End;

Function TmagTRConsult.GetConsultTime: String;
Begin
  Result := FReqTime;
End;

End.
