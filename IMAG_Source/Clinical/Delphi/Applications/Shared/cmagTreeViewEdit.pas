Unit cmagTreeViewEdit;
   {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
[==  unit fmagTreeViewEdit;
 Called
 Description: Imaging Tree View Edit dialog.
 This form provides a way for the user to select any property of Image Data (from the columns in the cMagImageList component)
 to create their own sequence of Tree Nodes.
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
  cMagImageList,
  Controls,
  ExtCtrls,
  Forms,
  Stdctrls,
  Graphics
  ;

//Uses Vetted 20090929:Dialogs, Graphics, Messages, Windows, umagutils, SysUtils

Type
  TfrmTreeViewEdit = Class(TForm)
    Panel1: Tpanel;
    Label1: Tlabel;
    Label2: Tlabel;
    Label3: Tlabel;
    Label4: Tlabel;
    Panel4: Tpanel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    ListBox1: TListBox;
    Splitter3: TSplitter;
    Label5: Tlabel;
    Label10: Tlabel;
    Label11: Tlabel;
    Image1: TImage;
    Procedure Label4DragDrop(Sender, Source: Tobject; x, y: Integer);
    Procedure Label4DragOver(Sender, Source: Tobject; x, y: Integer;
      State: TDragState; Var Accept: Boolean);
    Procedure Label1EndDrag(Sender, Target: Tobject; x, y: Integer);
    Procedure btnOKClick(Sender: Tobject);
    Procedure ListBox1MouseUp(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure Label1DblClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
  Private
    FNodeStr: String;
    Procedure LoadLabel(LB: Tlabel);

    { Private declarations }
  Public

    Procedure Execute(Var Nodestr: String; Maglist: TMagImageList);
    { Public declarations }
  End;

Var
  FrmTreeViewEdit: TfrmTreeViewEdit;

Implementation
Uses
  SysUtils,
  Umagutils8
  ;

{$R *.DFM}

Procedure TfrmTreeViewEdit.Execute(Var Nodestr: String; Maglist: TMagImageList);
Var
  i: Integer;
  ColHeaders: String;
Begin

  With TfrmTreeViewEdit.Create(Nil) Do
  Begin
    FNodeStr := '';

    ListBox1.Items.Clear;
    Label1.Tag := 0;
    Label1.caption := '<              >'; //label1.Color := clblue;
    Label2.Tag := 0;
    Label2.caption := '<              >'; //label2.Color := clbtnface;
    Label3.Tag := 0;
    Label3.caption := '<              >'; //label3.Color := clbtnface;
    Label4.Tag := 0;
    Label4.caption := '<              >'; //label4.Color := clbtnface;
    ColHeaders := MagPiece(Maglist.BaseList[0], '|', 1);

    For i := 1 To Maglength(ColHeaders, '^') Do //MagListView1.Columns.Count - 1 do
    Begin

      //listbox1.items.Add(Maglistview1.columns[i].caption); //+ '-'+inttostr(i+1)); //
      ListBox1.Items.Add(MagPiece(MagPiece(ColHeaders, '^', i), '~', 1));
    End;

    If Showmodal = MrOK Then
    Begin
      Nodestr := FNodeStr;

    End
    Else
    Begin

      Nodestr := '';
    End;
    Free;
  End;
  //
End;

Procedure TfrmTreeViewEdit.Label4DragDrop(Sender, Source: Tobject; x, y: Integer);
Begin
  LoadLabel(Tlabel(Sender));
End;

Procedure TfrmTreeViewEdit.Label4DragOver(Sender, Source: Tobject; x, y: Integer;
  State: TDragState; Var Accept: Boolean);
Begin
  Accept := True;
End;

Procedure TfrmTreeViewEdit.Label1EndDrag(Sender, Target: Tobject; x, y: Integer);
Begin
  If Target = Nil Then
  Begin
    Tlabel(Sender).caption := '<              >';
    Tlabel(Sender).Tag := 0;
  End;
End;

Procedure TfrmTreeViewEdit.LoadLabel(LB: Tlabel);
Begin
(*
  TLabel(sender).caption := listbox1.Items[listbox1.itemindex];
Tlabel(sender).tag := listbox1.ItemIndex + 1;
*)
  LB.caption := ListBox1.Items[ListBox1.ItemIndex];
  LB.Tag := ListBox1.ItemIndex + 1;
End;

Procedure TfrmTreeViewEdit.btnOKClick(Sender: Tobject);
Begin
//  panel3.visible := false;

//magtreeview1.LoadIndexListFromMagImageList(magimagelist1,'type-8,class-7');
  If Label1.Tag = 0 Then Exit;
  FNodeStr := Label1.caption + '-' + Inttostr(Label1.Tag);
  If Label2.Tag <> 0 Then
    FNodeStr := FNodeStr + ',' +
      Label2.caption + '-' + Inttostr(Label2.Tag);
  If Label3.Tag <> 0 Then
    FNodeStr := FNodeStr + ',' + Label3.caption + '-' + Inttostr(Label3.Tag);
  If Label4.Tag <> 0 Then
    FNodeStr := FNodeStr + ',' + Label4.caption + '-' + Inttostr(Label4.Tag);

//  magtreeview1.LoadIndexListFromMagImageList(magimagelist1, str);
//  magtreeview1.AlphaSort;

End;

Procedure TfrmTreeViewEdit.ListBox1MouseUp(Sender: Tobject;
  Button: TMouseButton; Shift: TShiftState; x, y: Integer);
Begin
  If ListBox1.ItemIndex <> -1 Then
  Begin
    If Label1.Tag = 0 Then
      LoadLabel(Label1)
    Else
      If Label2.Tag = 0 Then
        LoadLabel(Label2)
      Else
        If Label3.Tag = 0 Then
          LoadLabel(Label3)
        Else
          If Label4.Tag = 0 Then
            LoadLabel(Label4);
  End;
End;

Procedure TfrmTreeViewEdit.Label1DblClick(Sender: Tobject);
Begin
  Tlabel(Sender).caption := '<              >';
  Tlabel(Sender).Tag := 0;
End;

Procedure TfrmTreeViewEdit.FormCreate(Sender: Tobject);
Begin
  Panel1.Align := alClient;
End;

End.
