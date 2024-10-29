Unit MagBatchCapUtil;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging Utilities for Batch Capture
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
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  FileCtrl,
  Stdctrls,
  ComCtrls,
  Fmxutils,
  ExtCtrls,
  Menus;

Procedure FileToListView(AddFile: String; Var LV: TListView);
Procedure ListViewToListView(Var FromLV, ToLV: TListView);

Implementation

Procedure ListViewToListView(Var FromLV, ToLV: TListView);
Var
  Listitem: TListItem;
Begin
  Listitem := FromLV.Selected;
  FileToListView(Listitem.SubItems[3] + '\' + Listitem.caption, ToLV);
End;

Procedure FileToListView(AddFile: String; Var LV: TListView);
Var
  i: Integer;
Begin
  LV.Items.Add;
  i := LV.Items.Count - 1;
  LV.Items[i].caption := ExtractFileName(AddFile);
  LV.Items[i].ImageIndex := 2;
  LV.Items[i].SubItems.Add(Inttostr(Getfilesize(AddFile)));
  LV.Items[i].SubItems.Add(ExtractFileExt(AddFile));
  LV.Items[i].SubItems.Add(Formatdatetime('m/dd/yy  h:mm am/pm', FILEDATETIME(AddFile)));
  LV.Items[i].SubItems.Add(ExtractFileDir(AddFile));
End;

End.
