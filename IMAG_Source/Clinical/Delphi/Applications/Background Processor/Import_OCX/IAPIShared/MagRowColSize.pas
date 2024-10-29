Unit MagRowColSize;
    {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:    8/1/2002
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==   unit MagRowColSize;

   Description: Image Viewer Utility window : Allows editing of the Viewer Properties.
   Viewer Properties that are displayed for editing: are properties of TMagLayout.
        Rows, Columns, Maximum Image Count and Lock Image Size

   Objects and Forms in the Appication create instances of TRowColSize.
   The Execute method takes a reference to an instance of TMag4Viewer as a parameter
   This reference gives TRowColSize the ability to enable an Apply method.
   The user can 'Apply' and view the changes before exiting the TRowColSize
   Dialog window.

   ==]
   Note:
   }
(*
        ;; +------------------------------------------------------------------+
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
        ;; +------------------------------------------------------------------+

*)
Interface

Uses
  Buttons,
  cmag4viewer,
  Controls,
  ExtCtrls,
  Forms,
  Menus,
  Spin,
  Stdctrls
  , Classes //117  ?
  ;

//Uses Vetted 20090929:ToolWin, ComCtrls, Dialogs, Graphics, Classes, Messages, Windows, SysUtils

Type
  TRowColSize = Class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btnApply: TBitBtn;
    btnOK: TBitBtn;
    cbAbstracts: TCheckBox;
    cbAutoRedraw: TCheckBox;
    cbClearBeforeAdd: TCheckBox;
    cbdftLockSize: TCheckBox;
    cbDyncol: TCheckBox;
    cbDynrow: TCheckBox;
    cbFixedSize: TCheckBox;
    EdtdftColumn: TEdit;
    EdtdftMaxCount: TEdit;
    EdtdftRow: TEdit;
    Label1: Tlabel;
    Label2: Tlabel;
    LbColumns: Tlabel;
    LbMaxCount: Tlabel;
    LbRows: Tlabel;
    MainMenu1: TMainMenu;
    N1x11: TMenuItem;
    N1x31: TMenuItem;
    N1x41: TMenuItem;
    N2x11: TMenuItem;
    N2x12: TMenuItem;
    N2x21: TMenuItem;
    N2x31: TMenuItem;
    N2x41: TMenuItem;
    N3x11: TMenuItem;
    N3x21: TMenuItem;
    N3x31: TMenuItem;
    N3x41: TMenuItem;
    N4x11: TMenuItem;
    N4x21: TMenuItem;
    N4x31: TMenuItem;
    N4x41: TMenuItem;
    RowCol1: TMenuItem;
    SeColumns: TSpinEdit;
    SeMaxCount: TSpinEdit;
    SeRows: TSpinEdit;
    Procedure BitBtn2Click(Sender: Tobject);
    Procedure btnApplyClick(Sender: Tobject);
    Procedure btnOKClick(Sender: Tobject);
    Procedure cbDyncolClick(Sender: Tobject);
    Procedure cbDynrowClick(Sender: Tobject);
    Procedure cbFixedSizeClick(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure FormCreate(Sender: Tobject);
    Procedure N1x11Click(Sender: Tobject);
    Procedure N1x31Click(Sender: Tobject);
    Procedure N1x41Click(Sender: Tobject);
    Procedure N2x11Click(Sender: Tobject);
    Procedure N2x12Click(Sender: Tobject);
    Procedure N2x21Click(Sender: Tobject);
    Procedure N2x31Click(Sender: Tobject);
    Procedure N2x41Click(Sender: Tobject);
    Procedure N3x11Click(Sender: Tobject);
    Procedure N3x21Click(Sender: Tobject);
    Procedure N3x31Click(Sender: Tobject);
    Procedure N3x41Click(Sender: Tobject);
    Procedure N4x11Click(Sender: Tobject);
    Procedure N4x21Click(Sender: Tobject);
    Procedure N4x31Click(Sender: Tobject);
    Procedure N4x41Click(Sender: Tobject);
    Procedure SeColumnsChange(Sender: Tobject);
    Procedure SeMaxCountChange(Sender: Tobject);
    Procedure SeRowsChange(Sender: Tobject);
  Private
    {   apply changes to the instance of TMag4Viewer }
    Procedure ApplySettingsToViewer;
    Procedure SetMaxMin;
    Procedure SetRowCol(Row, Col: Integer);
    {  determines if any changes have been made }
    Procedure WinModified(Tf: Boolean);
    {  Get and Display MagViewLink Properties for the user to modify}
    Procedure LinkToMagView(Var MagViewLink: TMag4Viewer);
  Public
    { called by any object, Viewer is a valid reference to an Instance of TMag4Viewer}
    Procedure Execute(Viewer: TMag4Viewer);
  End;

Var
  RowColSize: TRowColSize;
  CurViewer: TMag4Viewer;
Implementation
Uses
  SysUtils
  ;

{$R *.DFM}

{
********************************* TRowColSize **********************************
}

Procedure TRowColSize.ApplySettingsToViewer;
Begin
  WinModified(False);
  If CurViewer.LockSize Then CurViewer.LockSize := False;
  Application.Processmessages;

//  CurViewer.AbsWindow := cbAbstracts.checked;
  If cbAbstracts.Checked Then
    CurViewer.ViewStyle := MagViewerViewAbs
  Else
    CurViewer.ViewStyle := MagViewerViewFull;
  Application.Processmessages;
  If CurViewer.MaxCount <> SeMaxCount.Value Then
    CurViewer.MaxCount := SeMaxCount.Value;
  Application.Processmessages;
  CurViewer.SetRowColCount(SeRows.Value, SeColumns.Value);
  Application.Processmessages;
  CurViewer.AutoRedraw := cbAutoRedraw.Checked;
  CurViewer.ClearBeforeAddDrop := cbClearBeforeAdd.Checked;
  Application.Processmessages;
  if CurViewer.LockSize <> cbFixedSize.checked
    then CurViewer.LockSize := cbFixedSize.checked;
  Application.Processmessages;
End;

Procedure TRowColSize.BitBtn2Click(Sender: Tobject);
Begin
  SeRows.Value := Strtoint(EdtdftRow.Text);
  SeColumns.Value := Strtoint(EdtdftColumn.Text);
  SetMaxMin;
  Update;
  SeMaxCount.Value := Strtoint(EdtdftMaxCount.Text);
  cbFixedSize.Checked := cbdftLockSize.Checked;
  ApplySettingsToViewer;
End;

Procedure TRowColSize.btnApplyClick(Sender: Tobject);
Begin
  ApplySettingsToViewer;
End;

Procedure TRowColSize.btnOKClick(Sender: Tobject);
Begin
  ApplySettingsToViewer;
  ModalResult := MrOK;
End;

Procedure TRowColSize.cbDyncolClick(Sender: Tobject);
Begin
  SeColumns.Enabled := Not cbDyncol.Checked
End;

Procedure TRowColSize.cbDynrowClick(Sender: Tobject);
Begin
  SeRows.Enabled := Not cbDynrow.Checked
End;

Procedure TRowColSize.cbFixedSizeClick(Sender: Tobject);
Begin
  WinModified(True);
End;

Procedure TRowColSize.Execute(Viewer: TMag4Viewer);
Var
  Layout: TMagLayout;
Begin
  With TRowColSize.Create(Nil) Do
  Begin
    LinkToMagView(Viewer);
    Try
      Showmodal;
      Application.Processmessages;
    Finally
      Release;
    End;
  End;
End;

Procedure TRowColSize.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  WinModified(False);
End;

Procedure TRowColSize.FormCreate(Sender: Tobject);
Begin
  CurViewer := Nil;
End;

Procedure TRowColSize.LinkToMagView(Var MagViewLink: TMag4Viewer);
Var
  Layout: TMagLayout;
Begin
  CurViewer := MagViewLink;
  SeRows.Value := MagViewLink.RowCount;
  SeColumns.Value := MagViewLink.ColumnCount;
  SeMaxCount.Value := MagViewLink.MaxCount;
//  cbAbstracts.checked := MagViewLink.AbsWindow;
  If cbAbstracts.Checked Then
    CurViewer.ViewStyle := MagViewerViewAbs
  Else
    CurViewer.ViewStyle := MagViewerViewFull;
  cbFixedSize.Checked := MagViewLink.LockSize;
  cbAutoRedraw.Checked := MagViewLink.AutoRedraw;
  cbClearBeforeAdd.Checked := MagViewLink.ClearBeforeAddDrop;
  { layout isn't used yet.  It's for a future versioin. }
  Layout := MagViewLink.DefaultLayout;
  EdtdftRow.Text := Inttostr(Layout.Rows);
  EdtdftColumn.Text := Inttostr(Layout.Columns);
  EdtdftMaxCount.Text := Inttostr(Layout.MaxNumberOfImages);
  cbdftLockSize.Checked := Layout.LockImageState;
  If CurViewer.caption <> '' Then caption := CurViewer.caption + ' settings';
      //lbDefaultLayout.Caption := MagViewLink.GetDefaultLayoutDesc;
    //p8t25
  (* if cbAbstracts.checked then
     begin
       seColumns.enabled := false;
       lbColumns.Enabled := false;
     end;
     *)
  WinModified(False);
End;

Procedure TRowColSize.N1x11Click(Sender: Tobject);
Begin
  SetRowCol(1, 1);
End;

Procedure TRowColSize.N1x31Click(Sender: Tobject);
Begin
  SetRowCol(1, 3);
End;

Procedure TRowColSize.N1x41Click(Sender: Tobject);
Begin
  SetRowCol(1, 4);
End;

Procedure TRowColSize.N2x11Click(Sender: Tobject);
Begin
  SetRowCol(2, 1);
End;

Procedure TRowColSize.N2x12Click(Sender: Tobject);
Begin
  SetRowCol(1, 2);
End;

Procedure TRowColSize.N2x21Click(Sender: Tobject);
Begin
  SetRowCol(2, 2);
End;

Procedure TRowColSize.N2x31Click(Sender: Tobject);
Begin
  SetRowCol(2, 3);
End;

Procedure TRowColSize.N2x41Click(Sender: Tobject);
Begin
  SetRowCol(2, 4);
End;

Procedure TRowColSize.N3x11Click(Sender: Tobject);
Begin
  SetRowCol(3, 1);
End;

Procedure TRowColSize.N3x21Click(Sender: Tobject);
Begin
  SetRowCol(3, 2);
End;

Procedure TRowColSize.N3x31Click(Sender: Tobject);
Begin
  SetRowCol(3, 3);
End;

Procedure TRowColSize.N3x41Click(Sender: Tobject);
Begin
  SetRowCol(3, 4);
End;

Procedure TRowColSize.N4x11Click(Sender: Tobject);
Begin
  SetRowCol(4, 1);
End;

Procedure TRowColSize.N4x21Click(Sender: Tobject);
Begin
  SetRowCol(4, 2);
End;

Procedure TRowColSize.N4x31Click(Sender: Tobject);
Begin
  SetRowCol(4, 3);
End;

Procedure TRowColSize.N4x41Click(Sender: Tobject);
Begin
  SetRowCol(4, 4);
End;

Procedure TRowColSize.SeColumnsChange(Sender: Tobject);
Begin
  WinModified(True);
End;

Procedure TRowColSize.SeMaxCountChange(Sender: Tobject);
Begin
  WinModified(True);
End;

Procedure TRowColSize.SeRowsChange(Sender: Tobject);
Begin
  WinModified(True);
End;

Procedure TRowColSize.SetMaxMin;
Begin
  if ((semaxcount.value) < (seRows.Value * secolumns.Value))
    then seMaxCount.value := (seRows.Value * secolumns.Value);
End;

Procedure TRowColSize.SetRowCol(Row, Col: Integer);
Begin
  SeRows.Value := Row;
  SeColumns.Value := Col;
  If SeMaxCount.Value < (Row * Col) Then SeMaxCount.Value := (Row * Col);
  WinModified(True);
End;

Procedure TRowColSize.WinModified(Tf: Boolean);
Begin
  btnApply.Enabled := Tf;
  btnOK.Enabled := Tf;
End;

End.
