Unit FmagPatVisits;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging : Select a Patient Vist dialog. (for CP captures.)
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
  //cMagLVutils,
  cMagPat,
  ComCtrls,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  Controls,
  cMagLVutils ,
  imaginterfaces
  ;

//Uses Vetted 20090929:maggut1, Dialogs, Graphics, SysUtils, Messages, magpositions, umagutils, magbroker, Controls, Windows

Type
  TPatVisitsform = Class(TForm)
    PnlVisits: Tpanel;
    Label1: Tlabel;
    LblSelReq: Tlabel;
    LblPatName2: Tlabel;
    LvVisitsUtils: TMagLVutils;
    PopupMenu1: TPopupMenu;
    RefreshVisitList1: TMenuItem;
    Label3: Tlabel;
    EdtNewVisitDate: TEdit;
    Label2: Tlabel;
    LvVisits: TListView;
    btnOkVisits: TBitBtn;
    btnCancelVisits: TBitBtn;
    StatusBar1: TStatusBar;
    Procedure LvVisitsCompare(Sender: Tobject; Item1, Item2: TListItem;
      Data: Integer; Var Compare: Integer);
    Procedure LvVisitsColumnClick(Sender: Tobject; Column: TListColumn);
    Procedure RefreshVisitList1Click(Sender: Tobject);
    Procedure EdtNewVisitDateKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure EdtNewVisitDateExit(Sender: Tobject);
    Procedure LvVisitsDblClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure LvVisitsChange(Sender: Tobject; Item: TListItem;
      Change: TItemChange);
    Procedure LvVisitsKeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
  Private
    FDFN: String;
    FintDateTime: String;
    Function GetVisitString: String;
    Function ConvertDateTime: Boolean;
    Procedure ClearNewVisitDateTime;
    Procedure WinMsg(s: String);

    { Private declarations }
  Public
    Procedure ClearSelection;
    Procedure InitializePatient(MagPat: TMag4Pat);
    Function Selectvisit(Var Visit: String): Boolean;
    Procedure GetVisits;
    { Public declarations }
  End;

Var
  PatVisitsform: TPatVisitsform;

Implementation

Uses
  MagBroker,
  UMagDefinitions,
  Magpositions,
  Umagutils8,
  Windows
  ;

{$R *.DFM}

Procedure TPatVisitsform.ClearNewVisitDateTime;
Begin
  FintDateTime := '';
  EdtNewVisitDate.Text := '';
End;

Function TPatVisitsform.Selectvisit(Var Visit: String): Boolean;
Begin
  PatVisitsform.Showmodal;
  If PatVisitsform.ModalResult = MrOK Then
  Begin
    Result := True;
    Visit := GetVisitString;
    If (Visit = '') Then Result := False;
  End
  Else
  Begin
    Result := False;
  End;
End;

Function TPatVisitsform.GetVisitString: String;
Var
  Li: TListItem;
Begin
  Li := LvVisits.Selected;
  If ((Li = Nil) And (FintDateTime = '')) Then Result := '';
  If (Li <> Nil) Then
  Begin
    Result := TMagLVData(Li.Data).Data;
  End
  Else
    Result := FintDateTime;
End;

Procedure TPatVisitsform.LvVisitsCompare(Sender: Tobject; Item1,
  Item2: TListItem; Data: Integer; Var Compare: Integer);
Begin
  LvVisitsUtils.DoCompare(Sender, Item1, Item2, Data, Compare);
End;

Procedure TPatVisitsform.LvVisitsColumnClick(Sender: Tobject; Column: TListColumn);
Begin
  LvVisitsUtils.DoColumnSort(Sender, Column);
End;

Procedure TPatVisitsform.RefreshVisitList1Click(Sender: Tobject);
Begin
  GetVisits;
End;

Procedure TPatVisitsform.GetVisits;
Var
  t: TStrings;
Begin
  WinMsg('');
  t := Tstringlist.Create;
  Try
    RPGetVisitListForReq(FDFN, t);
    btnOkVisits.Enabled := False;
    If (MagPiece(t[0], '^', 1) = '0') Then
    Begin
      LvVisitsUtils.ClearItems;
      WinMsg(MagPiece(t[0], '^', 2) + '  ' + LblPatName2.caption);
    End
    Else
      LvVisitsUtils.LoadListFromStrings(t);
  Finally
    t.Free;
  End;
End;

Procedure TPatVisitsform.InitializePatient(MagPat: TMag4Pat);
Begin
  FDFN := MagPat.M_DFN;
End;

Procedure TPatVisitsform.EdtNewVisitDateKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  //edtNewVisitDate
  If (Key <> VK_Return) Then
  Begin
    btnOkVisits.Enabled := False;
    LvVisits.Selected := Nil;
    Exit;
  End;
  If EdtNewVisitDate.Text = '' Then
  Begin
    FintDateTime := '';
    Exit;
  End;
  If ConvertDateTime Then
  Begin
    btnOkVisits.Enabled := True;
    btnOkVisits.SetFocus;
  End;

End;

Function TPatVisitsform.ConvertDateTime: Boolean;
Var
  Xmsg, ResDateTime: String;
Begin
  Result := False;
  //edtNewVisitDate
  If EdtNewVisitDate.Text = '' Then Exit;
  If RPFileManDate(Xmsg, EdtNewVisitDate.Text, ResDateTime) Then
  Begin
    Result := True;
    LvVisits.Selected := Nil;
    EdtNewVisitDate.Text := MagPiece(ResDateTime, '^', 1);
    FintDateTime := MagPiece(ResDateTime, '^', 2);
  End
  Else
  Begin
    MagAppMsg('', Xmsg); 
    ClearNewVisitDateTime;
  End;
End;

Procedure TPatVisitsform.ClearSelection;
Begin
  If Not Application.Terminated Then
  Begin
    LvVisits.Selected := Nil;
    ClearNewVisitDateTime;
    btnOkVisits.Enabled := False;
  End;
End;

Procedure TPatVisitsform.EdtNewVisitDateExit(Sender: Tobject);
Var
  FintDateTime: String;
Begin
  //edtNewVisitDate
  If EdtNewVisitDate.Text = '' Then
  Begin
    FintDateTime := '';
    Exit;
  End;
  If Not EdtNewVisitDate.Modified Then Exit;
  btnOkVisits.Enabled := ConvertDateTime;
  If btnOkVisits.Enabled Then btnOkVisits.SetFocus;
End;

Procedure TPatVisitsform.LvVisitsDblClick(Sender: Tobject);
Begin
  If (LvVisits.Selected <> Nil) Then ModalResult := MrOK;
End;

Procedure TPatVisitsform.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
End;

Procedure TPatVisitsform.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

Procedure TPatVisitsform.LvVisitsChange(Sender: Tobject; Item: TListItem;
  Change: TItemChange);
Begin
  ClearNewVisitDateTime;
  btnOkVisits.Enabled := (LvVisits.Selected <> Nil);
End;

Procedure TPatVisitsform.LvVisitsKeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If ((Key = VK_Return) And (LvVisits.Selected <> Nil)) Then ModalResult := MrOK;
End;

Procedure TPatVisitsform.WinMsg(s: String);
Begin
  StatusBar1.Panels[0].Text := s;
End;

End.
