unit fmagRadHeaderProgress;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
        ;;  Property of the US Government.
        ;;  WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
        ;;  No permission to copy or redistribute this software is given.
        ;;  Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;
        ;;  Date created: May 2013
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: This window is displayed when text files are being
        ;;    loaded to provide feedback to the user. It also allows the user
        ;;    to cancel the text file loading and disable scout viewing.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

Type
  TMagImageHeaderLoadingCancelClickEvent = Procedure(Sender : TObject) of object;

type
  TfrmRadHeaderProgress = class(TForm)
    lblStatus: TLabel;
    ProgressBar1: TProgressBar;
    btnCancel: TButton;
    lblDescription: TLabel;
    procedure btnCancelClick(Sender: TObject);
  private
    FImageHeaderLoadingCancelClick : TMagImageHeaderLoadingCancelClickEvent;
  public
    Procedure ReceiveImageHeaderLoadedEvent(Current, Total : integer);
    Property OnImageHeaderLoadingCancelClick : TMagImageHeaderLoadingCancelClickEvent read FImageHeaderLoadingCancelClick write FImageHeaderLoadingCancelClick;
  end;

implementation

{$R *.dfm}

procedure TfrmRadHeaderProgress.btnCancelClick(Sender: TObject);
begin
  if assigned(FImageHeaderLoadingCancelClick) then
    FImageHeaderLoadingCancelClick(self);
end;

Procedure TfrmRadHeaderProgress.ReceiveImageHeaderLoadedEvent(Current, Total : integer);
begin
  { if current >= total then this is done and can be closed }
  if current >= total then
    self.close
  else
  begin
    if not self.Visible then
      self.Show;
    // only enable button if it can work
    btnCancel.Enabled := assigned(FImageHeaderLoadingCancelClick);
    lblStatus.Caption := inttostr(Current) + ' of ' + inttostr(Total);
    ProgressBar1.Max := total;
    ProgressBar1.Position := current;
    Application.ProcessMessages;
  end;
end;

end.
