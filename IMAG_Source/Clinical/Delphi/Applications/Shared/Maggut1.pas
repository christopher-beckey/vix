Unit Maggut1;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  Version 2.0
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==     unit Maggut1;
   Description: Image utilities
          Some functions and methods are used by many Forms (windows) and components of
          the application.  Utility units are designed to be a repository of such
          utility functions used throughout the application.

          This utility methods for
          -  string functions.
          -  configuration file access.
          -  convert Date/Time utility

   This unit also Defines the userprefernces Record.
   userpreferences record is access through out the application by any form, method, unit that
   has a need for user preferences.
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
  Controls,
  Graphics,
  Grids,
  Stdctrls
  ;

//Uses Vetted 20090929:umagclasses, ExtCtrls, Menus, Dialogs, Classes, Messages, WinProcs, umagutils, inifiles, Forms, WinTypes, SysUtils

Type
  Msgcode = Set Of Char;

{       for debugging, shows names of all created forms. }
Procedure Showopenforms(all: Boolean = True);
{       Get the value of '1' Configuration file entry}
Function GetIniEntry(Section, Entry: String): String;
{       Set the value of '1' Configuration file entry}
Procedure SetIniEntry(Section, Entry, Value: String);
{       For Debugging, We don't use it in application otherwise}
Procedure SendWindowsMessage(Txt: String);
{       forms that have STringGrid controls, can Get/Set the controls font
        to the configuration file. }
{TODO: (old - calls to this, need replaced by SaveControlFont in MagPositions)}
Procedure GetStringGridFont(Name: String; Xstringgrid: TStringGrid);

Function IsModalOpen(): Integer;

Implementation
Uses
  Forms,
  Inifiles,
  Magguini,
  SysUtils,
  UMagDefinitions,
  Umagutils8,
  WinTypes
  ;

Procedure SendWindowsMessage(Txt: String);
Var
  Buffer: Array[0..255] Of Char;
  Atom: TAtom;
Begin
  Atom := GlobalAddAtom(Strpcopy(Buffer, Txt));
  SendMessage(HWND_Broadcast, WMIdentifier, Application.Handle, Atom);
  GlobalDeleteAtom(Atom);
End;

Procedure GetStringGridFont(Name: String; Xstringgrid: TStringGrid);
Var
  StFont: String;
  XFont: TFont;
Begin
  XFont := TFont.Create;
  Try

    StFont := GetIniEntry('SYS_Fonts', Name);
    If (StFont = '') Then Exit;
    // xFont in the format FontName^Size^[B|U|I]
    XFont.Name := MagPiece(StFont, '^', 1);
    XFont.Size := Strtoint(MagPiece(StFont, '^', 2));
    If (Pos('B', MagPiece(StFont, '^', 3)) > 0) Then XFont.Style := [Fsbold];
    If (Pos('I', MagPiece(StFont, '^', 3)) > 0) Then XFont.Style := XFont.Style + [Fsitalic];
    Xstringgrid.Font := XFont;
  Finally;
    XFont.Free;
  End;
End;

Function IsModalOpen(): Integer;
Var
  i: Integer;
Begin
  Result := -1;
  For i := Screen.CustomFormCount - 1 Downto 0 Do
    If FsModal In Screen.CustomForms[i].FormState Then
    Begin
      Result := Screen.CustomForms[i].Handle;
      Screen.CustomForms[i].ModalResult := MrCancel;
      Break;
    End;
End;

Procedure Showopenforms(all: Boolean = True);
Var
  i: Integer;
  Tempform: TForm;
  Templist: TListBox;
Begin
  Tempform := TForm.Create(Application.MainForm);
  Templist := TListBox.Create(Application.MainForm);
  Templist.Align := alClient;
  Templist.Parent := Tempform;
  Tempform.Show;
  Try
    With Application Do
    Begin
      Templist.Items.Add('[COMPONENTS[I]]');
      For i := 0 To ComponentCount - 1 Do
      Begin
        If (Components[i] Is TForm) Then
        Begin
          If all Then
            Templist.Items.Add('Name: ' + TForm(Components[i]).Name)
          Else
            If TForm(Components[i]).Visible Then Templist.Items.Add('Name: ' + TForm(Components[i]).Name);
        End;
      End;
    End;
    Templist.Items.Add('--------------------');
    Templist.Items.Add('SCREEN.CUSTOMFORMCOUNT[I]');
    For i := Screen.CustomFormCount - 1 Downto 0 Do
    Begin
      If all Then
        Templist.Items.Add('Name: ' + Screen.CustomForms[i].Name)
      Else
        If TForm(Screen.CustomForms[i]).Visible Then
          Templist.Items.Add('Name: ' + Screen.CustomForms[i].Name)
    End;

  Finally

  End;

End;

Function GetIniEntry(Section, Entry: String): String;
Var
  Magini: TIniFile;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Result := Magini.ReadString(Section, Entry, '');
  Magini.Free;
End;

Procedure SetIniEntry(Section, Entry, Value: String);
Var
  Magini: TIniFile;
Begin
  Magini := TIniFile.Create(GetConfigFileName);
  Magini.Writestring(Section, Entry, Value);
  Magini.Free;
End;

End.
