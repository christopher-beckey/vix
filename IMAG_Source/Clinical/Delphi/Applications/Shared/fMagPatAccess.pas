Unit FMagPatAccess;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created: Version 2.5
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==   unit fMagPatAccess;
   Description:
     This window is created by the Patient Lookup window (maggplku.dfm)
     it's function is :
    - Patient Sensitivity warnings are displayed.
    - Sensitive Patient Logging is done when needed.
    - Means Test warnings are displayed if appropriate.

    This window implements the execute function common to dialog windows.
        It creates itself, displays it's message, and destroys itself.
        This design releives the caller of Creating it, showmodal and then releasing it.

   Note: }
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
  Stdctrls
  ;

//Uses Vetted 20090929:uMagClasses, ComCtrls, Dialogs, Graphics, Messages, WinProcs, WinTypes, SysUtils,

Type
  TfrmPatAccess = Class(TForm)
    Timer1: TTimer;
    ScrollBox1: TScrollBox;
    LbAlign: Tlabel;
    Memo1: TMemo;
    Lbmsg: Tlabel;
    Panel1: Tpanel;
    LbAlerttext: Tlabel;
    Panel2: Tpanel;
    bbOK: TBitBtn;
    Panel3: Tpanel;
    bbCancel: TBitBtn;
    btnCancelAll: TBitBtn; //45
    LblSiteName: Tlabel; //45
    Procedure Timer1Timer(Sender: Tobject);
    Procedure Image1Click(Sender: Tobject);
    Procedure FormPaint(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure bbOKClick(Sender: Tobject);
    Procedure bbCancelClick(Sender: Tobject);
    Procedure Memo1Click(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure btnCancelAllClick(Sender: Tobject); //45
  Private
    CancelAll: Boolean; //45

  Public
        {       msg : is the message to display
                code: tells this window which buttons to display
                User selects OK, result is TRUE.
                else result is FALSE.}
{//45 cancelallremaining, sitename}
    Function Execute(Sender: Tobject; Msg: Tstringlist; Code: Integer; Var CancelAllRemaining: Boolean; SiteName: String = ''): Boolean; { Public declarations }
    Function executeForRemoteWSSite(Sender: Tobject; Msg: Tstringlist; Code: Integer; SiteName: String): Boolean;
  End;

Var
  FrmPatAccess: TfrmPatAccess;

Implementation

{$R *.DFM}

{
  JMW 6/2/09 P93T8
This method is called from remote WS brokers.  It differs in that it displays
the remote site name but it doesn't allow Cancel Remaining button. This can't
be supported with Remote WS brokers.}

Function TfrmPatAccess.executeForRemoteWSSite(Sender: Tobject; Msg: Tstringlist;
  Code: Integer; SiteName: String): Boolean;
Var
  i: Integer;
  Th, Tw, Sx: Integer;
Begin

  FrmPatAccess := TfrmPatAccess.Create(Application.MainForm);

  With FrmPatAccess Do
  Begin
    CancelAll := False; //45
    Update;
    Application.Processmessages;
    {code and msg : are returned by the DG RPC's (PIMMS Pkg) that perform the
      patient sensitivity check}
    If SiteName <> '' Then //45
    Begin
      caption := 'VistA Imaging: Patient Alert !!! @ ' + SiteName;
    End
    Else
    Begin
      caption := 'VistA Imaging: Patient Alert !!!';
    End;
    LblSiteName.caption := 'Remote Site: ' + SiteName;
    LblSiteName.Visible := False;
    btnCancelAll.Visible := False;
    Case Code Of
      1:
        Begin
          LbAlerttext.caption := 'RESTRICTED PATIENT RECORD !!!';
          LblSiteName.Visible := True;
          Lbmsg.caption := 'Access to this patient has been logged. Click ''OK'' to continue';
          bbOK.Enabled := True;
          bbCancel.Enabled := False;
        End;
      2:
        Begin
          LbAlerttext.caption := 'RESTRICTED PATIENT RECORD !!!';
          Lbmsg.caption := 'Click ''OK'' to Access the Patient. (Access will be logged)';
          bbOK.Enabled := True;
          bbCancel.Enabled := True;
        End;
      3:
        Begin
          LbAlerttext.caption := 'RESTRICTED PATIENT RECORD !!!';

          If SiteName <> '' Then LblSiteName.Visible := True;
          Lbmsg.caption := 'Access to this restricted patient is Not Allowed.';
          bbOK.Enabled := False;
          bbCancel.Enabled := True;
        End;
         // Means Test Required
      4:
        Begin
          LbAlerttext.caption := 'MEANS TEST REQUIRED !!!';
          Lbmsg.caption := 'A Means Test is Required for this patient.';
          bbOK.Enabled := True;
          bbCancel.Enabled := False;
        End;
      5:
        Begin
          LbAlerttext.caption := 'SIMILIAR PATIENT RECORDS !!!';
          Lbmsg.caption := 'Click ''OK'' to continue with selected patient.';
          bbOK.Enabled := True;
          bbCancel.Enabled := True;
        End;

    End;
    Memo1.Lines := Msg;
    For i := 1 To (Memo1.Lines.Count + 2) Do
      Memo1.Lines.Insert(0, '  ');

    Canvas.Font := Memo1.Font;
    Update;
    Th := 0;
    Tw := 0;
    For i := 0 To Memo1.Lines.Count - 1 Do
    Begin
      Sx := Canvas.Textwidth(Memo1.Lines[i]);
      If Sx > Tw Then Tw := Sx;
      Sx := Canvas.TextHeight(Memo1.Lines[i]);
      If Sx > Th Then Th := Sx;
    End;
    Width := Tw + 150;

    bbOK.Visible := True; //45

    If Width < 425 Then Width := 425;
    Memo1.Height := (Th * (Memo1.Lines.Count + 2));
    ScrollBox1.Height := Memo1.Height Div 2;
    ScrollBox1.VertScrollBar.Range := Memo1.Height;
    ClientHeight := Lbmsg.Top + Lbmsg.Height + 60;
    Update;
    Application.Processmessages;
    Showmodal;
  End;

  If FrmPatAccess.ModalResult = MrOK Then
    Result := True
  Else
    Result := False;
{TODO: This was giving Access violations.  Need to retest and make sure we
       are freeing memory. AccViol maybe caused by main form also creating
       the form in error}
//frmPatAccess.free;  ?
// Note: That we are setting action := caFree in the FormClose event.

End;

{This window implements the execute function common to dialog windows.
It creates itself, displays it's message, and destroys itself.
This design releives the caller of Creating it, showmodal and then releasing it.
}

Function TfrmPatAccess.Execute(Sender: Tobject; Msg: Tstringlist; Code: Integer; Var CancelAllRemaining: Boolean; SiteName: String = ''): Boolean;
Var
  i: Integer;
  Th, Tw, Sx: Integer;
Begin

  FrmPatAccess := TfrmPatAccess.Create(Application.MainForm);

  With FrmPatAccess Do
  Begin
    CancelAll := False; //45
    Update;
    Application.Processmessages;
    {code and msg : are returned by the DG RPC's (PIMMS Pkg) that perform the
      patient sensitivity check}
    If SiteName <> '' Then //45
    Begin
      caption := 'VistA Imaging: Patient Alert !!! @ ' + SiteName;
    End
    Else
    Begin
      caption := 'VistA Imaging: Patient Alert !!!';
    End;
    LblSiteName.caption := 'Remote Site: ' + SiteName;
    LblSiteName.Visible := False;
    Case Code Of
      1:
        Begin
          LbAlerttext.caption := 'RESTRICTED PATIENT RECORD !!!';
          If SiteName <> '' Then LblSiteName.Visible := True;
          Lbmsg.caption := 'Access to this patient has been logged. Click ''OK'' to continue';
          bbOK.Enabled := True;
          bbCancel.Enabled := False;
          btnCancelAll.Visible := False;
        End;
      2:
        Begin
          LbAlerttext.caption := 'RESTRICTED PATIENT RECORD !!!';
          If SiteName <> '' Then LblSiteName.Visible := True;
          Lbmsg.caption := 'Click ''OK'' to Access the Patient. (Access will be logged)';
          bbOK.Enabled := True;
          bbCancel.Enabled := True;
          // SiteName = '' for local sites, remote sites will have a Site Name specified
          If SiteName = '' Then //45
          Begin
            btnCancelAll.Visible := False;
          End
          Else
          Begin
            btnCancelAll.Visible := True;
          End;
        End;
      3:
        Begin
          LbAlerttext.caption := 'RESTRICTED PATIENT RECORD !!!';

          If SiteName <> '' Then LblSiteName.Visible := True;
          Lbmsg.caption := 'Access to this restricted patient is Not Allowed.';
          bbOK.Enabled := False;
          bbCancel.Enabled := True;
          If SiteName = '' Then //45
          Begin
            btnCancelAll.Visible := False;
          End
          Else
          Begin
            btnCancelAll.Visible := True;
          End;
        End;
         // Means Test Required
      4:
        Begin
          LbAlerttext.caption := 'MEANS TEST REQUIRED !!!';
          Lbmsg.caption := 'A Means Test is Required for this patient.';
          bbOK.Enabled := True;
          bbCancel.Enabled := False;
          btnCancelAll.Visible := False;
        End;
      5:
        Begin
          LbAlerttext.caption := 'SIMILIAR PATIENT RECORDS !!!';
          Lbmsg.caption := 'Click ''OK'' to continue with selected patient.';
          bbOK.Enabled := True;
          bbCancel.Enabled := True;
          btnCancelAll.Visible := False;
        End;

    End;
    Memo1.Lines := Msg;
    For i := 1 To (Memo1.Lines.Count + 2) Do
      Memo1.Lines.Insert(0, '  ');

    Canvas.Font := Memo1.Font;
    Update;
    Th := 0;
    Tw := 0;
    For i := 0 To Memo1.Lines.Count - 1 Do
    Begin
      Sx := Canvas.Textwidth(Memo1.Lines[i]);
      If Sx > Tw Then Tw := Sx;
      Sx := Canvas.TextHeight(Memo1.Lines[i]);
      If Sx > Th Then Th := Sx;
    End;
    Width := Tw + 150;

    bbOK.Visible := True; //45

    If Width < 425 Then Width := 425;
    Memo1.Height := (Th * (Memo1.Lines.Count + 2));
    ScrollBox1.Height := Memo1.Height Div 2;
    ScrollBox1.VertScrollBar.Range := Memo1.Height;
    ClientHeight := Lbmsg.Top + Lbmsg.Height + 60;
    Update;
    Application.Processmessages;
    Showmodal;
  End;

  If FrmPatAccess.ModalResult = MrOK Then
    Result := True
  Else
    Result := False;
  //CancelAllRemaining := frmPatAccess.CancelAll;  //45
  CancelAllRemaining := (FrmPatAccess.ModalResult = MrNoToAll);
{TODO: This was giving Access violations.  Need to retest and make sure we
       are freeing memory. AccViol maybe caused by main form also creating
       the form in error}
//frmPatAccess.free;  ?
// Note: That we are setting action := caFree in the FormClose event.
End;

Procedure TfrmPatAccess.Timer1Timer(Sender: Tobject);
Begin
  ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position +
    ScrollBox1.VertScrollBar.Increment;
End;

Procedure TfrmPatAccess.Image1Click(Sender: Tobject);
Begin
  Timer1.Enabled := Not Timer1.Enabled;
End;

Procedure TfrmPatAccess.FormPaint(Sender: Tobject);
Begin
(*scrollbox1.left :=  (clientwidth-scrollbox1.width) div 2; *)
End;

Procedure TfrmPatAccess.FormCreate(Sender: Tobject);
Begin
(*clientheight := lbAlign.top+lbalign.height;
  clientwidth := lbAlign.left+lbAlign.width; *)

End;

Procedure TfrmPatAccess.bbOKClick(Sender: Tobject);
Begin
  Timer1.Enabled := False;
End;

Procedure TfrmPatAccess.bbCancelClick(Sender: Tobject);
Begin
  Timer1.Enabled := False;
End;

Procedure TfrmPatAccess.Memo1Click(Sender: Tobject);
Begin
  Timer1.Enabled := Not Timer1.Enabled;
End;

Procedure TfrmPatAccess.FormShow(Sender: Tobject);
Begin
  ScrollBox1.VertScrollBar.Position := 0;
  Timer1.Interval := 15;
  Timer1.Enabled := True;

End;

Procedure TfrmPatAccess.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  action := caFree;
//  WIDTH := 900;
End;

Procedure TfrmPatAccess.btnCancelAllClick(Sender: Tobject); //45
Begin
  Timer1.Enabled := False;
  FrmPatAccess.CancelAll := True;
End;

End.
