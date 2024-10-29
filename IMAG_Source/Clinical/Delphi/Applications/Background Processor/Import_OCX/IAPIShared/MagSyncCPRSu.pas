Unit MagSyncCPRSu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   2000
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging CPRS Sync dialog.  Allows, Prompts for OK, when breaking
     the link to CPRS .. (not CCOW yet)
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
  Controls,
  ExtCtrls,
  Forms,
  Stdctrls,
  UMagClasses
  ;

//Uses Vetted 20090929:Graphics, Classes, SysUtils, Messages, Windows, Dialogs

Type
  TMagSyncCPRSf = Class(TForm)
    cbSyncOn: TCheckBox;
    RgSyncPatient: TRadioGroup;
    RgSyncProc: TRadioGroup;
    RgSyncHandle: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Timer1: TTimer;
    Label1: Tlabel;
    Label2: Tlabel;
    Procedure cbSyncOnClick(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure Timer1Timer(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Function VerifyBreakCPRSLink: Boolean;
    Procedure InformBreakCPRSLink;
  Private

    { Private declarations }
  Public

    { Public declarations }
  End;
Procedure GetCPRSLinkOptions(Var CprsSync: CprsSyncOptions);
Var
  MagSyncCPRSf: TMagSyncCPRSf;

Implementation
Uses
  Dialogs
  ;

{$R *.DFM}

Procedure GetCPRSLinkOptions(Var CprsSync: CprsSyncOptions);
Begin
  Application.BringToFront;

  MagSyncCPRSf.cbSyncOn.Checked := CprsSync.SyncOn;
  MagSyncCPRSf.RgSyncPatient.ItemIndex := 0;
  If CprsSync.PatSyncPrompt Then MagSyncCPRSf.RgSyncPatient.ItemIndex := 1;

  MagSyncCPRSf.Showmodal;
  If MagSyncCPRSf.ModalResult = MrCancel Then Exit;
  With MagSyncCPRSf Do
  Begin
    CprsSync.Queried := True;
    CprsSync.SyncOn := cbSyncOn.Checked;
    CprsSync.PatSync := (RgSyncPatient.ItemIndex = 0);
    CprsSync.PatSyncPrompt := (RgSyncPatient.ItemIndex = 1);
    If CprsSync.PatSync Then
      CprsSync.PatRejected := '';
    CprsSync.ProcSync := (RgSyncProc.ItemIndex = 0);
    CprsSync.ProcSyncPrompt := (RgSyncProc.ItemIndex = 1);
    CprsSync.HandleSync := (RgSyncHandle.ItemIndex = 0);
    CprsSync.HandleSyncPrompt := (RgSyncHandle.ItemIndex = 1);
    If CprsSync.HandleSync Then
    Begin
      CprsSync.CprsHandle := 0;
      CprsSync.HandleRejected := 0;
    End;

  End;
End;

Function TMagSyncCPRSf.VerifyBreakCPRSLink: Boolean;
Begin
  Result := True;
  If Messagedlg('You have choosen to Break the Imaging <-> CPRS Link.' + #13 +
    'To Re-Establish the Link between Imaging and CPRS' + #13 +
    'You will have to close Imaging and Restart Imaging from the CPRS ''Tools'' menu', MtWarning, [Mbok, Mbcancel], 0)
    = MrCancel Then Result := False;
End;

Procedure TMagSyncCPRSf.InformBreakCPRSLink;
Begin
  Messagedlg('You have choosen to Break the Imaging <-> CPRS Link.' + #13 +
    'To Re-Establish the Link between Imaging and CPRS' + #13 +
    'You will have to close Imaging and Restart Imaging from the CPRS ''Tools'' menu', Mtinformation, [Mbok], 0);

End;

Procedure TMagSyncCPRSf.cbSyncOnClick(Sender: Tobject);
Begin
  If cbSyncOn.Checked Then
  Begin
    //  12/21/99  rgSyncPatient.enabled := true;
    //rgSyncProc.enabled := true;
    //rgSyncHandle.enabled := true;
  End
  Else
  Begin
    RgSyncPatient.Enabled := False;
    RgSyncProc.Enabled := False;
    RgSyncHandle.Enabled := False;
  End;

End;

Procedure TMagSyncCPRSf.FormShow(Sender: Tobject);
Begin
  Timer1.Enabled := True;
End;

Procedure TMagSyncCPRSf.Timer1Timer(Sender: Tobject);
Begin
  MagSyncCPRSf.BringToFront;
End;

Procedure TMagSyncCPRSf.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  Timer1.Enabled := False;
End;

End.
