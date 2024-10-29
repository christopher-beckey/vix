Unit fmagCapGrpComplete;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging : Study Complete Dialog window.
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
  ExtCtrls,
  Forms,
  Stdctrls,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:Controls, Graphics, Classes, WinProcs, WinTypes, magpositions

Type
  TfrmCapGrpComplete = Class(TForm)
    LbAlign: Tlabel;
    Panel1: Tpanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Panel2: Tpanel;
    Panel3: Tpanel;
    Panel4: Tpanel;
    LbPrompt: Tlabel;
    Label1: Tlabel;
    LbDicom: Tlabel;
    Egroupdesc: TEdit;
    Label2: Tlabel;
    CheckBox1: TCheckBox;
    GroupLongDesc: TMemo;
    Procedure FormCreate(Sender: Tobject);
    Procedure CheckBox1Click(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  frmCapGrpComplete: TfrmCapGrpComplete;

Implementation
Uses
  Magpositions
  ;

{$R *.DFM}

Procedure TfrmCapGrpComplete.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
End;

Procedure TfrmCapGrpComplete.CheckBox1Click(Sender: Tobject);
Begin
  GroupLongDesc.Wordwrap := CheckBox1.Checked;

  If Not GroupLongDesc.Wordwrap Then
    GroupLongDesc.ScrollBars := SsBoth
  Else
    GroupLongDesc.ScrollBars := SsVertical;
End;

Procedure TfrmCapGrpComplete.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

End.
