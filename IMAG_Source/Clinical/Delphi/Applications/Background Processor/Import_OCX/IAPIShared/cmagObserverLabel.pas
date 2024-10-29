Unit cMagObserverLabel;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
[==     unit cmagObserverLabel;
 Description: Label Component with IMagObserver Interface.
 Attaches to IMagSubject(TMag4Pat)
   and displays and maintains the Name (or FakeName) of the patient defined in Tmag4Pat.
   Whenever Tmag4Pat changes states ( changes patients) it notifies all attached
   observers.  TmagObserverlabel updates it's caption to the new patient name.
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
  cMagPat,
  ImagInterfaces,
  Stdctrls
  ,
  Maggmsgu  
  ;

//Uses Vetted 20090929:Forms, Controls, Graphics, Messages, Windows, Dialogs, SysUtils

Type
  TMagObserverLabel = Class(Tlabel, IMagObserver)
  Private
    FMagpat: TMag4Pat;
    Procedure AttachMyself;
  Protected
    { Protected declarations }
  Public
        {       Implementation of ImagObserver interface.  Subject calls this to notify
                observer of a change in state.}
    Procedure UpDate_(SubjectState: String; Sender: Tobject); { Public declarations }
        {       Set the reference to Patient object}
    Procedure SetMagPat(Const Value: TMag4Pat);
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
  Published
        {       Set the reference to Patient object}
    Property MagPat: TMag4Pat Read FMagpat Write SetMagPat; { Published declarations }
  End;

Procedure Register;

Implementation
Uses
  Dialogs,
  SysUtils
  ;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagObserverLabel]);
End;

{ TmagObserverLabel }

Constructor TMagObserverLabel.Create(AOwner: TComponent);
Begin
  Inherited;
  //
End;

Procedure TMagObserverLabel.SetMagPat(Const Value: TMag4Pat);
Begin
        {       Detach from current patient object}
  If (FMagpat <> Nil) Then FMagpat.Detach_(Self);
  FMagpat := Value;
        {       Attach to New patient object}
  If Value <> Nil Then AttachMyself();
End;

Procedure TMagObserverLabel.AttachMyself;
Begin
  If Assigned(FMagpat) Then
  Begin
    FMagpat.Attach_(IMagObserver(Self));
  End;
End;

Procedure TMagObserverLabel.UpDate_(SubjectState: String; Sender: Tobject);
   {    subjectState can be '', '-1'  or  '1' }
Begin
  Try
    maglogger.LogMsg('s', '**--**-- -- -- TmagObserverLabel.Update_  state ' + SubjectState);
    caption := '';
    If (SubjectState <> '') Then
      If (SubjectState = '-1')
        {       if Subject is being destroyed. Clear Pointer.}Then
        FMagpat := Nil
        {       Subject has value, display it.}
      Else
        caption := FMagpat.M_NameDisplay;
  Except
    On e: Exception Do
      Showmessage('Exception in ObserverLabel Update_' + e.Message);
  End;
End;

Destructor TMagObserverLabel.Destroy;
Begin
  {    first see if reference to Patient ojbect is defined, because it may have been
        destroyed already }
  If Assigned(FMagpat) Then
  Begin
    FMagpat.Detach_(IMagObserver(Self));
    FMagpat := Nil;
  End;
  Inherited;
End;

End.
