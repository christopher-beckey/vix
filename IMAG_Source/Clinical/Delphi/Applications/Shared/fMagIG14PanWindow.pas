Unit FMagIG14PanWindow;
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
        ;;  Description: This is the AccuSoft Image Gear v14 Pan window for use
        ;;  with the IG 14 main component (fMag4VGear14). This creates a pan
        ;;  window for the user.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Controls,
  FmagImage,
  Forms,
  GearCORELib_TLB,
  GearDISPLAYLib_TLB,
  GearVIEWLib_TLB,
  IGGUIWinLib_TLB,
  Stdctrls,
  UMagClasses,
  AxCtrls,
  OleCtrls,
  Classes,
  IMagPanWindow
  ;

//Uses Vetted 20090929:OleCtrls, AxCtrls, Dialogs, Graphics, Classes, Variants, SysUtils, Messages, Windows, uMagUtils

Type
  TfrmIG14PanWindow = Class;

  TfrmIG14PanWindow = Class(TForm, TMagPanWindow)
    ScrollBar1: TScrollBar;
    IGGUIPanCtl1: TIGGUIPanCtl;
    IGPageViewCtl1: TIGPageViewCtl;
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure ScrollBar1Change(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    procedure IGGUIPanCtl1TrackDone(Sender: TObject);
  Private
    FImage: TMagImage;
    FFirstTime: Boolean;
    FPanWindowClose: TMagPanWindowCloseEvent;
    { Private declarations }
  Public
    Procedure Execute(CoreComponentInterface: IIGComponent; DisplayComponentInterface: IIGComponent; PageDisplay: IGPageDisplay;
      PageViewHwnd: Integer; h, w, x, y: Integer; Image: TMagImage);
    Procedure Hide();
    Procedure UpdateView();
    Procedure UpdatePosition();
    Procedure SetVisible(Visible : boolean);
    Function GetVisible() : boolean;
    Procedure SetPanWindowCloseEvent(PanWindowClose : TMagPanWindowCloseEvent);
    Property OnPanWindowClose: TMagPanWindowCloseEvent Read FPanWindowClose Write FPanWindowClose;
    Property CurImage: TMagImage Read FImage;
    { Public declarations }
  End;

//Var
//  FrmIG14PanWindow: TfrmIG14PanWindow;

Implementation
Uses
  Umagutils8
  ;

{$R *.dfm}

Procedure TfrmIG14PanWindow.Execute(CoreComponentInterface: IIGComponent
                                    ; DisplayComponentInterface: IIGComponent
                                    ; PageDisplay: IGPageDisplay
                                    ; PageViewHwnd: Integer
                                    ; h, w, x, y: Integer
                                    ; Image: TMagImage);
Var
  Wrksarea: TMagScreenArea;
Begin
  IGPageViewCtl1.Align := alClient;


  IGGUIPanCtl1.SetParentImage(CoreComponentInterface, DisplayComponentInterface, PageDisplay, PageViewHwnd);
  // JMW 6/25/08
  // only set the size/position if its not visible (first time showing)
  If Not Self.Visible Then
  Begin
    // don't allow very small values
    If h > 225 Then
      Self.Height := h
    Else
      Self.Height := 300;
    If w > 250 Then
    Begin
      If (w > (h + 50)) Then
        Self.Width := h + 50
      Else
        Self.Width := w
    End
    Else
      Self.Width := 335;
    Self.Left := x;
    Self.Top := y;

    // JMW 6/26/08 p72t23 - make sure the pan window appears fully on
    // the screen
    Wrksarea := GetScreenArea;
    Try
      If (Self.Left + Self.Width) > Wrksarea.Right Then Self.Left := Wrksarea.Right - Self.Width;
      If (Self.Top + Self.Height) > Wrksarea.Bottom Then Self.Top := Wrksarea.Bottom - Self.Height;
      If (Self.Top < Wrksarea.Top) Then Self.Top := Wrksarea.Top;
      If (Self.Left < Wrksarea.Left) Then Self.Left := Wrksarea.Left;
    Finally
      Wrksarea.Free;
    End;
    Self.Visible := True;
  End;
  FImage := Image;
  // bring to front makes the pan window have the focus, prevents mouse wheel
  // scrolling from working with pan window open, also not really sure we want
  // to be doing this
//  self.BringToFront();

  Formstyle := Fsstayontop;

  ScrollBar1.Position := FImage.ZoomLevel;

  IGGUIPanCtl1.SetPanWindow(IGPageViewCtl1.Hwnd);
  If FFirstTime Then
  Begin
    IGPageViewCtl1.UpdateView();
    FFirstTime := False;
  End;
  IGGUIPanCtl1.Update();
End;

Procedure TfrmIG14PanWindow.Hide();
Begin
//  self.Hide();
  // get rid of grid?
End;

procedure TfrmIG14PanWindow.IGGUIPanCtl1TrackDone(Sender: TObject);
begin
  FImage.RefreshScoutLine();
end;

Procedure TfrmIG14PanWindow.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
//  Hide();
  If Assigned(FPanWindowClose) Then
    FPanWindowClose(Self);
  FFirstTime := True;
End;

Procedure TfrmIG14PanWindow.ScrollBar1Change(Sender: Tobject);
Begin
  FImage.ZoomValue(ScrollBar1.Position);
End;

Procedure TfrmIG14PanWindow.UpdateView();
Begin
  IGPageViewCtl1.UpdateView();
End;

Procedure TfrmIG14PanWindow.UpdatePosition();
Begin
  IGGUIPanCtl1.Update();
End;

Procedure TfrmIG14PanWindow.FormCreate(Sender: Tobject);
Begin
  FFirstTime := True;
  Self.HelpContext := 10216;
End;

Procedure TfrmIG14PanWindow.SetVisible(Visible : boolean);
begin
  Self.Visible := Visible;
end;

Function TfrmIG14PanWindow.GetVisible() : boolean;
begin
  result := Self.Visible;
end;

Procedure TfrmIG14PanWindow.SetPanWindowCloseEvent(PanWindowClose : TMagPanWindowCloseEvent);
begin
  FPanWindowClose := PanWindowClose;
end;

End.
