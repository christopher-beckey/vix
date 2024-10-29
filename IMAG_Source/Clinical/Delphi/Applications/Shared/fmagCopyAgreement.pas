Unit FmagCopyAgreement;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
  [==  unit fMagCopyAgreement;
   Description: Utiltity form.  Prompts User
     to select a reason for Copying or Printing an Image
     and enter an Electronic signature.
   Patch 93 :
     The Prompt for Esig may be removed or Conditionalized so all users don't need
     to enter an esig.  A decision by the HIMS has agreed that prompting a user for
     an Esig to print or copy is overdoing it, that the Kernel signon (access,verify)
     is enough for them.

     The window is just a Selection of a list, the list of items has always been hardcoded
     and a 'code' is sent back to the calling program.  It never had a connection
     to VistA to 'get... ' a list from VistA.  We'll keep it that way for now,
     we'll send the list to display, list will be a string list in the form
     code^text, and the selected code will be returned.
   ==]
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+

*)

Interface

Uses
  Buttons,
  Classes,
  Controls,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  UMagDefinitions
  ;

//Uses Vetted 20090929:CheckLst, sysutils, dialogs, ComCtrls, TabNotBk, Graphics, WinProcs, WinTypes, umagutils

Type
  TfrmCopyAgreement = Class(TForm)
    PnlAgree: Tpanel;
    btnOKAgree: TBitBtn;
    MemAgreement: TMemo;
    BitBtn1: TBitBtn;
    Panel1: Tpanel;
    LbHeader: Tlabel;
    LstReasons: TListBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    MnuExit: TMenuItem;
    N1: TMenuItem;
    Help1: TMenuItem;
    ImageDownloadAgreementHelp1: TMenuItem;
    MnuAgreement: TMenuItem;
    Pnlesig2: Tpanel;
    LbSelectedReason: Tlabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    Procedure btnOKClick(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure btnOKAgreeClick(Sender: Tobject);
    Procedure LstReasonsClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure MnuExitClick(Sender: Tobject);
    Procedure File1Click(Sender: Tobject);
    Procedure ImageDownloadAgreementHelp1Click(Sender: Tobject);
    Procedure MnuAgreementClick(Sender: Tobject);
  Private
    FReasonList: TStrings;
    FAlreadyView: Boolean;
    FLastReasonCode: String;

    Procedure GetEsigReason(Var Reason: String);
    { Private declarations }

  Public
        {  if result is True, esig and esigreason will be defined.}
    Function Execute(Var Esigreason: String): Boolean; Overload;
    Function Execute(Reasoncode: Integer; Var Esigreason: String): Boolean; Overload;
    Procedure SetReasonList(Reasonlist: TStrings);
    Procedure ShowTypesOfReasons(Reasoncode: TMagReasonsCodes);
  End;

Var
  FrmCopyAgreement: TfrmCopyAgreement;

Implementation
Uses
  Umagutils8
  ;

//Uses Vetted 20090929:cMagUtilsDB
{$R *.DFM}

    { This overloaded 'Execute' method :   First used in Patch 93,
    the Reason code will tell the form which list
         of reasons to display.  Print, Copy, Delete or Status, the var esigreason
         will return a 'code' as always.}
//p93

Function TfrmCopyAgreement.Execute(Reasoncode: Integer; Var Esigreason: String): Boolean;
Begin
  Result := False;
  If Not Doesformexist('frmCopyAgreement') Then
  Begin
    Application.CreateForm(TfrmCopyAgreement, FrmCopyAgreement);
    FrmCopyAgreement.LstReasons.ItemIndex := -1;
  End;
 { case reasoncode of

  end;  }
  Result := FrmCopyAgreement.Execute(Esigreason);

End;

Function TfrmCopyAgreement.Execute(Var Esigreason: String): Boolean;
Begin
  Result := False;
  If Not Doesformexist('frmCopyAgreement') Then
  Begin
    Application.CreateForm(TfrmCopyAgreement, FrmCopyAgreement);
    FrmCopyAgreement.LstReasons.ItemIndex := -1;
  End;
  With FrmCopyAgreement Do
  Begin
    Try
      Showmodal;
      If ModalResult = MrCancel Then Exit;
      GetEsigReason(Esigreason);
      Result := True;
    Finally
      ;
    End;
  End;

End;

Procedure TfrmCopyAgreement.btnOKClick(Sender: Tobject);
Begin
  ModalResult := MrOK;
End;

Procedure TfrmCopyAgreement.GetEsigReason(Var Reason: String);
Var
  Rsel: String;
  i: Integer;
Begin
//here change needed.  Return the selected Reason in IEN^Desc format.
  Reason := '';
  If Self.LstReasons.ItemIndex = -1 Then Exit;
  Rsel := LstReasons.Items[Self.LstReasons.ItemIndex];
  For i := 0 To Self.FReasonList.Count - 1 Do
    If MagPiece(FReasonList[i], '^', 2) = Rsel Then Reason := FReasonList[i];

(*  case lstReasons.itemindex of
    0: reason := 'A';
    1: reason := 'B';
    2: reason := 'C';
    3: reason := 'D';
    4: reason := 'E';
    5: reason := 'R';
  else reason := '?';
  end;  *)
End;

Procedure TfrmCopyAgreement.FormShow(Sender: Tobject);
Begin
  //p130t9 dmmn 2/13/13 - also check to see if the user has agree to the printing agreement
  // for the session yet
  If Not FAlreadyView or Not GSess.PhysicianAcknowledgement Then
  Begin
    PnlAgree.Visible := True;
    PnlAgree.BringToFront;
    FAlreadyView := True;
    if GSess.PhysicianAcknowledgement then
    lstReasons.SetFocus;  {/p117 set focus to list on open of window.  }
    Panel1.Visible := False;
    Exit;
  End;
  PnlAgree.Visible := False;
  Panel1.Visible := True;

  If LstReasons.ItemIndex = -1 Then
  Begin
    LstReasons.SetFocus;
    btnOK.Enabled := False;
  End
  Else
  Begin
    LstReasons.SetFocus;
    LstReasons.Selected[LstReasons.ItemIndex] := True;
    btnOK.Enabled := True;
  End;
End;

Procedure TfrmCopyAgreement.btnOKAgreeClick(Sender: Tobject);
Begin
  PnlAgree.Visible := False;
  Panel1.Visible := True;
  lstReasons.SetFocus;
  GSess.PhysicianAcknowledgement := True;     //p130t9 2/13/13
End;

Procedure TfrmCopyAgreement.SetReasonList(Reasonlist: TStrings);
Begin
  FrmCopyAgreement.FReasonList.Assign(Reasonlist);
End;

Procedure TfrmCopyAgreement.ShowTypesOfReasons(Reasoncode: TMagReasonsCodes);
Var
  Rcode: String;
  i: Integer;
Begin
{  TMagReasonsCodes = (magreasonOther, magreasonPrint, magreasonCopy , magreasonDelete , magreasonStatus);}
  Case Reasoncode Of
    MagreasonPrint: Rcode := 'P';
    MagreasonCopy: Rcode := 'C';
    MagreasonDelete: Rcode := 'D';
    MagreasonStatus: Rcode := 'S';
    MagreasonOther: ;
  End; {case}
    {   We leave the last selected item, if it is the same 'reason code',  as the default}
  If FLastReasonCode = Rcode Then
  Begin
    Exit; //
  End
  Else
  Begin
    FLastReasonCode := Rcode;
    LstReasons.Clear;
    LbSelectedReason.caption := '';
    For i := 0 To Self.FReasonList.Count - 1 Do
    Begin
      If (Pos(Rcode, MagPiece(FReasonList[i], '^', 3)) > 0) Then LstReasons.Items.Add(MagPiece(FReasonList[i], '^', 2));
    End;
  End;

End;

Procedure TfrmCopyAgreement.LstReasonsClick(Sender: Tobject);
Begin
  btnOK.Enabled := (LstReasons.ItemIndex <> -1);
  LbSelectedReason.caption := LstReasons.Items[LstReasons.ItemIndex];
End;

Procedure TfrmCopyAgreement.FormCreate(Sender: Tobject);
Begin
  PnlAgree.Align := alClient;
  FReasonList := Tstringlist.Create;
  FLastReasonCode := '';
End;

Procedure TfrmCopyAgreement.FormDestroy(Sender: Tobject);
Begin
  FReasonList.Free;
End;

Procedure TfrmCopyAgreement.MnuExitClick(Sender: Tobject);
Begin
  ModalResult := MrCancel;
End;

Procedure TfrmCopyAgreement.File1Click(Sender: Tobject);
Begin

 mnuAgreement.enabled :=  not PnlAgree.Visible;
End;

Procedure TfrmCopyAgreement.ImageDownloadAgreementHelp1Click(
  Sender: Tobject);
Begin
  Application.HelpContext(0);
End;

Procedure TfrmCopyAgreement.MnuAgreementClick(Sender: Tobject);
Begin
  PnlAgree.Visible := True;
  PnlAgree.BringToFront;
  Panel1.Visible := False;
End;

End.
