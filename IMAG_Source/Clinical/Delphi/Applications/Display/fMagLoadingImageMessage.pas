Unit FMagLoadingImageMessage;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  12/2000
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==    unit fMagLoadingImageMessage;
   Description: frmMagLoadingImageMessage is a Utility form used by
   Tmag4Viewer to display information during the process of loading a list
   of images into the viewer.
   The window (frmMagLoadingImageMessage) allows the user to stop the loading
   of abstracts or images before the entire list is loaded.
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
  Controls,
  Classes
  ;

//Uses Vetted 20090929:Gauges, Dialogs, Controls, Graphics, Classes, Messages, Windows, activex, SysUtils

Type
  TfrmLoadingImageMessage = Class(TForm)
    bbCancel: TBitBtn;
    LbImageResolution: Tlabel;
    LbImagename: Tlabel;
    Label2: Tlabel;
    Lbnumbers: Tlabel;
    TimerShow: TTimer;
    Procedure bbCancelClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormCreate(Sender: Tobject);
    Procedure TimerShowTimer(Sender: Tobject);
  Private
    Procedure ShowTheForm;

  Public
    RequestToStopLoading: Boolean;
        {       Delays the window from opening for milsec milliseconds.}
    Procedure SetDelay(Milsec: Integer);
        {       initialize with Number of Images that are being loaded.}
    Procedure Init(Count: Integer);
        {       after each image, update the information displayed.
                s: filename
                cur : current # of image being loaded.
                firstnum : number of first image that was loaded.
                lastnum : number of last image that will be loaded.
                totalimages : total number of images that will be loaded.
                i.e. 'loading  5 to 12 of 24 images.'
                     ' # 6 Image description' }
    Procedure UpdStatus(s: String; cur, Firstnum, Lastnum, Totalimages: Integer);
        {       update the progress bar.}
  End;

Var
  FrmLoadingImageMessage: TfrmLoadingImageMessage;

Implementation
Uses
  ActiveX,
  SysUtils
  ;

{$R *.DFM}

Procedure TfrmLoadingImageMessage.bbCancelClick(Sender: Tobject);
Begin
  Self.RequestToStopLoading := True;
  Self.Update;
End;

Procedure TfrmLoadingImageMessage.Init(Count: Integer);
Begin
  Lbnumbers.caption := '';
  LbImagename.caption := '';
  Lbnumbers.Update;
  LbImagename.Update;
  If (Left + Width) > Screen.Width Then
    Left := (Screen.Width - Width);
  If (Top + Height) > Screen.Height Then
    Top := (Screen.Height - Height);
End;

Procedure TfrmLoadingImageMessage.UpdStatus(s: String; cur, Firstnum, Lastnum, Totalimages: Integer);
Begin
  Lbnumbers.caption := Inttostr(Firstnum + 1) + '  to  ' + Inttostr(Lastnum) + '  of  ' + Inttostr(Totalimages);
  LbImagename.caption := Inttostr(cur + 1) + '   ' + s;
  If (Not Self.Visible) Then
    If (Not Self.RequestToStopLoading) Then Self.TimerShow.Enabled := True;
End;

Procedure TfrmLoadingImageMessage.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  TimerShow.Enabled := False;
End;

Procedure TfrmLoadingImageMessage.FormCreate(Sender: Tobject);
Begin
  CoInitialize(Nil);
  RequestToStopLoading := False;
End;

Procedure TfrmLoadingImageMessage.SetDelay(Milsec: Integer);
Begin
  TimerShow.Interval := Milsec;
End;

Procedure TfrmLoadingImageMessage.TimerShowTimer(Sender: Tobject);
Begin
  TimerShow.Enabled := False;
  ShowTheForm;
End;

Procedure TfrmLoadingImageMessage.ShowTheForm;
Begin
  Formstyle := Fsstayontop;
  Visible := True;
  Update;
End;

End.
