Unit MagClinProcf;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Clinical Procedure Selection window.
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
  //cMagLVutils,
  cMagPat,
  UMagDefinitions,
  ComCtrls,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  Controls,
  Classes,
  cMagLVutils  ,
  Imaginterfaces
  ;

//Uses Vetted 20090929:maggut1, ToolWin, Dialogs, Graphics, SysUtils, Messages, Windows, magpositions, fMagPatVisits, umagutils, magbroker, Controls, Classes

Type
  TmagClinProc = Class(TForm)
    LblPatName: Tlabel;
    StatusBar1: TStatusBar;
    Pnlhidden: Tpanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    MSave: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Options1: TMenuItem;
    Help1: TMenuItem;
    LvRequestsutils: TMagLVutils;
    RefreshRequests1: TMenuItem;
    CancelVisitSelection1: TMenuItem;
    ResizeGrid1: TMenuItem;
    N2: TMenuItem;
    PreviewNote1: TMenuItem;
    Listnotes: TListBox;
    MnuclinProc: TMenuItem;
    LblRequests: Tlabel;
    LvRequests: TListView;
    btnOKCP: TBitBtn;
    btnCancel: TBitBtn;
    cboxCompleteRemoved: TCheckBox;
    RbCP0: TRadioButton;
    RbCP1: TRadioButton;
    RbCP2: TRadioButton;
    GroupBox1: TGroupBox;
    Procedure btnOKCPClick(Sender: Tobject);
    Procedure cboxCompleteRemovedClick(Sender: Tobject);
    Procedure Exit1Click(Sender: Tobject);
    Procedure LvRequestsColumnClick(Sender: Tobject; Column: TListColumn);
    Procedure LvRequestsCompare(Sender: Tobject; Item1, Item2: TListItem;
      Data: Integer; Var Compare: Integer);
    Procedure CancelVisitSelection1Click(Sender: Tobject);
    Procedure RefreshRequests1Click(Sender: Tobject);
    Procedure ResizeGrid1Click(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure LvRequestsChange(Sender: Tobject; Item: TListItem;
      Change: TItemChange);
    Procedure MnuclinProcClick(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure RbCP0Click(Sender: Tobject);
    Procedure RbCP1Click(Sender: Tobject);
    Procedure RbCP2Click(Sender: Tobject);
  Private
    FMagpat: TMag4Pat;
    FDFN: String;
    FConsIEN: String;
    FReqdesc: String;
    FReqDate: String;
    FVstring: String;
    Fcomplete: String;
    Procedure GetCPRequests;

    Function GetTIUDAFromListSelections: Boolean;
    Procedure GetConsultNumber;
    Procedure WinMsg(s: String);
    Procedure ClearWinMsg;

    Procedure ClearVisits;
    Procedure ClearNotes;
    Procedure ClearVisitSelection;
    Procedure ClearRequestSelection;
    Procedure ClearRequests;
    Procedure ClearComplete;
    Procedure ClearAll;
    Procedure InitializePatient(VMagPat: TMag4Pat);
    Procedure TryToEnabledOK;

    { Private declarations }
  Public

    DataString: String;
    Procedure SetPatientName(XMagPat: TMag4Pat);
    Function NumberOfRequests(): Integer;

  End;

Var
  MagClinProc: TmagClinProc;

Implementation

Uses
  FmagPatVisits,
  MagBroker,
  Magpositions,
  Umagutils8
  ;

{$R *.DFM}

Procedure TmagClinProc.SetPatientName(XMagPat: TMag4Pat);
Begin

  If (XMagPat.M_DFN <> FDFN) Then
  Begin
    ClearAll;
    LblPatName.caption := XMagPat.M_NameDisplay;
    PatVisitsform.LblPatName2.caption := XMagPat.M_NameDisplay;
    InitializePatient(XMagPat);
    GetCPRequests;
  End
  Else
  Begin
    ClearRequestSelection;
    ClearComplete;
    ClearWinMsg;
    If (NumberOfRequests = 0) Then
    Begin
      //maggmsgf.magmsg('D', 'There are no Clinical Procedure Requests for Patient : ' + xMagPat.M_NameDisplay, nilpanel);
      MagAppMsg('D', 'There are no Clinical Procedure Requests for Patient : ' + XMagPat.M_NameDisplay);
    End;
  End;
End;

Procedure TmagClinProc.InitializePatient(VMagPat: TMag4Pat);
Begin
  FDFN := VMagPat.M_DFN;
  FMagpat := VMagPat;
  PatVisitsform.InitializePatient(VMagPat);
End;

Procedure TmagClinProc.ClearAll;
Begin
  ClearComplete;
  ClearVisits;
  ClearRequests;
  ClearNotes;
  ClearWinMsg;
End;

Procedure TmagClinProc.ClearComplete;
Begin
  Fcomplete := '-1';
  //cboxComplete.checked := false;
//  rgrpProcFlag.ItemIndex := -1;
  RbCP0.Checked := False;
  RbCP1.Checked := False;
  RbCP2.Checked := False;
End;

Procedure TmagClinProc.ClearVisits;
Begin
  ClearWinMsg;
  PatVisitsform.LvVisitsUtils.ClearItems;
  PatVisitsform.ClearSelection;
  FVstring := '';
End;

Procedure TmagClinProc.ClearRequests;
Begin
  ClearWinMsg;
  LvRequestsutils.ClearItems;
  FConsIEN := '';
  FReqDate := '';
  FReqdesc := '';
  DataString := '';
End;

Procedure TmagClinProc.ClearNotes;
Begin
  ClearWinMsg;
  Listnotes.Clear;
End;

Procedure TmagClinProc.ClearWinMsg;
Begin
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Panels[1].Text := '';
End;

Procedure TmagClinProc.ClearRequestSelection;
Begin
  LvRequests.Selected := Nil;
  FConsIEN := '';
  FReqDate := '';
  FReqdesc := '';
End;

Procedure TmagClinProc.ClearVisitSelection;
Begin
  PatVisitsform.ClearSelection;
  FVstring := '';
End;

Procedure TmagClinProc.GetCPRequests;
Var
  t: TStrings;
Begin
  ClearWinMsg;
  t := Tstringlist.Create;
  Try
    RPGetClinProcReq(FDFN, t);
    If MagPiece(t[0], '^', 1) = '0' Then
    Begin
      //maggmsgf.magmsg('D', magpiece(t[0], '^', 2), nilpanel);
      MagAppMsg('D', MagPiece(t[0], '^', 2)); 
      Exit;
    End;
    LvRequestsutils.LoadListFromStrings(t);
    FConsIEN := '';
    FReqDate := '';
    FReqdesc := '';
  Finally
    t.Free;
  End;
End;

Procedure TmagClinProc.btnOKCPClick(Sender: Tobject);
Begin
  StatusBar1.Panels[0].Text := '';
  StatusBar1.Update;
  If Fcomplete = '-1' Then
  Begin
    WinMsg('Select a Procedure/Image status.');
  End
  Else
    If GetTIUDAFromListSelections Then ModalResult := MrOK;
End;

Function TmagClinProc.GetTIUDAFromListSelections: Boolean;
Var
  t: TStrings;
  Isconsent, Xvisit: String;
Begin
  ClearNotes;
  Result := False;
  t := Tstringlist.Create;
  Try
    // vstring is set to null on open.  vstring is only set
    //  if a user selects from the visit list.
         { DONE : How do I send the Complete Flag
Done.  The variable Fcomplete is set when user clicks on
radio button in the MagClinProc form.}
    If (FDFN = '') Then
    Begin
      WinMsg('Patient DFN is missing.');
      Exit;
    End;
    If (FConsIEN = '') Then
    Begin
      WinMsg('A Request has not been selected.');
      Exit;
    End;
    // This calls CP API in VISTA,
    // The data sent to CP API, and Result is tracked in Session File.
    RPGetTIUDAfromClinProcReq(FDFN, FConsIEN, FVstring, Fcomplete, t);
    If (t.Count = 0) Then
    Begin
      WinMsg('Error associating Request with Procedure');
      Exit;
    End;
    If (t[0] = '-1^No VString') Then
    Begin
      PatVisitsform.GetVisits;
      ClearNotes;
      If Not PatVisitsform.Selectvisit(Xvisit) Then Exit;
      //FOR testing  WE CAN COMMENT OUT THE NEXT LINE don't set this;
      FVstring := Xvisit;
      WinMsg('A Visit has been selected.');
      Exit;
    End
    Else
      If (MagPiece(t[0], '^', 1) = '-1') Then
      Begin
        WinMsg('Error ' + MagPiece(t[0], '^', 2));
        Exit;
      End;
    Result := True;
    If (RbCP0.Checked) Then
      Isconsent := '1'
    Else
      Isconsent := '0';
    //              TIUDA                     DESC
    //              Date       Consult #       Complete Flag     IsAConsentForm  ?
    DataString := MagPiece(t[0], '^', 1) + '^' + FReqdesc
      + '^' + FReqDate + '^' + FConsIEN + '^' + Fcomplete + '^' + Isconsent;
    Listnotes.Items.Assign(t);
    Listnotes.ItemIndex := 0;
    btnOKCP.Enabled := True;
    MSave.Enabled := True;
  Finally
    t.Free;
  End;
End;

Procedure TmagClinProc.GetConsultNumber;
Var
  Li: TListItem;
Begin
  Li := LvRequests.Selected;
  If (Li <> Nil) Then
  Begin
    FConsIEN := MagPiece((TMagLVData(Li.Data).Data), '^', 1);
    PatVisitsform.LblSelReq.caption := Li.caption + ' ' +
      Li.SubItems[0] + ' ' +
      Li.SubItems[1] + ' ' +
      Li.SubItems[2];
    FReqdesc := Li.SubItems[0];
    FReqDate := Li.caption;
    btnOKCP.Enabled := True;
    MSave.Enabled := True;
  End
  Else
  Begin
    PatVisitsform.LblSelReq.caption := '';
    DataString := '';
    FConsIEN := '';
    FReqdesc := '';
    FReqDate := '';
    btnOKCP.Enabled := False;
    MSave.Enabled := False;
  End;
End;

Procedure TmagClinProc.WinMsg(s: String);
Begin
  StatusBar1.Panels[1].Text := s;
End;

Procedure TmagClinProc.cboxCompleteRemovedClick(Sender: Tobject);
Begin
  // Status is sent to CPDOC^GMRCCP to change
  //  consult to status of 'pr'.
(* not used now, use radio group instead   CPMOD
if CboxComplete.checked
then Fcomplete := '2'
else Fcomplete := '0'; *)
End;

Procedure TmagClinProc.Exit1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TmagClinProc.LvRequestsColumnClick(Sender: Tobject;
  Column: TListColumn);
Begin
  LvRequestsutils.DoColumnSort(Sender, Column);
End;

Procedure TmagClinProc.LvRequestsCompare(Sender: Tobject; Item1,
  Item2: TListItem; Data: Integer; Var Compare: Integer);
Begin
  LvRequestsutils.DoCompare(Sender, Item1, Item2, Data, Compare);
End;

Procedure TmagClinProc.CancelVisitSelection1Click(Sender: Tobject);
Begin
  ClearVisitSelection;
End;

Procedure TmagClinProc.RefreshRequests1Click(Sender: Tobject);
Begin
  GetCPRequests;
End;

Procedure TmagClinProc.ResizeGrid1Click(Sender: Tobject);
Begin
  LvRequestsutils.ResizeColumns;
  PatVisitsform.LvVisitsUtils.ResizeColumns;
End;

Procedure TmagClinProc.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

Procedure TmagClinProc.LvRequestsChange(Sender: Tobject; Item: TListItem;
  Change: TItemChange);
Begin
  ClearNotes;
  ClearVisitSelection;
  GetConsultNumber;
  WinMsg('');
  TryToEnabledOK;
End;

Procedure TmagClinProc.TryToEnabledOK;
Begin
  btnOKCP.Enabled := ((LvRequests.Selected <> Nil) And (Fcomplete <> '-1'));
End;

Function TmagClinProc.NumberOfRequests: Integer;
Begin
  Result := LvRequests.Items.Count;
End;

Procedure TmagClinProc.MnuclinProcClick(Sender: Tobject);
Begin
  Application.HelpContext(10105);
End;

Procedure TmagClinProc.FormShow(Sender: Tobject);
Begin
  Fcomplete := '-1';
  RbCP0.Checked := False;
  RbCP1.Checked := False;
  RbCP2.Checked := False;

  GetFormPosition(Self As TForm);
End;

Procedure TmagClinProc.RbCP0Click(Sender: Tobject);
Begin
  //  Status is sent to CPDOC^GMRCCP to change
  //  A Status of '2' means change consult to status of 'pr'.  (pending results)
{
0) A consent form is being scanned and attached to this procedure.
1) This procedure will not be receiving a report or additional information from the instrument.
2) This procedure will be receiving a report or additional data from the instrument
}

  If RbCP0.Checked Then Fcomplete := '0';
  TryToEnabledOK;
End;

Procedure TmagClinProc.RbCP1Click(Sender: Tobject);
Begin
  //  Status is sent to CPDOC^GMRCCP to change
  //  A Status of '2' means change consult to status of 'pr'.  (pending results)
{
0) A consent form is being scanned and attached to this procedure.
1) This procedure will not be receiving a report or additional information from the instrument.
2) This procedure will be receiving a report or additional data from the instrument
}
  If RbCP1.Checked Then Fcomplete := '2';
  TryToEnabledOK;
End;

Procedure TmagClinProc.RbCP2Click(Sender: Tobject);
Begin
  //  Status is sent to CPDOC^GMRCCP to change
  //  A Status of '2' means change consult to status of 'pr'.  (pending results)
{
0) A consent form is being scanned and attached to this procedure.
1) This procedure will not be receiving a report or additional information from the instrument.
2) This procedure will be receiving a report or additional data from the instrument
}
  If RbCP2.Checked Then Fcomplete := '0';
  TryToEnabledOK;
End;

End.
