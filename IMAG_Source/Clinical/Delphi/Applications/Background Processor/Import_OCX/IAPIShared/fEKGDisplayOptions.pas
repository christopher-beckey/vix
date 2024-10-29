Unit FEKGDisplayOptions;
{
  Package: EKG Display
  Date Created: 07/20/2003
  Site Name: Silver Spring
  Developers: Robert Graves
  Description: options form for displaying EGKs from MUSE Servers
}
Interface

Uses
  Forms,
  Stdctrls,
  Classes,
  Controls
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, Classes, Messages, Windows, Magguini, Inifiles, SysUtils

Type
  TEKGDisplayOptionsForm = Class(TForm)
    RbtnSolidGrid: TRadioButton;
    RbtnDottedGrid: TRadioButton;
    btnOK: TButton;
    btnCancel: TButton;
    Procedure btnOKClick(Sender: Tobject);
    Procedure FormCreate(Sender: Tobject);
    Procedure btnCancelClick(Sender: Tobject);
  Private
    { Private declarations }
  Public
    PrintDottedGrid: Boolean;
  End;

Var
  EKGDisplayOptionsForm: TEKGDisplayOptionsForm;

Implementation
Uses
  Inifiles,
  Magguini,
  SysUtils
  ;

{$R *.DFM}

Procedure TEKGDisplayOptionsForm.FormCreate(Sender: Tobject);
// Load the settings from the MAG.ini and change the form to those settings
Var
  Magini: TIniFile;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  PrintDottedGrid := Uppercase(Magini.ReadString('VISTAMUSE', 'PrintDottedGrid', 'TRUE')) = 'TRUE';
  Magini.Free();
  If (PrintDottedGrid) Then
    RbtnDottedGrid.Checked := True
  Else
    RbtnSolidGrid.Checked := True;
End;

Procedure TEKGDisplayOptionsForm.btnOKClick(Sender: Tobject);
// save the selected settings in the MAG.ini and close the form
Var
  Magini: TIniFile;
Begin
  PrintDottedGrid := RbtnDottedGrid.Checked;
  Magini := TIniFile.Create(GetConfigFileName);
  If (PrintDottedGrid) Then
    Magini.Writestring('VISTAMUSE', 'PrintDottedGrid', 'TRUE')
  Else
    Magini.Writestring('VISTAMUSE', 'PrintDottedGrid', 'FALSE');
  Magini.Free();
  Close();
End;

Procedure TEKGDisplayOptionsForm.btnCancelClick(Sender: Tobject);
// reset the settings to what they were when the form was opened, and close
// the form
Begin
  If (PrintDottedGrid) Then
    RbtnDottedGrid.Checked := True
  Else
    RbtnSolidGrid.Checked := True;
  Close();
End;

End.
