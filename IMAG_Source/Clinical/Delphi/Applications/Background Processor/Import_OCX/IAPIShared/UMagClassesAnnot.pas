Unit UMagClassesAnnot;
(*
;; +------------------------------------------------------------------+
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
;; +------------------------------------------------------------------+
*)
Interface

Uses
  Graphics;

Type

  TMagAnnotationStyle = Class
  Public
    AnnotationColor: TColor;
    LineWidth: Integer;
    MeasurementUnits: Integer;
    Constructor Create; Overload;
    Constructor Create(Color: TColor; LWidth: Integer; MeasureUnits: Integer); Overload;
  End;

  TMagAnnotationStyleChangeEvent = Procedure(Sender: Tobject; AnnotationStyle: TMagAnnotationStyle) Of Object;

Implementation

Constructor TMagAnnotationStyle.Create;
Begin
  Inherited Create;
  Self.AnnotationColor := clYellow;
  Self.LineWidth := 2;
  Self.MeasurementUnits := 6;
End;

Constructor TMagAnnotationStyle.Create(Color: TColor; LWidth: Integer;
  MeasureUnits: Integer);
Begin
  Inherited Create;
  Self.AnnotationColor := Color;
  Self.LineWidth := LWidth;
  Self.MeasurementUnits := MeasureUnits;
End;

End.
