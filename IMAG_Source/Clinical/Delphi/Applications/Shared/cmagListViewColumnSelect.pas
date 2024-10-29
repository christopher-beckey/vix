Unit cmagListViewColumnSelect;
   {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created: Version 3.0.8
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
[==    unit fmagColumnSelect;
 Description: Imaging List View utility form (Select Visible Columns).
 - Created by TMagListView object to display the list of that object's columns
   and allow user to check/uncheck the visible status.
   Then modify's the columns width in the TmagListView object, setting the
   width to 0 for the columns that the user wants invisible.
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
  CheckLst,
  cMagListView,
  Controls,
  ExtCtrls,
  Forms,
  Stdctrls,
  Classes
  ;

//Uses Vetted 20090929:ComCtrls, Dialogs, Graphics, Classes, SysUtils, Messages, Windows,

Type
  TfrmColumnSelect = Class(TForm)
    chlistColumns: TCheckListBox;
    Label1: Tlabel;
    Panel1: Tpanel;
    btnApply: TBitBtn;
    btnClose: TBitBtn;
    btnOK: TBitBtn;
    btnAll: TBitBtn;
    Procedure FormCreate(Sender: Tobject);
    Procedure btnApplyClick(Sender: Tobject);
    Procedure btnCloseClick(Sender: Tobject);
    Procedure btnOKClick(Sender: Tobject);
    Procedure btnAllClick(Sender: Tobject);
  Private
    FLV: TMagListView;
    Procedure SetVisibleColumns;
    { Private declarations }
  Public
    Procedure DisplayColumns(LV: TMagListView);
  End;

Var
  FrmColumnSelect: TfrmColumnSelect;

Implementation

{$R *.DFM}

Procedure TfrmColumnSelect.FormCreate(Sender: Tobject);
Begin
  chlistColumns.Align := alClient;
End;

Procedure TfrmColumnSelect.btnApplyClick(Sender: Tobject);
Begin
  SetVisibleColumns;
End;

Procedure TfrmColumnSelect.SetVisibleColumns;
Var
  i: Integer;
Begin
  FLV.Visible := False;
  Try
    For i := 0 To chlistColumns.Items.Count - 1 Do
    Begin
      If Not chlistColumns.Checked[i] Then
      Begin
        FLV.Columns[i].Width := 0;
        FLV.FColVisible[i] := False;
      End
      Else
      Begin
        FLV.FColVisible[i] := True;
        If (FLV.Columns[i].Width = 0) Then FLV.Columns[i].Width := FLV.FColWidth[i] + 10;
      End;
    End;
  Finally
    FLV.Visible := True;
  End;
End;

Procedure TfrmColumnSelect.DisplayColumns(LV: TMagListView);
Var
  i: Integer;
Begin
  FLV := LV;
  chlistColumns.Items.Clear;
  For i := 0 To FLV.Columns.Count - 1 Do
  Begin
    chlistColumns.Items.Add(FLV.Columns[i].caption);
    chlistColumns.Checked[i] := (FLV.Columns[i].Width > 0);
  End;
End;

Procedure TfrmColumnSelect.btnCloseClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TfrmColumnSelect.btnOKClick(Sender: Tobject);
Begin
  SetVisibleColumns;
End;

Procedure TfrmColumnSelect.btnAllClick(Sender: Tobject);
Var
  i: Integer;
Begin
  For i := 0 To chlistColumns.Items.Count - 1 Do
  Begin
    chlistColumns.Checked[i] := True;
  End;
  SetVisibleColumns;
End;

End.
