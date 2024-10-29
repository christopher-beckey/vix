Unit RecentUpdatesu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging (old design.  Shows Recent Changes File)
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
  ExtCtrls,
  Forms,
  Menus,
  Stdctrls,
  Classes
  ;

//Uses Vetted 20090929:Graphics, Classes, Messages, Windows, fmxutils, umagutils, magpositions, Dialogs, SysUtils

Type
  TRecentUpdates = Class(TForm)
    Memo1: TMemo;
    PopupMenu1: TPopupMenu;
    WordWrap1: TMenuItem;
    N1: TMenuItem;
    Refresh1: TMenuItem;
    Panel1: Tpanel;
    Procedure FormCreate(Sender: Tobject);
    Procedure FormDestroy(Sender: Tobject);
    Procedure WordWrap1Click(Sender: Tobject);
    Procedure Refresh1Click(Sender: Tobject);
  Private
    FTitle: String;
    { Private declarations }
  Public
    Procedure Loadupdates;
  End;

Var
  RecentUpdates: TRecentUpdates;

Implementation
Uses
  Dialogs,
  Fmxutils,
  Magpositions,
  SysUtils,
  Umagutils8
  ;

{$R *.DFM}

Procedure TRecentUpdates.FormCreate(Sender: Tobject);
Begin
  Memo1.Align := alClient;
  GetFormPosition(Self As TForm);
  FTitle := 'Version 2.5 Recent Updates';
End;

Procedure TRecentUpdates.FormDestroy(Sender: Tobject);
Begin
  SaveFormPosition(Self As TForm);
End;

Procedure TRecentUpdates.Loadupdates;
Var
  Xfile: String;
Begin
  Screen.Cursor := crHourGlass;
  Panel1.caption := '';
  Try
    Xfile := '\\vhaiswimm1\image1\release\log\log25.txt';
    If FileExists(Xfile) Then
    Begin
      If Not Doesformexist('Recentupdates') Then RecentUpdates := TRecentUpdates.Create(Self);
      Application.Processmessages;
      Memo1.Clear;
      Memo1.Lines.LoadFromFile(Xfile);
      Panel1.caption := Xfile + '  ' + Formatdatetime('mm/dd/yyyy  h:mm am/pm', FILEDATETIME(Xfile));
      Show;
    End
    Else
      Messagedlg('The File : ' + Xfile + ' does not exist.', Mtconfirmation, [Mbok], 0);
  Finally
    Screen.Cursor := crDefault;
  End;
End;

Procedure TRecentUpdates.WordWrap1Click(Sender: Tobject);
Begin
  WordWrap1.Checked := Not WordWrap1.Checked;
  Memo1.Wordwrap := WordWrap1.Checked;
End;

Procedure TRecentUpdates.Refresh1Click(Sender: Tobject);
Begin
  Loadupdates;
End;

End.
