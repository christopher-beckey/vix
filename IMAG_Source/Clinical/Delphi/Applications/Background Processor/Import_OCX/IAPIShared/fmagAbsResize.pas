Unit FmagAbsResize;
{
  Package: EKG Display
  Date Created: 03/20/2004
  Site Name: Silver Spring
  Developers: Garrett Kirin
[==    unit fmagAbsResize;
  Description: Tool Window, for user to finalize a change in Abstract size.

  This window implements the execute function common to dialog windows.
    It creates itself, displays it's message, and destroys itself.
    This design releives the caller of Creating it, showmodal and then releasing it.
  Called from Abstract and Group Abstract windows.  Accepts the current TMag4VGear as
  the parameter

   Sets the property IsSizeable (of TMag4VGear) to TRUE, shows the window to tell
   user to drag the sides of the current abstract, and when user clicks 'Finished'
   button, the ReSizeAndAlign method of the TMag4Viewer is called.
      ==]
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
  cMag4Vgear,
  cmag4viewer,
  Controls,
  Forms,
  Graphics,
  Stdctrls,
  Classes
  ;

//Uses Vetted 20090929:Classes, SysUtils, Messages, Windows, Dialogs

Type
  TfrmAbsResize = Class(TForm)
    Label1: Tlabel;
    Label2: Tlabel;
    btnFinished: TBitBtn;
    Procedure btnFinishedClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
  Private
    FinitialHeight: Integer;
    FinitialWidth: Integer;
    Fgearcolor: TColor;
    FGearSizeable, FWasResized: Boolean;
    FMagGear: TMag4VGear;
    FMagViewer: TMag4Viewer;
    Procedure ResetGear;
  Public
        {       pass a Tmag4VGear the Viewer it is in and top,left of Window it is in }
    Procedure Execute(Maggear: TMag4VGear; MagViewer: TMag4Viewer; Toppos, Leftpos: Integer);
  End;

Var
  FrmAbsResize: TfrmAbsResize;

Implementation
Uses
  Dialogs
  ;

{$R *.DFM}

Procedure TfrmAbsResize.btnFinishedClick(Sender: Tobject);
Begin
  FMagViewer.ReSizeAndAlign(FMagGear.Height, FMagGear.Width);
  FWasResized := True;
  Application.Processmessages;
  Close;
End;

Procedure TfrmAbsResize.Execute(Maggear: TMag4VGear; MagViewer: TMag4Viewer; Toppos, Leftpos: Integer);
Begin
  If Maggear = Nil Then
  Begin
    Showmessage('Select an Abstract');
    Exit;
  End;
  With TfrmAbsResize.Create(Self) Do
  Begin
    FMagGear := Maggear;
    FMagViewer := MagViewer;
    Fgearcolor := FMagGear.Color;
    FGearSizeable := FMagGear.IsSizeAble;
    FinitialHeight := FMagGear.Height;
    FinitialWidth := FMagGear.Width;
    FWasResized := False;
    FMagViewer.ScrollAndDisplayImage(FMagGear.ListIndex);
    Top := Toppos + FMagGear.Top + 20; //toppos +  100;
    Left := Leftpos + FMagGear.Left + FMagGear.Width + (FMagGear.Width Div 2); //leftpos + 100;
    If ((Left + Width) > Screen.Width) Then Left := (Screen.Width - Width);
    If ((Top + Height) > Screen.Height) Then Top := (Screen.Height - Height);
    Show;
    FMagGear.Color := cllime;
    FMagGear.IsSizeAble := True;
    FMagGear.BringToFront;
  End;
End;

Procedure TfrmAbsResize.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  ResetGear;
  Application.Processmessages;
  action := caFree;
End;

Procedure TfrmAbsResize.ResetGear;
Begin
  FMagGear.Color := Fgearcolor;
  FMagGear.IsSizeAble := FGearSizeable;
  FMagGear.Cursor := crDefault;
  If Not FWasResized Then
  Begin
    FMagGear.Height := FinitialHeight;
    FMagGear.Width := FinitialWidth;
  End;
End;

End.
