Unit cMag4ViewerEventScrollBox;
{
  Package: Imaging Display
  Date Created: 07/07/2003
  Site Name: Silver Spring
  Developers: Robert Graves
  [==
  Description:  unit cMagEventScrollBox;
  Used by EKG window, and TMag4Viewer class
  it overrides TScrollBox to spawn Horizontal and Vertical scroll events
  Tmag4Viewer uses the events to refresh the visible Proxies, Images.
  EKG window uses the events to keep multiple scroll controls in sync.
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
  Classes,
  Forms,
  Messages
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, SysUtils, Windows

Type
  TMagEventScrollBox = Class(TScrollBox)
  Private
    FOnEndScroll,
      FOnScrollHorz,
      FOnScrollVert: TNotifyEvent;
  Protected
    PreviousHorzPosition,
      PreviousVertPosition: Integer;

        {  Override the Windows Horizontal Scroll message}
    Procedure WMHScroll(Var Msg: TWMHScroll); Message WM_HSCROLL;

        {  Override the Windows Vertical Scroll message}
    Procedure WMVScroll(Var Msg: TWMVScroll); Message WM_VSCROLL;
  Published
    Property OnEndScroll: TNotifyEvent Read FOnEndScroll Write FOnEndScroll;
        {  Surface the Horizontal Scroll event for this component}
    Property OnScrollHorz: TNotifyEvent Read FOnScrollHorz Write FOnScrollHorz;

        {  Surface the Vertical Scroll event for this component}
    Property OnScrollVert: TNotifyEvent Read FOnScrollVert Write FOnScrollVert;
  Public
    HorzDelta,
      VertDelta: Integer;

  End;

Procedure Register;

Implementation
Uses
  Windows
  ;

Procedure TMagEventScrollBox.WMHScroll(Var Msg: TWMHScroll);
// override to calculate scroll delta and to call the horizontal
// scroll event if assigned
Begin
  Inherited;
  Case Msg.ScrollCode Of
 {The user releases the scroll box after dragging it.}
    SB_THUMBPOSITION:
      Begin
  // if Assigned(FOnEndScroll) then FOnEndScroll(self);
      End;
 {The user releases the mouse after holding it on an arrow or in the scroll bar shaft. }
    SB_ENDSCROLL:
      Begin
        If Assigned(FOnEndScroll) Then FOnEndScroll(Self);
      End;
  End;
  HorzDelta := HorzScrollBar.Position - PreviousHorzPosition;
  PreviousHorzPosition := HorzScrollBar.Position;
  If Assigned(FOnScrollHorz) Then
    FOnScrollHorz(Self);
End;

Procedure TMagEventScrollBox.WMVScroll(Var Msg: TWMVScroll);
// override to calculate scroll delta and to call the vertical
// scroll event if assigned
Begin
  Inherited;
  Case Msg.ScrollCode Of
 {The user releases the scroll box after dragging it.}
    SB_THUMBPOSITION:
      Begin
        If Assigned(FOnEndScroll) Then FOnEndScroll(Self);
      End;
 {The user releases the mouse after holding it on an arrow or in the scroll bar shaft. }
    SB_ENDSCROLL:
      Begin
        If Assigned(FOnEndScroll) Then FOnEndScroll(Self);
      End;
  End;
  VertDelta := VertScrollBar.Position - PreviousVertPosition;
  PreviousVertPosition := VertScrollBar.Position;
  If Assigned(FOnScrollVert) Then
    FOnScrollVert(Self);
End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagEventScrollBox]);
End;

End.
