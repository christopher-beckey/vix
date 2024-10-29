Unit cEvtScroll;
{
  Package: EKG Display
  Date Created: 07/07/2003
  Site Name: Silver Spring
  Developers: Robert Graves
  Description: overrides the TScrollBox to spawn scroll events
}
Interface

Uses
  Classes,
  Forms,
  Messages
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, SysUtils, Windows,

Type
  TEventScrollBox = Class(TScrollBox)
  Private
    FOnScrollHorz,
      FOnScrollVert: TNotifyEvent;
  Protected
    PreviousHorzPosition,
      PreviousVertPosition: Integer;

    Procedure WMHScroll(Var Message: TWMHScroll); Message WM_HSCROLL;
    Procedure WMVScroll(Var Message: TWMVScroll); Message WM_VSCROLL;
  Published
    Property OnScrollHorz: TNotifyEvent Read FOnScrollHorz Write FOnScrollHorz;
    Property OnScrollVert: TNotifyEvent Read FOnScrollVert Write FOnScrollVert;
  Public
    HorzDelta,
      VertDelta: Integer;
  End;

Implementation

Procedure TEventScrollBox.WMHScroll(Var Message: TWMHScroll);
// override to calculate scroll delta and to call the horizontal
// scroll event if assigned
Begin
  Inherited;
  HorzDelta := HorzScrollBar.Position - PreviousHorzPosition;
  PreviousHorzPosition := HorzScrollBar.Position;
  If Assigned(FOnScrollHorz) Then
    FOnScrollHorz(Self);
End;

Procedure TEventScrollBox.WMVScroll(Var Message: TWMVScroll);
// override to calculate scroll delta and to call the vertical
// scroll event if assigned
Begin
  Inherited;
  VertDelta := VertScrollBar.Position - PreviousVertPosition;
  PreviousVertPosition := VertScrollBar.Position;
  If Assigned(FOnScrollVert) Then
    FOnScrollVert(Self);
End;

End.
