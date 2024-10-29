Unit MuseTestsForPatientu;
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
  Stdctrls,
  Buttons,
  ComCtrls,
  ExtCtrls,
  Maggut1,
  Inifiles,
  Menus,
  Maggmsgu,
  Magpositions,
  MuseDeclarations;

Type
  TMuseTestsForPatient = Class(TForm)
    Panel1: Tpanel;
    PToolbar: Tpanel;
    ListBox1: TListBox;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    bbNext14: TBitBtn;
    Pinfo: Tpanel;
    LbName: Tlabel;
    LbSSN: Tlabel;
    LbSSNdisp: Tlabel;
    bbALL: TBitBtn;
    PopupMenu1: TPopupMenu;
    ToolBar1: TMenuItem;
    Close1: TMenuItem;
    MNext14: TMenuItem;
    MAll: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    LCount: Tlabel;
    Pmsg: Tpanel;
    Procedure bbCancelClick(Sender: Tobject);
    Procedure bbOKClick(Sender: Tobject);
    Procedure bbNext14Click(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure ToolBar1Click(Sender: Tobject);
    Procedure bbALLClick(Sender: Tobject);
    Procedure MAllClick(Sender: Tobject);
    Procedure MNext14Click(Sender: Tobject);
    Procedure ListBox1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure ListBox1Click(Sender: Tobject);
    Procedure PopupMenu1Popup(Sender: Tobject);
    Procedure Close1Click(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
  Private

  Public
    Function Outformat(i: Integer): String;
    Procedure ClearTestList;
    Procedure InitList(Nomore: Boolean);
    Procedure Showtestcount;
    Procedure DisableMore;
    { Public declarations }

  End;

Var

  MuseTestsForPatient: TMuseTestsForPatient;
  //mei_TestsForPatient: Tmei_TestsForPatient;
  TestsList: Tlist;

Implementation

Uses Musetstu,
  MuseListOfPatientsu,
  MuseTestTypeu;

{$R *.DFM}

Var
  Temptestinfoptr: MUSE_TEST_INFORMATION_PTR;
   //mei_TestsForPatient: Tmei_TestsForPatient;

Procedure TMuseTestsForPatient.bbCancelClick(Sender: Tobject); (* Cancel button*)
Begin
  Close;
End;

Procedure TMuseTestsForPatient.bbOKClick(Sender: Tobject);

Begin
  If ListBox1.ItemIndex = -1 Then Exit;

  EKGWin.OpenImage(ListBox1.Items[ListBox1.ItemIndex], ListBox1.ItemIndex);
End;

Procedure TMuseTestsForPatient.bbNext14Click(Sender: Tobject);
Begin
  With EKGWin Do
  Begin
    Showmsgwin('Accessing Next 14 Tests for ''' + LbName.caption + ''' Please Wait...');
    UMoreTests;
    Hidemsgwin;
  End;
  ListBox1.SetFocus;
End;

Procedure TMuseTestsForPatient.FormCreate(Sender: Tobject);
Begin
  GetFormPosition(Self As TForm);
  TestsList := Tlist.Create;
  New(Temptestinfoptr);
End;

Procedure TMuseTestsForPatient.FormClose(Sender: Tobject;
  Var action: TCloseAction);
Begin
  EKGWin.SwitchListDisplay;
  ClearTestList;
End;

Function TMuseTestsForPatient.Outformat(i: Integer): String;
Begin
{turn a 1 digit number into a 2 character string with '0' as first;}

  Result := Inttostr(i);
  If Length(Inttostr(i)) = 1 Then Result := '0' + Inttostr(i);

End;

Procedure TMuseTestsForPatient.DisableMore;
Begin
  bbNext14.Enabled := False;
  bbALL.Enabled := False;
  bbNext14.Update;
  bbALL.Update;
End;

Procedure TMuseTestsForPatient.ToolBar1Click(Sender: Tobject);
Begin
  PToolbar.Visible := Not PToolbar.Visible;
  Pinfo.Visible := PToolbar.Visible;
  ToolBar1.Checked := PToolbar.Visible;
End;

Procedure TMuseTestsForPatient.bbALLClick(Sender: Tobject);
Begin
  With EKGWin Do
  Begin
    Try
      EKGWin.Showmsgwin('Accessing ALL Tests for ''' + LbName.caption + ''' Please Wait...');
      Repeat UMoreTests Until (Not bbNext14.Enabled)
    Except
      Hidemsgwin;
      Maggmsgf.MagMsg('des', 'Error accessing patient tests.', Pmsg);
    End;
    Hidemsgwin;
  End;
End;

Procedure TMuseTestsForPatient.MAllClick(Sender: Tobject);
Begin
  bbALL.Click;
End;

Procedure TMuseTestsForPatient.MNext14Click(Sender: Tobject);
Begin
  bbNext14.Click;
End;

Procedure TMuseTestsForPatient.ListBox1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key <> VK_Return Then Exit;
  EKGWin.OpenImage(ListBox1.Items[ListBox1.ItemIndex], ListBox1.ItemIndex);
  ListBox1.SetFocus;
End;

Procedure TMuseTestsForPatient.ClearTestList;
Begin
  ListBox1.Clear;
  bbNext14.Enabled := False;
  bbALL.Enabled := False;
  LbName.caption := '';
  LbSSN.caption := '';
  LbSSNdisp.caption := '';
  LCount.caption := '#';
End;

Procedure TMuseTestsForPatient.InitList(Nomore: Boolean);
Begin
  Showtestcount;
  ListBox1.Update;
  ListBox1.SetFocus;
  bbNext14.Enabled := True;
  bbALL.Enabled := True;
  If Nomore Then DisableMore;
  ListBox1.ItemIndex := 0;
  ListBox1Click(Self);
End;

Procedure TMuseTestsForPatient.Showtestcount;
Begin
  LCount.caption := Inttostr(ListBox1.Items.Count) + '+';
  LCount.Update;
End;

Procedure TMuseTestsForPatient.ListBox1Click(Sender: Tobject);
Begin
  EKGWin.OpenImage(ListBox1.Items[ListBox1.ItemIndex], ListBox1.ItemIndex);
  ListBox1.SetFocus;
End;

Procedure TMuseTestsForPatient.PopupMenu1Popup(Sender: Tobject);
Begin
  MNext14.Enabled := bbNext14.Enabled;
  MAll.Enabled := bbALL.Enabled;
End;

Procedure TMuseTestsForPatient.Close1Click(Sender: Tobject);
Begin
  Close;
End;

Procedure TMuseTestsForPatient.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

End.
