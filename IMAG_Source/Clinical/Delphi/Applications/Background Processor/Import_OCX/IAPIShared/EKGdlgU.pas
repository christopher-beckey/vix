Unit EKGdlgU;
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
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Stdctrls;

Type
  TfEKGdlg = Class(TForm)
    cbShowDottedGridDlg: TCheckBox;
    bYes: TButton;
    bNo: TButton;
    Memo1: TMemo;
    Label1: Tlabel;
    Procedure bYesClick(Sender: Tobject);
    Procedure bNoClick(Sender: Tobject);
    Procedure cbShowDottedGridDlgClick(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FEKGdlg: TfEKGdlg;
  PrintDottedGrid: Boolean;
  ShowDottedGridDlg: Boolean;

Implementation

Uses MuseTestTypeu;

{$R *.DFM}

Procedure TfEKGdlg.bYesClick(Sender: Tobject);
Begin
  PrintDottedGrid := True;
  FEKGdlg.Close;
End;

Procedure TfEKGdlg.bNoClick(Sender: Tobject);
Begin
  PrintDottedGrid := False;
  FEKGdlg.Close;
End;

Procedure TfEKGdlg.cbShowDottedGridDlgClick(Sender: Tobject);
Begin
  If cbShowDottedGridDlg.Checked Then
    ShowDottedGridDlg := False
  Else
    ShowDottedGridDlg := True;
End;

Procedure TfEKGdlg.FormShow(Sender: Tobject);
Begin
  bYes.SetFocus;
End;

End.
