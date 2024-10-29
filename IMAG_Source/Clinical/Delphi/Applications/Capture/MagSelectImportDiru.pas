Unit MagSelectImportDiru;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Import Directory Selection Dialog.
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
  FileCtrl,
  Forms,
  Stdctrls
  ;

//Uses Vetted 20090929:maggut1, SysUtils, ExtCtrls, Graphics, WinProcs, magguini, umagutils, dialogs, Inifiles, WinTypes

Type
  TMagSelectImportDirf = Class(TForm)
    DriveComboBox2: TDriveComboBox;
    ComboBox1: TComboBox;
    DirectoryListBox2: TDirectoryListBox;
    DrvDir: Tlabel;
    FileListBox1: TFileListBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    BitBtn1: TBitBtn;
    cbSaveAsDefault: TCheckBox;
    LbAlign: Tlabel;
    Procedure OKBtnClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure ComboBox1KeyDown(Sender: Tobject; Var Key: Word;
      Shift: TShiftState);
    Procedure ComboBox1Click(Sender: Tobject);
    Procedure BitBtn1Click(Sender: Tobject);
    Procedure FormResize(Sender: Tobject);
  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  MagSelectImportDirf: TMagSelectImportDirf;

Implementation
Uses
  Dialogs,
  Inifiles,
  Magguini,
  UMagDefinitions,
  Umagutils8,
  WinTypes
  ;

{$R *.DFM}

Procedure TMagSelectImportDirf.OKBtnClick(Sender: Tobject);
Var
  Tini: TIniFile;

Begin
  If ComboBox1.Text = '' Then
  Begin
    Messagedlg('Select an image filter', Mtconfirmation, [Mbok], 0);
    ComboBox1.SetFocus;
    ComboBox1.DroppedDown := True;
    Exit;
  End;
  If cbSaveAsDefault.Checked Then
  Begin
    Tini := TIniFile.Create(GetConfigFileName);
    Tini.Writestring('Import Options', 'DefaultImportDir', DirectoryListBox2.Directory);
    Tini.Writestring('Import Options', 'DefaultMask', FileListBox1.Mask);
    Tini.Free;
  End;
  ModalResult := MrOK;
End;

Procedure TMagSelectImportDirf.FormCreate(Sender: Tobject);
Var
  Tini: TIniFile;
  x: String;
Begin
  Try
    Tini := TIniFile.Create(GetConfigFileName);
    x := Tini.ReadString('Import Options', 'DefaultImportDir', '');
  {p94t4  gek 1/5/10  BillINI issue.  Bill's INI had import dir that didn't exist.  We
   got error here.  And then, the variable frmMaggMsg became undefined ? ? ? don't know why,
   but the next call to log a message would get the access violoation in Maggmsgu because frmMaggMsg }
   {p94t4 gek 1/5/10  checking for invalid dir, or the Try Except to catch the error, both work. i.e.
    we don't get the AccViol in MaggMsgu.}
    If Not Directoryexists(x) Then x := AppPath + '\import';
    If (x = '') Then x := AppPath + '\import';
    DirectoryListBox2.Directory := x;
    x := Tini.ReadString('Import Options', 'DefaultMask', '');
    If (x = '') Then x := '*.*';
    ComboBox1.Text := x;
    FileListBox1.Mask := x;
    Tini.Free;
    ClientHeight := LbAlign.Top + LbAlign.Height;
    ClientWidth := LbAlign.Left + LbAlign.Width;
  Except;
   {flow control}
  End;
End;

Procedure TMagSelectImportDirf.ComboBox1KeyDown(Sender: Tobject; Var Key: Word;
  Shift: TShiftState);
Begin
  If Key <> VK_Return Then Exit;
  If (Pos('\', ComboBox1.Text) > 0) Or (Pos(':', ComboBox1.Text) > 0) Or (Pos('/', ComboBox1.Text) > 0) Then
  Begin
    Messagedlg('You Can''t change directories from this list box.  '
      + #13 + ' But you can use wildcards to limit the directory file list.  i.e. ''STA*.*''', Mtconfirmation, [Mbok], 0);
    Exit;
  End;
  FileListBox1.Mask := ComboBox1.Text;
  ComboBox1.Items.Add(ComboBox1.Text);
End;

Procedure TMagSelectImportDirf.ComboBox1Click(Sender: Tobject);
Begin
  FileListBox1.Mask := ComboBox1.Text;
End;

Procedure TMagSelectImportDirf.BitBtn1Click(Sender: Tobject);
Begin
  Application.HelpContext(134);
End;

Procedure TMagSelectImportDirf.FormResize(Sender: Tobject);
Begin
  DirectoryListBox2.Height := OKBtn.Top - DirectoryListBox2.Top - 10;
  FileListBox1.Height := OKBtn.Top - FileListBox1.Top - 10;
End;

End.
