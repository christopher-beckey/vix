Unit TemplateToText;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:   Ver 3 Patch 8  7/1/2002
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description:  Used FormTemplate, to propagate the same look and
       feel among the application.
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
  Classes,
  Controls,
  Dialogs,
  FormTemplate,
  Menus,
  Stdctrls, ComCtrls, ToolWin, ExtCtrls
  ;

//Uses Vetted 20090929:ExtCtrls, ToolWin, ComCtrls, Forms, Graphics, SysUtils, Messages, Windows, uMagClasses, dmsingle

Type
  TtemplateTEXT = Class(TformTemplate1)
    MemTextFile: TMemo;
    MFont: TMenuItem;
    FontDialog1: TFontDialog;
    MWordWrap: TMenuItem;
    Procedure FormCreate(Sender: Tobject);
    Procedure MFontClick(Sender: Tobject);
    Procedure MWordWrapClick(Sender: Tobject);
    Procedure FormMouseUp(Sender: Tobject; Button: TMouseButton;
      Shift: TShiftState; x, y: Integer);
    Procedure MCopyClick(Sender: Tobject);
    Procedure MPrintClick(Sender: Tobject);
  Private
   //hints and warnings: moved to public
   //   procedure opentheimage(fn : string); override;
  Public
    Procedure Opentheimage(Fn: String); Override;
    { Public declarations }
  End;

Var
  TemplateTEXT: TtemplateTEXT;

Implementation
Uses
  ImagDMinterface, //RCA  DmSingle,DmSingle,
  UMagClasses
  ;

{$R *.DFM}

{ Ttextform }

Procedure TtemplateTEXT.Opentheimage(Fn: String);
Begin
  Inherited;
  Show;
  BringToFront;
  MemTextFile.Lines.LoadFromFile(Fn);
End;

Procedure TtemplateTEXT.FormCreate(Sender: Tobject);
Begin
  Inherited;
  MemTextFile.Align := alClient;
End;

Procedure TtemplateTEXT.MFontClick(Sender: Tobject);
Begin
  Inherited;
  FontDialog1.Font := MemTextFile.Font;
  If FontDialog1.Execute Then
  Begin
    MemTextFile.Font := FontDialog1.Font;
  End;
End;

Procedure TtemplateTEXT.MWordWrapClick(Sender: Tobject);
Begin
  Inherited;
  MWordWrap.Checked := Not MWordWrap.Checked;
  MemTextFile.Wordwrap := MWordWrap.Checked;
  If MWordWrap.Checked Then
    MemTextFile.ScrollBars := SsVertical
  Else
    MemTextFile.ScrollBars := SsBoth;
End;

Procedure TtemplateTEXT.FormMouseUp(Sender: Tobject; Button: TMouseButton;
  Shift: TShiftState; x, y: Integer);
Begin
  Inherited;
//memTextFile.SelLength := 0;
End;

Procedure TtemplateTEXT.MCopyClick(Sender: Tobject);
Var
  Xmsg, Reason: String;
  Stat: Boolean;
Begin
  Inherited;
  If Not idmodobj.GetMagUtilsDB1.GetEsig(Xmsg) Then Exit;
  If Not idmodobj.GetMagUtilsDB1.GetReason(2, Reason) Then Exit;
//idmodobj.GetMagUtilsDB1.ImageCopy(magvgear,stat,xmsg);
  idmodobj.GetMagUtilsDB1.ImageTextFileCopy(FIObj, MemTextFile, 'VistA Imaging Copy');
  idmodobj.GetMagDBBroker1.RPLogCopyAccess(Reason + '^^' + FIObj.Mag0 + '^' +
    'Copy Image' + '^' + FIObj.DFN + '^' + '1', FIObj, COPY_TO_CLIPBOARD)
//idmodobj.GetMagUtilsDB1.ImageTextFileCopy(FIobj,memTextFile,'VistA Imaging Copy');
End;

Procedure TtemplateTEXT.MPrintClick(Sender: Tobject);
//begin
//  inherited;
//idmodobj.GetMagUtilsDB1.ImageTextFilePrint(FIobj,memTextFile.Lines,'VistA Imaging Print');
Var
  Xmsg, Reason: String;
  Stat: Boolean;
Begin
  Inherited;
  If Not idmodobj.GetMagUtilsDB1.GetEsig(Xmsg) Then Exit;
  If Not idmodobj.GetMagUtilsDB1.GetReason(1, Reason) Then Exit;
//  idmodobj.GetMagUtilsDB1.ImagePrint(magvgear,stat,xmsg);
  idmodobj.GetMagUtilsDB1.ImageTextFilePrint(FIObj, MemTextFile.Lines, 'VistA Imaging Print'); {BM-ImagePrint-}
  idmodobj.GetMagDBBroker1.RPLogCopyAccess(Reason + '^^' + FIObj.Mag0 + '^' +
    'Print Image' + '^' + FIObj.DFN + '^' + '1', FIObj, PRINT_IMAGE)
End;

End.
