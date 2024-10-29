Unit FmagDoNotClear;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging 'Do Not Clear' i.e. 'Hold Value' dialog window.
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
  CheckLst,
  Classes,
  cMagLabelNoClear,
  Forms,
  Stdctrls,
  Controls
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, SysUtils, Messages, Windows,

Type
  TfrmDoNotClear = Class(TForm)
    LstNoClear: TCheckListBox;
    Label5: Tlabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure btnOKClick(Sender: Tobject);
  Private
    FlistNoClear: Tlist;

    Procedure InitNoClearChecks;
    { Private declarations }
  Public
    Procedure AddItem(Magnoclr: TmagLabelNoClear);
    Procedure ClearItems;
  End;

Var
  FrmDoNotClear: TfrmDoNotClear;

Implementation

{$R *.DFM}

Procedure TfrmDoNotClear.AddItem(Magnoclr: TmagLabelNoClear);
Begin
  FlistNoClear.Add(Magnoclr);
End;

Procedure TfrmDoNotClear.ClearItems;
Begin
  FlistNoClear.Clear;
End;

Procedure TfrmDoNotClear.InitNoClearChecks;
Var
  i: Integer;
Begin
  LstNoClear.Items.Clear; //WPR HOLD
  // FlistNoClear is updated by calls to AddItem.  From main window
  For i := 0 To FlistNoClear.Count - 1 Do
  Begin
    LstNoClear.Items.Add(TmagLabelNoClear(FlistNoClear[i]).caption);
    LstNoClear.Checked[i] := TmagLabelNoClear(FlistNoClear[i]).NoClear;
  End;
End;

Procedure TfrmDoNotClear.FormCreate(Sender: Tobject);
Begin
  FlistNoClear := Tlist.Create;
End;

Procedure TfrmDoNotClear.FormDestroy(Sender: Tobject);
Begin
  FlistNoClear.Free;
End;

Procedure TfrmDoNotClear.FormShow(Sender: Tobject);
Begin
  InitNoClearChecks;
End;

Procedure TfrmDoNotClear.btnOKClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To LstNoClear.Items.Count - 1 Do //WPR HOLD
  Begin
    // Setting the value fo the NoClear property, shows/hides the associated Glyph
    TmagLabelNoClear(FlistNoClear[i]).NoClear := LstNoClear.Checked[i];
  End;

End;

End.
