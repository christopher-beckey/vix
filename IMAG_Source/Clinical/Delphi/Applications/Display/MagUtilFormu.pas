Unit MagUtilFormu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:    1996
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Utility form for Imaging Display App.  This is the last form created.
        So it's OnCreate Event happens after all other Windows have been created.
        Making the call here stops possible access violations.
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
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +---------------------------------------------------------------------------------------------------+
 
*)

Interface

Uses
  Forms
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, Classes, SysUtils, Messages, Windows,

Type
  TMagUtilformf = Class(TForm)
    Procedure FormCreate(Sender: Tobject);
  Private

  Public
    { Public declarations }
  End;

Var
  MagUtilformf: TMagUtilformf;

Implementation

Uses
  FmagMain
  ;

{$R *.DFM}

Procedure TMagUtilformf.FormCreate(Sender: Tobject);
Begin
  Frmmain.DoOnceAtEnd;
End;

End.
