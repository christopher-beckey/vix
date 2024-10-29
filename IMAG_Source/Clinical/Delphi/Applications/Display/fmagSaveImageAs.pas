Unit FmagSaveImageAs;

Interface

Uses
  Buttons,
  ComCtrls,
  Forms,
  Stdctrls,
  UMagClasses,
  Controls,
  Classes
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, Classes, SysUtils, Messages, Windows, fMagCopyAgreement

Type
  TfrmSaveImageAs = Class(TForm)
    btnReason: TBitBtn;
    btnSelect: TBitBtn;
    btnCopy: TBitBtn;
    btnCancel: TBitBtn;
    EdtFilename: TEdit;
    LbReason: Tlabel;
    Lbfilename: Tlabel;
    cbAbstract: TCheckBox;
    cbFull: TCheckBox;
    cbTXT: TCheckBox;
    cbBig: TCheckBox;
    LbAssociated: Tlabel;
    StatusBar1: TStatusBar;
  Private

    { Private declarations }
  Public
    Function Execute(IObj: TImageData; Var Savedasfile: String): Boolean;

  End;

Var
  FrmSaveImageAs: TfrmSaveImageAs;

Implementation
Uses
  FmagCopyAgreement
  ;

Function TfrmSaveImageAs.Execute(IObj: TImageData; Var Savedasfile: String): Boolean;
Var
  Reason: String;
Begin

  With TfrmSaveImageAs.Create(Nil) Do
  Begin
    If Not FrmCopyAgreement.Execute(Reason) Then Exit;
    Showmodal;
  End;
End;

{$R *.DFM}

End.
