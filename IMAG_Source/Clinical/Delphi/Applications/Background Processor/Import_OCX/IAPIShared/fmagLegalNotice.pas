Unit FMagLegalNotice;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   Version 3 Patch 7 (3/1/2002)
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Displays legal information concerning the VistA Imaging Application
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
  Buttons,
  ExtCtrls,
  Forms,
  Stdctrls,
  Jpeg,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:jpeg, Dialogs, Controls, Graphics, Classes, SysUtils, Messages, Windows,

Type
  TfrmMagLegalNotice = Class(TForm)
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    Panel1: Tpanel;
    Image2: TImage;
    Label5: Tlabel;
    Label6: Tlabel;
    Label7: Tlabel;
    Label8: Tlabel;
    Procedure BitBtn1Click(Sender: Tobject);
  Private
  Public
    Procedure Execute;
  End;

Var
  FrmMagLegalNotice: TfrmMagLegalNotice;

Implementation

{$R *.DFM}

Procedure TfrmMagLegalNotice.Execute;
Begin
  With TfrmMagLegalNotice.Create(Nil) Do
  Begin
    Showmodal;
    Free;
  End;
End;

Procedure TfrmMagLegalNotice.BitBtn1Click(Sender: Tobject);
Begin
  Close;
End;

End.
