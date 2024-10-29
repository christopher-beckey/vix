Unit FmagWebHelpMapping;

Interface

Uses
  ComCtrls,
  ExtCtrls,
  Forms,
  Stdctrls,
  ValEdit,
  Controls,
  Grids,
  Classes
  ;

//Uses Vetted 20090929:Grids, Dialogs, Controls, Graphics, Classes, Variants, Messages, umagdisplaymgr, umagutils, SysUtils, Windows

Type
  TfrmWebHelpMapping = Class(TForm)
    Pgctrl: TPageControl;
    PgtbKeyValue: TTabSheet;
    ValueListEditor1: TValueListEditor;
    Pgtbhtmdocs: TTabSheet;
    ListBoxBad: TListBox;
    LstbxGood: TListBox;
    Panel1: Tpanel;
    Label1: Tlabel;
    Button1: TButton;
    Button2: TButton;
    EdtSearch: TEdit;
    btnSearch: TButton;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    cb93ClientDir: TCheckBox;
    cbUseIEforHelp: TCheckBox;

    Procedure btnSearchClick(Sender: Tobject);
    Procedure Button1Click(Sender: Tobject);
    Procedure Button2Click(Sender: Tobject);
    Procedure ListBoxBadClick(Sender: Tobject);
    Procedure LstbxGoodClick(Sender: Tobject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  FrmWebHelpMapping: TfrmWebHelpMapping;

Implementation

Uses
  FmagWebHelp,
  SysUtils,
  umagutils8A,
  UMagDefinitions,
  Umagutils8,
  Windows
  ;

{$R *.dfm}

Procedure TfrmWebHelpMapping.Button1Click(Sender: Tobject);
Var
  Cell, Row, Col: Integer;
  Wp, Key, Val, Helpdoc: String;
Begin

  ListBoxBad.Clear;
  LstbxGood.Clear;
  ValueListEditor1.Visible := True;

  Pgctrl.ActivePage := Pgtbhtmdocs;

  For Row := 1 To ValueListEditor1.Strings.Count - 1 Do
  Begin
    Wp := ValueListEditor1.Cells[2, Row];
    Key := ValueListEditor1.Keys[Row];
    Val := ValueListEditor1.Values[Key];
    If cb93ClientDir.Checked Then
    Begin
      Helpdoc := ExtractFileName(Val);
      Wp := AppPath + '\help\client\' + Helpdoc;
    End
    Else
      Wp := AppPath + '\help\client\' + Val;
    If Not FileExists(Wp) Then
    Begin
      ListBoxBad.Items.Add(Key + '  =' + Val);
    End
    Else
      LstbxGood.Items.Add(Key + '  =' + Val);
  End;

End;

Procedure TfrmWebHelpMapping.LstbxGoodClick(Sender: Tobject);
Var
  Flags: OLEVariant;
  Val: String;
  Fullname: String;
Begin
 // Form2.Show;
//  {this was in the example} Form2.WebBrowser1.Navigate(WideString(GetCurrentDir+'\CamaroHelp\WebHelp\camarohelp.htm'), Flags, Flags, Flags, Flags);
//  {try getting from web}Form2.WebBrowser1.Navigate(WideString('\\10.2.29.231\helpfiles\site\VIHelpv001\!SSL!\WebHelp\index.htm#Capturing_images_&_documents_to_patient_records\Completing_the_Capture\Validate_Image_Data.htm'),Flags, Flags, Flags, Flags);
//  {the subtopic to open} #Capturing_images_&_documents_to_patient_records\Completing_the_Capture\Acquiring_the_Image.htm
 {try getting from interactive}

  Val := LstbxGood.Items[LstbxGood.ItemIndex];
  Val := MagPiece(Val, '=', 2);
//frmWebHelp.WebBrowser1.Navigate(WideString(apppath +'\help\client\index.htm#'+val),Flags, Flags, Flags, Flags);
//p93
  If cb93ClientDir.Checked Then Val := ExtractFileName(Val);
  Fullname := AppPath + '\help\client\' + Val;
  If Not cbUseIEforHelp.Checked Then
    FrmWebHelp.WebBrowser1.Navigate(WideString(Fullname), Flags, Flags, Flags, Flags)
  Else
  Begin
    Magexecutefile(AppPath + '\Help\Client\' + Fullname, '', '', SW_SHOW);
  End;

  Application.Processmessages;
  LstbxGood.SetFocus;
  LstbxGood.Update;
End;

Procedure TfrmWebHelpMapping.ListBoxBadClick(Sender: Tobject);
Var
  Flags: OLEVariant;
  Val: String;
  Fullname: String;
Begin
 // Form2.Show;
//  {this was in the example} Form2.WebBrowser1.Navigate(WideString(GetCurrentDir+'\CamaroHelp\WebHelp\camarohelp.htm'), Flags, Flags, Flags, Flags);
//  {try getting from web}Form2.WebBrowser1.Navigate(WideString('\\10.2.29.231\helpfiles\site\VIHelpv001\!SSL!\WebHelp\index.htm#Capturing_images_&_documents_to_patient_records\Completing_the_Capture\Validate_Image_Data.htm'),Flags, Flags, Flags, Flags);
//  {the subtopic to open} #Capturing_images_&_documents_to_patient_records\Completing_the_Capture\Acquiring_the_Image.htm
 {try getting from interactive}

  Val := ListBoxBad.Items[ListBoxBad.ItemIndex];
  Val := MagPiece(Val, '=', 2);
//frmWebHelp.WebBrowser1.Navigate(WideString(apppath +'\help\client\index.htm#'+val),Flags, Flags, Flags, Flags);
  Fullname := AppPath + '\help\client\' + Val;
  FrmWebHelp.WebBrowser1.Navigate(WideString(Fullname), Flags, Flags, Flags, Flags);

End;

Procedure TfrmWebHelpMapping.Button2Click(Sender: Tobject);
Begin
  Pgctrl.ActivePage := Pgtbhtmdocs;
  If LstbxGood.Count > 0 Then
  Begin
    LstbxGood.ItemIndex := LstbxGood.ItemIndex + 1;
    LstbxGoodClick(Self);
  End;
End;

Procedure TfrmWebHelpMapping.btnSearchClick(Sender: Tobject);
Var
  i: Integer;
  Done: Boolean;
Begin
  Pgctrl.ActivePage := Pgtbhtmdocs;

  If LstbxGood.Count > 0 Then
  Begin
    Done := False;
    i := LstbxGood.ItemIndex;
    While Not Done Do
    Begin
     //lstbxgood.ItemIndex := lstbxgood.ItemIndex +1;
      i := i + 1;
      If i > LstbxGood.Count - 1 Then Break;
      If Pos(Uppercase(EdtSearch.Text), Uppercase(LstbxGood.Items[i])) > 0 Then
      Begin
        LstbxGood.ItemIndex := i;
        LstbxGoodClick(Self);
        Break;
      End;
    End;
  End;
End;
End.
