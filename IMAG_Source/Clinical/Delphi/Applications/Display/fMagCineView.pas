Unit FmagcineView;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
        ;;  Property of the US Government.
        ;;  WARNING: Pe VHA Directive xxxxxx, this unit should not be modified.
        ;;  No permission to copy or redistribute this software is given.
        ;;  Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;
        ;;  Date created: June 2006
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: This is the CINE control tool used in the new Radiology
        ;;  Viewer. It is similar to the old CINE tool but allows variable speed
        ;;  for viewing the pages of the image.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Buttons,
  cMag4Vgear,
  ComCtrls,
  ExtCtrls,
  Forms,
  IMagViewer,
  Menus,
  Stdctrls,
  UMagClasses,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, Classes, Variants, Messages, Windows, MagPositions, SysUtils

Type

  TCineViewChangePageEvent = Procedure(Sender: Tobject; Const PageNumber: Integer) Of Object;
  { JMW 8/14/08 p72t26
   This event occurs when the user wants to give focus back to the parent
   form (Rad Viewer).  }
  TCineViewSetParentFocusEvent = Procedure(Sender: Tobject) Of Object;
  {/p122t8 dmmn 11/11/11 - add a start event so fmagRadviewer can assisn and check for annotation /}
  TCineViewStartEvent = Procedure(Sender : TObject; var CanStart : Boolean) of Object;

  TfrmCineView = Class(TForm)
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CineBar1: TScrollBar;
    Label1: Tlabel;
    PrevPg: TBitBtn;
    NextPg: TBitBtn;
    Timer1: TTimer;
    TrkbrCineSpeed: TTrackBar;
    Label2: Tlabel;
    LblCineSpeed: Tlabel;
    Faster: Tlabel;
    Label3: Tlabel;
    btnCine: TBitBtn;
    btnStop: TBitBtn;
    btnReset: TBitBtn;
    MainMenu1: TMainMenu;
    Hidden1: TMenuItem;
    SetParentFocus1: TMenuItem;
    Procedure CineBar1Change(Sender: Tobject);
    Procedure NextPgClick(Sender: Tobject);
    Procedure PrevPgClick(Sender: Tobject);
    Procedure btnResetClick(Sender: Tobject);
    Procedure btnCineClick(Sender: Tobject);
    Procedure btnStopClick(Sender: Tobject);
    Procedure Timer1Timer(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure TrkbrCineSpeedChange(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure SetParentFocus1Click(Sender: Tobject);
  Private
    { Private declarations }
    FGearViewer: TMag4VGear;
    FChangePangeEvent: TCineViewChangePageEvent;
    FCurrentViewer: IMag4Viewer;
    FSetParentFocusEvent: TCineViewSetParentFocusEvent;
    FCineStartEvent : TCineViewStartEvent; //p122t8 dmmn 11/11/11
    Procedure LoadNextPage();
    Procedure LoadPreviousPage();
    Procedure EnableCine(Value: Boolean);

  Public
//    procedure Execute(vGear : TMag4VGear); overload;
    Procedure Execute(StopPlay: Boolean = True); //overload;
    Procedure AssociateGearControl(VGear: TMag4VGear; Viewer: IMag4Viewer);
    Procedure StartCineView(Sender: TObject; var CanStart : boolean); dynamic;  //p122 dmmn 11/14/11   ~T10
    Procedure StopCineView();
    Procedure SetHidden();
    Function GetCurrentGearControl(): TMag4VGear;
    Property OnCineViewChangePage: TCineViewChangePageEvent Read FChangePangeEvent Write FChangePangeEvent;
    Procedure GetFormUPrefs(VUpref: Tuserpreferences);
    Procedure SetFormUPrefs(VUpref: Tuserpreferences);

    Property OnSetParentFocus: TCineViewSetParentFocusEvent Read FSetParentFocusEvent Write FSetParentFocusEvent;
    Property OnCineViewStartEvent : TCineViewStartEvent Read FCineStartEvent Write FCineStartEvent;  //122 ~T10

    { Public declarations }
  End;

Var
  FrmCineView: TfrmCineView;

Implementation
Uses
  Magpositions,
  SysUtils
  ;

{$R *.dfm}

{
procedure TfrmCineView.Execute(vGear : TMag4VGear);
begin
  FGearViewer := vGear;
  CineBar1.Max := FGearViewer.PageCount;
  label1.Caption := 'Page ' + inttostr(FGearViewer.Page) + ' of ' + inttostr(FGearViewer.PageCount);
  cinebar1.Position := FGearViewer.Page;
  btStop.Enabled := false;
  RadioButton1.Checked := true;
  Show();
end;
}

Procedure TfrmCineView.Execute(StopPlay: Boolean = True);
Begin
  If FGearViewer.PageCount > 0 Then
  Begin
    EnableCine(True);
    CineBar1.Max := FGearViewer.PageCount;
    Label1.caption := 'Page ' + Inttostr(FGearViewer.Page) + ' of ' + Inttostr(FGearViewer.PageCount);
    CineBar1.Position := FGearViewer.Page;
    // determines if the cine loop should be stopped (only stopped if new image selected)
    If StopPlay Then
      btnStopClick(Self);
  End
  Else
  Begin
    EnableCine(False);
    Timer1.Enabled := False;
    Label1.caption := 'Page 0 of 0';
  End;
  Show();
//  self.Parent.SetFocus();
End;

Procedure TfrmCineView.EnableCine(Value: Boolean);
Begin
  CineBar1.Enabled := Value;
//  btResume.Enabled := Value;
  btnStop.Enabled := Value;
  btnCine.Enabled := Value;
  btnReset.Enabled := Value;
  PrevPg.Enabled := Value;
  NextPg.Enabled := Value;
  GroupBox1.Enabled := Value
End;

Procedure TfrmCineView.AssociateGearControl(VGear: TMag4VGear; Viewer: IMag4Viewer);
Var
  Stop: Boolean;
Begin
  FCurrentViewer := Viewer;
  Stop := True;
  If FGearViewer = VGear Then
    Stop := False
  Else
    FGearViewer := VGear;
  If FGearViewer = Nil Then Exit;
  If Self.Visible = True Then
    Execute(Stop);
End;

Function TfrmCineView.GetCurrentGearControl(): TMag4VGear;
Begin
  Result := FGearViewer;
End;

Procedure TfrmCineView.LoadNextPage();
Begin
  If (CineBar1.Position >= CineBar1.Max) Then
  Begin
    If (RadioButton2.Checked) Then
    Begin
      CineBar1.Position := 1;
    End
    Else
    Begin
      btnResetClick(Self);
      btnStopClick(Self);
      Timer1.Enabled := False;
      Exit;
    End;
  End
  Else
  Begin
    CineBar1.Position := CineBar1.Position + 1;
  End;

End;

Procedure TfrmCineView.LoadPreviousPage();
Begin
  If CineBar1.Position <= 0 Then Exit;
  CineBar1.Position := CineBar1.Position - 1;

End;

Procedure TfrmCineView.CineBar1Change(Sender: Tobject);
Begin
  //FGearViewer.Page := cinebar1.Position;
  If FCurrentViewer <> Nil Then
    FCurrentViewer.SetImagePageUseApplyToAll(CineBar1.Position);
  Label1.caption := 'Page ' + Inttostr(FGearViewer.Page) + ' of ' + Inttostr(FGearViewer.PageCount);
  If Assigned(OnCineViewChangePage) Then
    OnCineViewChangePage(Self, CineBar1.Position);
End;

Procedure TfrmCineView.NextPgClick(Sender: Tobject);
Begin
  LoadNextPage();
End;

Procedure TfrmCineView.PrevPgClick(Sender: Tobject);
Begin
  LoadPreviousPage();
End;

Procedure TfrmCineView.btnResetClick(Sender: Tobject);
Begin
  CineBar1.Position := 1;
End;

Procedure TfrmCineView.btnCineClick(Sender: Tobject);
var
  CanStart : Boolean;
Begin
  {/p122t8 dmmn 11/14/11 - check if user can start the cine view /}
  CanStart := True;
  StartCineView(Sender, CanStart);
  if Not CanStart then
    Exit;
  btnStop.Enabled := True;
  btnCine.Enabled := False;
  Timer1.Enabled := True;

End;

Procedure TfrmCineView.btnStopClick(Sender: Tobject);
Begin
  Timer1.Enabled := False;
  btnCine.Enabled := True;
  btnStop.Enabled := False;
End;

Procedure TfrmCineView.Timer1Timer(Sender: Tobject);
Begin
  LoadNextPage();
End;

Procedure TfrmCineView.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self);
  TrkbrCineSpeed.Position := 10;
  RadioButton1.Checked := True;
  Self.Formstyle := Fsstayontop;
End;

Procedure TfrmCineView.FormDestroy(Sender: Tobject);
Begin
  Timer1.Enabled := False;
  SaveFormPosition(Self);
End;

Procedure TfrmCineView.TrkbrCineSpeedChange(Sender: Tobject);
Begin
  Timer1.Interval := TrkbrCineSpeed.Position;
  LblCineSpeed.caption := Inttostr(TrkbrCineSpeed.Position);
End;
procedure TfrmCineView.StartCineView(Sender: TObject; var CanStart : boolean);
begin
  {/p122t8 dmmn 11/14/11 /}
  if Assigned(FCineStartEvent) then
    FCineStartEvent(Self, CanStart);
end;

Procedure TfrmCineView.StopCineView();
Begin
  Timer1.Enabled := False;

End;

Procedure TfrmCineView.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  Timer1.Enabled := False;
End;

Procedure TfrmCineView.SetHidden();
Begin
  Timer1.Enabled := False;
  Self.Hide();
End;

Procedure TfrmCineView.GetFormUPrefs(VUpref: Tuserpreferences);
Begin
  VUpref.DicomCineSpeed := TrkbrCineSpeed.Position;
End;

Procedure TfrmCineView.SetFormUPrefs(VUpref: Tuserpreferences);
Begin
  If VUpref <> Nil Then
    TrkbrCineSpeed.Position := VUpref.DicomCineSpeed;
End;

Procedure TfrmCineView.SetParentFocus1Click(Sender: Tobject);
Begin
  If Assigned(FSetParentFocusEvent) Then
    FSetParentFocusEvent(Self);
End;

End.
