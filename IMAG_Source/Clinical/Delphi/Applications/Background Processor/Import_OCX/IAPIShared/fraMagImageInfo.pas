Unit FraMagImageInfo;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  12/2003
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==     unit fraMagImageInfo;
   Description: Image Information frame, used multiple times in the
        frmMagImageInfo window to display the Image information and Abstract.

        The frame has components TMag4Vgear which is used to display the abstract
        and a ScrollBox which is used to display the Image information.
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
  Buttons,
  Classes,
  cMag4Vgear,
  ExtCtrls,
  Forms,
  Stdctrls,
  Controls
  ;

//Uses Vetted 20090929:umagclasses, Dialogs, Controls, Graphics, SysUtils, Messages, Windows,

Type
  TfraImageInfo = Class(TFrame)
    Lbinfo: Tlabel;
    ScrollBox1: TScrollBox;
    Panel1: Tpanel;
    Mag4Vgear1: TMag4VGear;
    btnClose: TBitBtn;
    Lbimageinfo: Tlabel;
    Procedure btnCloseClick(Sender: Tobject);
  Private

    { Private declarations }
  Public
    Constructor Create(AOwner: TComponent); Override;
    Function GetImageIEN: String;
  End;

Implementation

{$R *.DFM}

{ TfraImageInfo }

Constructor TfraImageInfo.Create(AOwner: TComponent);
Begin
  Inherited;
  Name := '';

  Mag4Vgear1.AbstractImage := False;
  Mag4Vgear1.ViewStyle := MagGearViewAbs;
  Mag4Vgear1.ImageViewState := MagGearImageViewAbs;
End;

Procedure TfraImageInfo.btnCloseClick(Sender: Tobject);
Begin
  Visible := False;
End;

Function TfraImageInfo.GetImageIEN: String;
Begin
//if FimageData = nil then result := ''
//else result := FImageData.Mag0;
End;

End.
