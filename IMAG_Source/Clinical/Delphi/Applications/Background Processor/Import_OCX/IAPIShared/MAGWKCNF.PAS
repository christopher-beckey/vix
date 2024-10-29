Unit Magwkcnf;

Interface

Uses
  Classes,
  ComCtrls,
  Controls,
  ExtCtrls,
  Forms,
  Inifiles,
  Menus,
  Messages,
  Stdctrls,
  ImgList,
  ToolWin
  ;

//Uses Vetted 20090929:ImgList, ToolWin, Tabs, Buttons, Graphics, WinProcs, magguini, MagWrksMemou, Dialogs, SysUtils, WinTypes

Type
  TMagWrksf = Class(TForm)
    Panel2: Tpanel;
    Panel4: Tpanel;
    Panel5: Tpanel;
    Panel6: Tpanel;
    Label3: Tlabel;
    Le2: Tlabel;
    Label2: Tlabel;
    cb1: TComboBox;
    E2: TEdit;
    Panel1: Tpanel;
    Rbtrue: TRadioButton;
    Rbfalse: TRadioButton;
    Lsection: Tlabel;
    Lb1: TListBox;
    ToolBar1: TToolBar;
    Panel7: Tpanel;
    Splitter1: TSplitter;
    Sectionlist: TListBox;
    btnSave: TToolButton;
    btnCancel: TToolButton;
    ImageList1: TImageList;
    Label1: Tlabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    MnuSave: TMenuItem;
    MnuExit: TMenuItem;
    Help1: TMenuItem;
    MnuContents: TMenuItem;
    MnuAbout: TMenuItem;
    PopupMenu1: TPopupMenu;
    AllTrueFalseTRUE1: TMenuItem;
    AllTrueFalseFALSE1: TMenuItem;
    ToolButton2: TToolButton;
    N1: TMenuItem;
    Procedure FormClose(Sender: Tobject; Var action: TCloseAction);
    Procedure Lb1Click(Sender: Tobject);
    Procedure E2Exit(Sender: Tobject);
    Procedure cb1Click(Sender: Tobject);
    Procedure E2KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure RbfalseClick(Sender: Tobject);
    Procedure RbtrueClick(Sender: Tobject);
    Procedure Updatewin(Sender: Tobject);
    Function LoadIniFile(Inifile: String): Boolean;
    Procedure OKBtnClick(Sender: Tobject);
    Procedure BitBtn1Click(Sender: Tobject);
    Procedure Lb1DblClick(Sender: Tobject);
    Procedure SectionlistClick(Sender: Tobject);
    Procedure btnSaveClick(Sender: Tobject);
    Procedure btnCancelClick(Sender: Tobject);
    Procedure FormPaint(Sender: Tobject);
    Procedure ToolButton4Click(Sender: Tobject);
    Procedure MnuContentsClick(Sender: Tobject);
    Procedure MnuSaveClick(Sender: Tobject);
    Procedure MnuExitClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure MnuAboutClick(Sender: Tobject);
    Procedure AllTrueFalseTRUE1Click(Sender: Tobject);
    Procedure AllTrueFalseFALSE1Click(Sender: Tobject);
  Private
    FiniFile: TIniFile;
    FiniFileName: String;
    Fopenedonce: Boolean;
    FChanges: Boolean;
    FChangesSaved: Boolean;
    Procedure WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
    Procedure CancelChanges;
    Procedure ShowHelp;
    Procedure SaveChanges;
    Procedure ChangeUpdate(Value: Boolean);

   { Private declarations }
  Public
    Function Execute(Inifile: String): Boolean; { Public declarations }
  End;

Var
  MagWrksf: TMagWrksf;
Implementation

Uses
  Dialogs,
  SysUtils,
  WinTypes

  //imaging
  ,
  FMagAbout
  ,
  Magguini
  ,
  MagWrksMemou

  ;

{$R *.DFM}

Function TMagWrksf.LoadIniFile(Inifile: String): Boolean;
Var
  i: Integer;
Begin

  FiniFile := TIniFile.Create(Inifile);
  Try
    ;
    Sectionlist.Items.Clear;
    ChangeUpdate(False);
    MagWrksmemo.Memo1.Lines.Clear;
    MagWrksmemo.Memo1.Lines.LoadFromFile(Inifile);
    For i := 0 To MagWrksmemo.Memo1.Lines.Count - 1 Do
    Begin
      If Copy(MagWrksmemo.Memo1.Lines[i], 1, 1) = ';' Then Continue;
      If Copy(MagWrksmemo.Memo1.Lines[i], 1, 1) = '#' Then Continue;
      If Copy(MagWrksmemo.Memo1.Lines[i], 1, 1) = '[' Then
      Begin
        If Lowercase(Copy(MagWrksmemo.Memo1.Lines[i], 2, 6)) = 'choice' Then Continue;

        Sectionlist.Items.Add(Copy(MagWrksmemo.Memo1.Lines[i], 2, Length(MagWrksmemo.Memo1.Lines[i]) - 2));
      End;
    End;
    Sectionlist.ItemIndex := 0;
    FiniFile.Free;

//  FiniFile.readsectionvalues(Sectionlist.items[0],lb1.items);
  Except
    On EFOpenError Do
    Begin
      Messagedlg('Can''t Open File ' + Inifile, MtWarning, [Mbok], 0);
      LoadIniFile := False;
      FiniFile.Free;
      Exit;
    End;
  End; {try}
  SectionlistClick(Self);
  LoadIniFile := True;
  caption := 'Imaging Workstation Configuration:  ' + FiniFileName;

End;

Procedure TMagWrksf.Updatewin(Sender: Tobject);
Var
  Item: Integer;
Begin

{cb1.clear;
le2.clear;
e2.clear;
cb1.clear;}
{rbfalse.checked := false;
rbtrue.checked := false;}
  Item := Lb1.ItemIndex;
  FiniFile := TIniFile.Create(FiniFileName);
  FiniFile.ReadSectionValues(Sectionlist.Items[Sectionlist.ItemIndex], Lb1.Items);
  If Item > -1 Then Lb1.ItemIndex := Item;
  FiniFile.Free;
End;

Procedure TMagWrksf.FormClose(Sender: Tobject; Var action: TCloseAction);
Begin
  If FChanges Then
  Begin
    Case Messagedlg('Do you want to save the changes you made ? ', MtWarning, Mbyesnocancel, 0)
      Of
      MrYes: //SaveChanges ;
        Begin
       { nothing to save, saves are done instantly.
            but flag is needed to return Boolean result; }
          FChangesSaved := True;
        End;
      MrNo: //CancelChanges;
        Begin
          MagWrksmemo.Memo1.Lines.SaveToFile(FiniFileName);
        End;

      MrCancel: action := caNone;
    End;
  End;

 // FiniFile.free;
End;

Procedure TMagWrksf.Lb1Click(Sender: Tobject);
Var
  s, XID, XVal, Xsec, Stcat: String;
  i: Integer;
  Tst: Tstringlist;
Begin
  Tst := Tstringlist.Create;
  s := Lb1.Items[Lb1.ItemIndex];
  i := Pos('=', s);
  XID := Copy(s, 1, i - 1);
  Le2.caption := XID;
  XVal := Copy(s, i + 1, Length(s));
  Xsec := Sectionlist.Items[Sectionlist.ItemIndex];

  Stcat := 'choice' + '_' + Xsec + '_' + XID;
  FiniFile := TIniFile.Create(FiniFileName);
  FiniFile.ReadSectionValues(Stcat, Tst);
  If Tst.Count > 1 Then
  Begin
    cb1.Clear;
    For i := 0 To Tst.Count - 1 Do
    Begin
      cb1.Items.Add(Copy(Tst.Strings[i], Pos('=', Tst.Strings[i]) + 1,
        Length(Tst.Strings[i])));

    End;
      {cb1.items := tst;}
    Panel1.Visible := False;
    E2.Visible := False;
    cb1.Visible := True;
    cb1.Text := XVal;
    {  cb1.setfocus; }
    Exit;
  End;
  If (Uppercase(XVal) = 'TRUE') Or (Uppercase(XVal) = 'FALSE') Then
  Begin
    cb1.Visible := False;
    Panel1.Visible := True;
{   panel1.setfocus; }
    E2.Visible := False;
    If Uppercase(XVal) = 'TRUE' Then
    Begin
      Rbfalse.Checked := False;
      Rbtrue.Checked := True;
    End
    Else
    Begin
      Rbtrue.Checked := False;
      Rbfalse.Checked := True;
    End;
    Exit;
  End;
  cb1.Visible := False;
  Panel1.Visible := False;
  E2.Text := XVal;
  E2.Visible := True;
{e2.setfocus;}
  Tst.Free;
  FiniFile.Free;
End;

Procedure TMagWrksf.E2Exit(Sender: Tobject);
Begin
  If E2.Modified Then
  Begin
    ChangeUpdate(True);
    FiniFile := TIniFile.Create(FiniFileName);
    FiniFile.Writestring(Sectionlist.Items[Sectionlist.ItemIndex], Le2.caption, E2.Text);
    E2.Modified := False;
    FiniFile.Free;
    Updatewin(Self);

  End;
End;

Procedure TMagWrksf.cb1Click(Sender: Tobject);
Begin
  ChangeUpdate(True);
  FiniFile := TIniFile.Create(FiniFileName);
  FiniFile.Writestring(Sectionlist.Items[Sectionlist.ItemIndex], Le2.caption, cb1.Text);
  FiniFile.Free;
  Updatewin(Self);

End;

Procedure TMagWrksf.E2KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key <> VK_Return Then Exit;
  If E2.Modified Then
  Begin
    ChangeUpdate(True);
    FiniFile := TIniFile.Create(FiniFileName);
    FiniFile.Writestring(Sectionlist.Items[Sectionlist.ItemIndex], Le2.caption, E2.Text);
    E2.Modified := False;
    FiniFile.Free;
    Updatewin(Self);
  End;
End;

Procedure TMagWrksf.RbfalseClick(Sender: Tobject);
Begin
  If Rbfalse.Checked = True Then
  Begin
    ChangeUpdate(True);
    FiniFile := TIniFile.Create(FiniFileName);
    FiniFile.Writestring(Sectionlist.Items[Sectionlist.ItemIndex], Le2.caption, 'FALSE');
    FiniFile.Free;
    Updatewin(Self);
  End;
End;

Procedure TMagWrksf.RbtrueClick(Sender: Tobject);
Begin
  If Rbtrue.Checked = True Then
  Begin
    ChangeUpdate(True);
    FiniFile := TIniFile.Create(FiniFileName);
    FiniFile.Writestring(Sectionlist.Items[Sectionlist.ItemIndex], Le2.caption, 'TRUE');
    FiniFile.Free;
    Updatewin(Self);
  End;
End;

Procedure TMagWrksf.OKBtnClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TMagWrksf.BitBtn1Click(Sender: Tobject);
Begin
  Application.HelpFile := 'magsys.hlp';
  Application.HelpCommand(Help_Contents, 0);
End;

Procedure TMagWrksf.Lb1DblClick(Sender: Tobject);
Begin
  If Panel1.Visible Then
    If Rbfalse.Checked Then
      Rbtrue.Checked := True
    Else
      Rbfalse.Checked := True;
End;

Procedure TMagWrksf.WMGetMinMaxInfo(Var Message: TWMGetMinMaxInfo);
Var
  Hy, Wx: Integer;
Begin
  Hy := Trunc(250 * (Pixelsperinch / 96));
  Wx := Trunc(525 * (Pixelsperinch / 96));

  With Message.Minmaxinfo^ Do
  Begin
    PtMinTrackSize.x := Wx;
    PtMinTrackSize.y := Hy;
  End;
  Message.Result := 0;
  Inherited;

End;

Procedure TMagWrksf.SectionlistClick(Sender: Tobject);
Begin
{magscfg.update;}
  Panel1.Visible := False;
  cb1.Visible := False;
  E2.Visible := False;
  Lb1.Clear;
  Le2.caption := '';
  E2.Clear;
  cb1.Clear;
  Panel1.Visible := False;
  Rbtrue.Checked := False;
  Rbfalse.Checked := False;
  Lsection.caption := Sectionlist.Items[Sectionlist.ItemIndex];
  FiniFile := TIniFile.Create(FiniFileName);
  FiniFile.ReadSectionValues(Sectionlist.Items[Sectionlist.ItemIndex], Lb1.Items);
  FiniFile.Free;
{lb1.setfocus;  }
End;

Procedure TMagWrksf.ShowHelp;
Begin
  Application.HelpFile := ExtractFilePath(Application.ExeName) + '\magwrks.hlp';
  // 'd:\dev\delphi4\mag system tools\magwrks.hlp';
//Application.HelpJump('Workstation_Configuration_Window');

  Application.HelpContext(7);
End;

Procedure TMagWrksf.btnCancelClick(Sender: Tobject);
Begin
  CancelChanges;
End;

Procedure TMagWrksf.CancelChanges;
Begin
  If FChanges Then
  Begin
    Try

      ChangeUpdate(False);
      MagWrksmemo.Memo1.Lines.SaveToFile(FiniFileName);

      LoadIniFile(FiniFileName);

    Except
      On e: Exception Do 
       //Showmessage(e.Message);
         Messagedlg(e.message, MtWarning, [Mbok], 0);
    End;
  End;
End;

Procedure TMagWrksf.ChangeUpdate(Value: Boolean);
Begin
  FChanges := Value;
  btnSave.Enabled := Value;
  btnCancel.Enabled := Value;
  MnuSave.Enabled := Value;
End;

Procedure TMagWrksf.FormPaint(Sender: Tobject);
Begin
  If Not Fopenedonce Then
  Begin

    Fopenedonce := True;
        { This form can is either a seperate application, or opened Modally
            from Display and/or Capture.
          If Opened Modally, FIniFileName is already set}
    If (ParamCount = 0) And (Not (FsModal In FormState)) Then
    Begin
      Messagedlg('This application can only be run from ' + #13 +
        ' the Imaging System SiteManager window',
        Mtconfirmation, [Mbok], 0);
      MagWrksf.Close;
      Exit;
    End;
    If ((ParamCount > 0) And (Not (FsModal In FormState))) Then FiniFileName := ParamStr(1);
    If (FiniFileName = 'letsdoit') Then FiniFileName := '';
    If FiniFileName = '' Then FiniFileName := FindConfigFile;
    If Not FileExists(FiniFileName) Then
    Begin
      Messagedlg('Can''t find file : ' + FiniFileName, Mtinformation, [Mbok], 0);
      Close;
    End
    Else
    Begin
      LoadIniFile(FiniFileName);
           // if (pos('mag', FiniFileName) = 0) then caption := 'Imaging .INI File Editor ' + FiniFileName;
    End;

  End;
End;

Procedure TMagWrksf.ToolButton4Click(Sender: Tobject);
Begin
  MagWrksmemo.Show;
End;

Procedure TMagWrksf.MnuContentsClick(Sender: Tobject);
Begin
  ShowHelp;
End;

Procedure TMagWrksf.btnSaveClick(Sender: Tobject);
Begin
  SaveChanges;

End;

Procedure TMagWrksf.MnuSaveClick(Sender: Tobject);
Begin
  SaveChanges;
End;

Procedure TMagWrksf.SaveChanges;
Begin
  FChangesSaved := True;
  ChangeUpdate(False);
//if (fsModal in FormState) then modalresult := mrok
//else close;
  MagWrksmemo.Memo1.Lines.Clear;
  MagWrksmemo.Memo1.Lines.LoadFromFile(FiniFileName);
End;

Procedure TMagWrksf.MnuExitClick(Sender: Tobject);
Begin
  Close;
End;

Procedure TMagWrksf.FormCreate(Sender: Tobject);
Begin
  E2.Left := 59;
  E2.Top := 31;
  Panel1.Left := 59;
  Panel1.Top := 31;
End;

Function TMagWrksf.Execute(Inifile: String): Boolean;
Begin
  With TMagWrksf.Create(Nil) Do
  Begin
    MagWrksmemo := TMagWrksmemo.Create(Nil);
    FiniFileName := Inifile;
    Showmodal;
    Result := FChangesSaved;

    Release;
  End;
End;

Procedure TMagWrksf.MnuAboutClick(Sender: Tobject);
Begin
  FrmAbout.Execute;
End;

Procedure TMagWrksf.AllTrueFalseTRUE1Click(Sender: Tobject);
Var
  i, j, k: Integer;
  s, XID: String;
  XVal: String;
Begin
  k := Lb1.ItemIndex;
  For j := 0 To Lb1.Items.Count - 1 Do
  Begin
    Lb1.ItemIndex := j;
    Lb1.Update;
    s := Lb1.Items[j];
    i := Pos('=', s);
    XID := Copy(s, 1, i - 1);
    Le2.caption := XID;
    XVal := Copy(s, i + 1, Length(s));
    If (Uppercase(XVal) = 'FALSE') Then
    Begin
      cb1.Visible := False;
      Panel1.Visible := True;
      E2.Visible := False;
      Rbfalse.Checked := True;
      Rbtrue.Checked := True;

    End;
  End;
  Lb1.ItemIndex := k;
End;

Procedure TMagWrksf.AllTrueFalseFALSE1Click(Sender: Tobject);
Var
  i, j, k: Integer;
  s, XID: String;
  XVal: String;
Begin
  k := Lb1.ItemIndex;
  For j := 0 To Lb1.Items.Count - 1 Do
  Begin
    Lb1.ItemIndex := j;
    Lb1.Update;
    s := Lb1.Items[j];
    i := Pos('=', s);
    XID := Copy(s, 1, i - 1);
    Le2.caption := XID;
    XVal := Copy(s, i + 1, Length(s));
    If (Uppercase(XVal) = 'TRUE') Then
    Begin
      cb1.Visible := False;
      Panel1.Visible := True;
      E2.Visible := False;
   //  rbfalse.checked := false;
   //       rbtrue.checked := true;
      Rbtrue.Checked := True;
      Rbfalse.Checked := True;
    End;
  End;
  Lb1.ItemIndex := k;
End;

End.
