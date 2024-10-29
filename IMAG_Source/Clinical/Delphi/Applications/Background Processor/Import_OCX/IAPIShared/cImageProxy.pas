Unit cImageProxy;
  {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
 [==    unit cImageProxy;
 Description:  Image Place holder used by the TMag4Viewer component
 TImageProxy is instantiated by TMag4Viewer Component as PlaceHolder for Image.
 Used mainly by Abstracts Viewer as a way to have a complete list of images without
 the need to display them all. On a ReAlign or Refresh, all proxies that are visible
 are replaced with their image. Proxies that are not visible, and have an associated
 image will delete the image and conserve memory. Designed as a way to reduce long
 waits for a group of images to load, and as a way for the user of any workstation
 to reduce the amount of needed memory, if memory is at a premium.

 TImageProxy has properties of TimageData and TMag4VGear.  This gives the Proxy
 all needed information about the Image.  ==]
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
  cMag4Vgear,
  Stdctrls,
  UMagClasses
  ;

//Uses Vetted 20090929:Dialogs, Forms, Controls, Graphics, SysUtils, Messages, Windows,

Type
  TImageProxy = Class(Tlabel)
  Private
    FImageData: TImageData;
    Floadindex: Integer;
    FImage: TMag4VGear;
   {TODO -cPonder: for future, make use of the WMPaint message to refresh the image, won't
     need to loop through the list of proxies, determine which are visible, then
     display the image, code connected to WMPaint event, would handle it. }
   // procedure WMPaint(var Message: TWMPaint); message WM_PAINT; { Private declarations }

  Protected
    { Protected declarations }
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override; { Public declarations }

        { Following properties are Public because the MagViewer needs access,
          not Published because they are set dynamically, never at design time }
    Property ImageData: TImageData Read FImageData Write FImageData;
        { index of the proxy in the FproxyList}
    Property Loadindex: Integer Read Floadindex Write Floadindex;
        {Reference to the Image Object.}
    Property Image: TMag4VGear Read FImage Write FImage; {==}
  Published

  End;

Procedure Register;

Implementation

Procedure Register;
Begin
  RegisterComponents('Imaging', [TImageProxy]);
End;

{ TImageProxy }

Constructor TImageProxy.Create(AOwner: TComponent);
Begin
  Inherited;
  Height := 30;
  Width := 30;
  Top := 10;
  Left := 10;
  caption := '<image description>';
  AutoSize := False;
  Wordwrap := True;
  Layout := TlCenter; //Layout := tlBottom;
  alignment := TaCenter; //alignment := taleftjustify;
  (* color not used.  It was a contributor to the slow loading *)
  //color := clwhite;
  Visible := False;

  //
End;

Destructor TImageProxy.Destroy;
Begin
  Inherited;
//
End;

{TODO -cPonder: Maybe make use of WMPaint event later.  needs researched.}
(*procedure TImageProxy.WMPaint(var Message: TWMPaint);
begin
//showmessage('wmpaint');
  paint;
// How to tell if the Image needs refreshed.  that it just came into view.
// else we will refresh or redisplay the image repeatedly as user scrolls.
end;
  *)
End.
