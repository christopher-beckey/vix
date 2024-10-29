Unit cMagLabelNoClear;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
[==  unit cmagLabelNoClear;
   Description: Capture Component to support 'Hold Value' properties of the
   configuration.

   On the Capture Main form, each data input control, (editbox, ComboBox) is
   associated with a label of type TmagLabelNoClear.
   When user changes the 'Hold Value' of an input control, the associated
   TmagLabelNoClear label's 'NoClear' property is changed.

   As a visual aid for the user, this control has an associated Glyph, when
   the 'NoClear' property is changed the associated Glyph is made visible/invisible

   When a capture configuration is saved the 'NoClear' properties of all controls
   of type TmagLabelNoClear are querried. The value (TRUE/FALSE) of the 'NoClear'
   property is saved with the configuration. If NoClear is TRUE the value of the
   associated input control is also saved with the configuration.

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
   ;; a medical device.  As such, it may not be changed
   ;; in any way.  Modifications to this software may result in an
   ;; adulterated medical device under 21CFR820, the use of which
   ;; is considered to be a violation of US Federal Statutes.
   ;; +---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Classes,
  ExtCtrls,
  Stdctrls
  ;

//Uses Vetted 20090929:Dialogs, Forms, Controls, Graphics, SysUtils, Messages, Windows,

Type
  TmagLabelNoClear = Class(Tlabel)
  Private
    FGlyphControl: TImage;
    FNoClear: Boolean;
    FVisible: Boolean;
    Procedure SetNoClear(Const Value: Boolean);
    Procedure SetVisible(Const Value: Boolean);
  Protected
    { Protected declarations }
  Public

  Published
    Property Visible: Boolean Read FVisible Write SetVisible;

    Property NoClear: Boolean Read FNoClear Write SetNoClear;
    Property GlyphyControl: TImage Read FGlyphControl Write FGlyphControl;
  End;

Procedure Register;

Implementation

Procedure Register;
Begin
  RegisterComponents('Imaging', [TmagLabelNoClear]);
End;

Procedure TmagLabelNoClear.SetNoClear(Const Value: Boolean);
Begin
  FNoClear := Value;
  If FNoClear Then
  Begin
         //font.color := clWhite;
    If Assigned(FGlyphControl) And FVisible Then FGlyphControl.Visible := True;
  End
  Else
  Begin
         //font.color := clBlack;
    If Assigned(FGlyphControl) Then FGlyphControl.Visible := False;
  End;
End;

Procedure TmagLabelNoClear.SetVisible(Const Value: Boolean);
Begin
  FVisible := Value;
  If FVisible Then
    Show
  Else
    Hide;
  If Not FVisible Then
    If Assigned(FGlyphControl) Then FGlyphControl.Visible := False;
  If FVisible Then
    If Assigned(FGlyphControl) Then FGlyphControl.Visible := FNoClear;
End;

End.
