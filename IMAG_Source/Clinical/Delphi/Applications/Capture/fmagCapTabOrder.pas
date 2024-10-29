Unit FmagCapTabOrder;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Field Tabbing Sequence Dialog.
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
  Controls,
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  Graphics
  ;

//Uses Vetted 20090929:maggut1, Dialogs, Graphics, Messages, Windows, umagutils, SysUtils

Type
  TfrmCapTabOrder = Class(TForm)
    PopupMenu1: TPopupMenu;
    MInTabbingSequence: TMenuItem;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Panel2: Tpanel;
    Panel1: Tpanel;
    PatientFields_200: TImage;
    CaptureButtons_100: TImage;
    SpecFields_400: TImage;
    DescField_300: TImage;
    Panel3: Tpanel;
    SelImage: TImage;
    OkCancel_500: TImage;
    bMoveUp: TBitBtn;
    bMoveDown: TBitBtn;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    Button1: TButton;
    cbSaveAsDefault: TCheckBox;
    Label1: Tlabel;
    MainMenu1: TMainMenu;
    Next1: TMenuItem;
    Next2: TMenuItem;
    Procedure ScrollBox1DragDrop(Sender, Source: Tobject; x, y: Integer);
    Procedure ScrollBox1DragOver(Sender, Source: Tobject; x, y: Integer;
      State: TDragState; Var Accept: Boolean);
    Procedure DescField_300DragDrop(Sender, Source: Tobject; x, y: Integer);
    Procedure PatientFields_200DragOver(Sender, Source: Tobject; x, y: Integer;
      State: TDragState; Var Accept: Boolean);
    Procedure PopupMenu1Popup(Sender: Tobject);
    Procedure PatientFields_200Click(Sender: Tobject);
    Procedure PatientFields_200MouseMove(Sender: Tobject; Shift: TShiftState; x,
      y: Integer);
    Procedure PatientFields_200MouseDown(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure bMoveUpClick(Sender: Tobject);
    Procedure bMoveDownClick(Sender: Tobject);
    Procedure Button1Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure btnOKClick(Sender: Tobject);
    Procedure FormShow(Sender: Tobject);
    Procedure Next2Click(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
  Private
    CurBmp: Integer;
    BmpList: Tlist;
    Procedure SelectNextControl;

    { Private declarations }
  Public
    Procedure Applyfromlist; { Public declarations }
    Procedure SaveSettings;
  End;

Var
  FrmCapTabOrder: TfrmCapTabOrder;
  Timagename: String;
  CurTImage: TImage;

Implementation
Uses
  SysUtils,
  Umagutils8
  ;

{$R *.DFM}

Procedure TfrmCapTabOrder.ScrollBox1DragDrop(Sender, Source: Tobject; x,
  y: Integer);
Begin
  With (Source As TImage) Do
  Begin
    //testmsg('dropped'+name);
    Top := y;
  End;

End;

Procedure TfrmCapTabOrder.ScrollBox1DragOver(Sender, Source: Tobject; x, y: Integer;
  State: TDragState; Var Accept: Boolean);
Begin
  Accept := True;
End;

Procedure TfrmCapTabOrder.DescField_300DragDrop(Sender, Source: Tobject; x, y: Integer);
Begin
  With (Source As TImage) Do
  Begin
    //testmsg('dropped'+name);
    Top := (Sender As TImage).Top + y;
    SelImage.Top := CurTImage.Top;
    SelImage.Height := CurTImage.Height;
  End;

End;

Procedure TfrmCapTabOrder.PatientFields_200DragOver(Sender, Source: Tobject; x, y: Integer;
  State: TDragState; Var Accept: Boolean);
Begin
  Accept := True;
End;

Procedure TfrmCapTabOrder.PopupMenu1Popup(Sender: Tobject);
Begin
  MInTabbingSequence.caption := Timagename;
End;

Procedure TfrmCapTabOrder.PatientFields_200Click(Sender: Tobject);
Begin
  CurTImage := (Sender As TImage);
  With (Sender As TImage) Do
  Begin
    Timagename := Name;
    SelImage.Top := Top;
    SelImage.Height := Height;

  End;
End;

Procedure TfrmCapTabOrder.PatientFields_200MouseMove(Sender: Tobject; Shift: TShiftState; x,
  y: Integer);
Begin
  If Ssleft In Shift Then (Sender As TImage).BeginDrag(False);
End;

Procedure TfrmCapTabOrder.PatientFields_200MouseDown(Sender: Tobject; Button: TMouseButton;
  Shift: TShiftState; x, y: Integer);
Begin
  Timagename := (Sender As TImage).Name;
End;

Procedure TfrmCapTabOrder.SaveSettings;
Var
  i: Integer;
  s: String;
Begin
  ListBox1.Clear;
  ListBox1.Sorted := True;
  ListBox1.Update;
  s := Inttostr(PatientFields_200.Top);
  For i := 0 To 4 - (Length(s)) Do
    s := '0' + s;
  ListBox1.Items.Add(s + '^' + PatientFields_200.Name);

  s := Inttostr(SpecFields_400.Top);
  For i := 0 To 4 - (Length(s)) Do
    s := '0' + s;
  ListBox1.Items.Add(s + '^' + SpecFields_400.Name);

  s := Inttostr(CaptureButtons_100.Top);
  For i := 0 To 4 - (Length(s)) Do
    s := '0' + s;
  ListBox1.Items.Add(s + '^' + CaptureButtons_100.Name);

  s := Inttostr(DescField_300.Top);
  For i := 0 To 4 - (Length(s)) Do
    s := '0' + s;
  ListBox1.Items.Add(s + '^' + DescField_300.Name);

  s := Inttostr(OkCancel_500.Top);
  For i := 0 To 4 - (Length(s)) Do
    s := '0' + s;
  ListBox1.Items.Add(s + '^' + OkCancel_500.Name);

  ListBox2.Items.Assign(ListBox1.Items);
  ListBox1.Sorted := False;
  ListBox1.Update;
  For i := 0 To ListBox1.Items.Count - 1 Do
    ListBox1.Items[i] := MagPiece(ListBox1.Items[i], '^', 2);
End;

Procedure TfrmCapTabOrder.bMoveUpClick(Sender: Tobject);
Begin
  CurTImage.Top := CurTImage.Top - CurTImage.Height - 3;
  CurTImage.Update;
  SelImage.Top := CurTImage.Top;
End;

Procedure TfrmCapTabOrder.bMoveDownClick(Sender: Tobject);
Begin
  CurTImage.Top := CurTImage.Top + CurTImage.Height + 3;
  CurTImage.Update;
  SelImage.Top := CurTImage.Top;
End;

Procedure TfrmCapTabOrder.Button1Click(Sender: Tobject);
Begin
  Applyfromlist;
End;

Procedure TfrmCapTabOrder.Applyfromlist;
Var
  Tmptop, j, i: Integer;
Begin
  Tmptop := -5;
  For i := 0 To ListBox1.Items.Count - 1 Do
  Begin
    j := Strtoint(MagPiece(ListBox1.Items[i], '_', 2));
    Case j Of
      100:
        Begin
          CaptureButtons_100.Top := Tmptop;
          Tmptop := Tmptop + CaptureButtons_100.Height;

        End;
      200:
        Begin
          PatientFields_200.Top := Tmptop;
          Tmptop := Tmptop + PatientFields_200.Height;

        End;
      300:
        Begin
          DescField_300.Top := Tmptop;
          Tmptop := Tmptop + DescField_300.Height;

        End;
      400:
        Begin
          SpecFields_400.Top := Tmptop;
          Tmptop := Tmptop + SpecFields_400.Height;

        End;
      500:
        Begin
          OkCancel_500.Top := Tmptop;
          Tmptop := Tmptop + OkCancel_500.Height;

        End;

    End;

  End;
  SelImage.Top := CurTImage.Top;
End;

Procedure TfrmCapTabOrder.FormCreate(Sender: Tobject);
Begin
  CurTImage := CaptureButtons_100;
  SelImage.Top := CurTImage.Top;
  BmpList := Tlist.Create;
  BmpList.Add(TImage(CaptureButtons_100));
  BmpList.Add(TImage(PatientFields_200));
  BmpList.Add(TImage(DescField_300));
  BmpList.Add(TImage(SpecFields_400));
  BmpList.Add(TImage(OkCancel_500));
  CurBmp := 0;
End;

Procedure TfrmCapTabOrder.btnOKClick(Sender: Tobject);
Begin
  SaveSettings;
  If cbSaveAsDefault.Checked Then
    ModalResult := MrAll
  Else
    ModalResult := MrOK;
End;

Procedure TfrmCapTabOrder.FormShow(Sender: Tobject);
Begin
  btnOK.SetFocus;
End;

Procedure TfrmCapTabOrder.Next2Click(Sender: Tobject);
Begin
  SelectNextControl;
End;

Procedure TfrmCapTabOrder.SelectNextControl;
Var
  i: Integer;
Begin
  If CurBmp = BmpList.Count - 1 Then CurBmp := -1;
  i := CurBmp + 1;
  PatientFields_200Click(TImage(BmpList[i]));
  CurBmp := i;
End;

Procedure TfrmCapTabOrder.FormDestroy(Sender: Tobject);
Begin
  FreeAndNil(BmpList);
End;

End.
