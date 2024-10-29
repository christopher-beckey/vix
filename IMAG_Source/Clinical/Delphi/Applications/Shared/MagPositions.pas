Unit Magpositions;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:    version 2.5
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==     unit MagPositions;
   Description: Image utilities
          Some functions and methods are used by many Forms (windows) and components of
          the application.  Utility units are designed to be a repository of such
          utility functions used throughout the application.

          This utility methods for forms to save or get a saved position.
          and Configuration utility to Get or Save a control's font
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
  Forms,
  Graphics
  , imaginterfaces
  ;


{       Save the forms position to the Configuratin file }
Procedure SaveFormPosition(Form: TForm; XDirectory: String = '');
{       Get the saved position from the Configuratin file }
Procedure GetFormPosition(Form: TForm; XDirectory: String = '');
{       used by forms that need to save the font to the configuration file. }
Procedure SaveControlFont(Name: String; CtrlFont: TFont);
Implementation
Uses
  Inifiles,
  Magguini,
  SysUtils,
  Umagutils8
  ;

//RCA 11/11/2011  gek  remove dependency on maggmsgu and VCLZip.  Use interface (if it is declared).
(* procedure MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);
begin
if ImsgObj <> nil then  ImsgObj.LogMsg(msgtype,msg,priority);
end;
*)



Procedure SaveControlFont(Name: String; CtrlFont: TFont);
Var
  StFont: String;
Begin
  if application.Terminated then exit;
  With TIniFile.Create(GetConfigFileName) Do
  Begin
    Try
      StFont := CtrlFont.Name + '^' + Inttostr(CtrlFont.Size) + '^';
      If Fsbold In CtrlFont.Style Then StFont := StFont + 'B';
      If Fsitalic In CtrlFont.Style Then StFont := StFont + 'I';
      Writestring('SYS_Fonts', Name, StFont);
    Finally
      Free;
    End;
  End;
End;

Procedure SaveFormPosition(Form: TForm; XDirectory: String = '');
Begin
  if application.Terminated then exit;

  try
  If Form.WindowState <> Wsnormal Then Exit;
  With TIniFile.Create(GetConfigFileName(XDirectory)) Do
  Begin
    Try
      Writestring('SYS_LastPositions', Form.Name, Inttostr(Form.Left) + ',' + Inttostr(Form.Top) + ',' +
        Inttostr(Form.Width) + ',' + Inttostr(Form.Height));
    Finally
      Free;
    End;
  End;
  except
    on E:Exception do
      magAppMsg('s', 'MagPositions.SaveFormPosition (Form.Name = ' + Form.Name + ') exception = ' + E.Message);
  end;
End;

Procedure GetFormPosition(Form: TForm; XDirectory: String = '');
Var
  FORMpos: String;
  Wrksarea: TMagScreenArea;
Begin
  With TIniFile.Create(GetConfigFileName(XDirectory)) Do
  Begin
    Try
      FORMpos := ReadString('SYS_LastPositions', Form.Name, 'NONE');
    Finally
      Free;
    End;
  End;
  If FORMpos <> 'NONE' Then
  Begin
    If ((Form.BorderStyle = bsSizeToolWin) Or (Form.BorderStyle = bsSizeable)) Then
      Form.SetBounds(Strtoint(MagPiece(FORMpos, ',', 1)), Strtoint(MagPiece(FORMpos, ',', 2)),
        Strtoint(MagPiece(FORMpos, ',', 3)), Strtoint(MagPiece(FORMpos, ',', 4)))
    Else
    Begin
      Form.Left := Strtoint(MagPiece(FORMpos, ',', 1));
      Form.Top := Strtoint(MagPiece(FORMpos, ',', 2));
    End;
  End;
  Wrksarea := GetScreenArea;
  Try
    If (Form.Left + Form.Width) > Wrksarea.Right Then Form.Left := Wrksarea.Right - Form.Width;
    If (Form.Top + Form.Height) > Wrksarea.Bottom Then Form.Top := Wrksarea.Bottom - Form.Height;
    If (Form.Top < Wrksarea.Top) Then Form.Top := Wrksarea.Top;
    If (Form.Left < Wrksarea.Left) Then Form.Left := Wrksarea.Left;

  Finally
    Wrksarea.Free;
  End;
End;
End.
