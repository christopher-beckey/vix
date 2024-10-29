Unit FEdtLVlink;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging List View Utilities for capture functions

   Initially designed to hold all functionality for Showing the ListView Objects
   that were associated with TmagLVUtils objects  and implementing the AutoTab,
   AutoSelect an AutoOpen functions.  Testing proved to be a bad design.
   Keystrokes events, switching control focus caused timing issues.  Functions
   were taken out of here an implemented in the Capture Main window.
   Thought needs to go into ReDesigning the Auto- functions.
   Also Implementing the newer component descendent from TListView (TMagListView)
   rather than the helper component for TListView (TMagLVUtils).
   Patch... ?

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
  ComCtrls,
  Controls,
  Forms,
  Stdctrls
  ;

//Uses Vetted 20090929:Buttons, cMagLVutils, Dialogs, Graphics, SysUtils, Messages, Classes, Windows

Type
  TfEdtLV = Class(TForm)
  Private
    Procedure ScrollItemInView(LV: TListView; Li: TListItem);
    //procedure AutoComplete(edt: Tedit; fulltext: string);

    { Private declarations }
  Public
    SelectByArrow: Boolean;
    { These boolaen values are Set when user logs on to VistA. from User Prefs}
        {       Show the list, when associated Edit Control gets Focus}
    FShowListOnEnter: Boolean;
        {  AutoTab to next control in Tabbing Sequence when 'Enter' is pressed}
    FAutoTab: Boolean;
        { AutoSelect a list entry when text in edit control uniquely identifies
                one list entry}
    FAutoSelect: Boolean;

{ ** The following Gen* (Gen - short for Generic) are used by the
     TEdit and TListView control pair.  This pair is used to enable the
     Auto functions described above.}

        { Find the next control in the tabbing sequence and give it focus}
    Procedure GenGoToNextControl(Edt: TWinControl);
        { Opens the ListView control that is associated with the Edit control}
    Procedure GenShowlistview(Edt: TEdit; LV: TListView);
        { when a ListView item is clicked, insert that item in the Edit Control}
    Procedure GenClicked(Edt: TEdit; LV: TListView);
        { when exiting an Edit Control that is associated with a ListView
          if a list view item is selected, use that as text in edit control}
    Procedure GenExiting(Edt: TEdit; LV: TListView);
        { handle different Keys in the edit controls.
          i.e. Enter to select, DownArrow to show the list }
    Procedure GenKeyDown(Edt: TEdit; LV: TListView; Key: Word);
        { assure the 'value' from the edit control is in the TListView control}
        {   when 'Applying a configuration, must make sure the text value
            of the edit control is a list item in the ListView }
    Function GenOldTextInNewLV(Value: String; LV: TListView): Boolean;
        {    on the Key Up event of the edit control.  Select the first item
             in the ListView control that matches 'txt'}
    Function GenKeyUp(Edt: TEdit; Var Txt: String; Var Fulltext: String; LV: TListView; Delchar: Boolean = False): Integer;

  End;

Var
  FEdtLV: TfEdtLV;

Implementation
Uses
  Classes,
  FmagCapMain,
  Windows
  ;

{$R *.DFM}

(*
procedure TfEdtLV.AutoComplete(edt: Tedit; fulltext: string);
var stSelPos: integer;
begin
  edt.Update;
  frmcapmain.testmsg('4- '+edt.text+'   full '+fulltext);
  stSelPos := length(edt.text);
  edt.text := fulltext;
  edt.SelStart := stSelPos;
  edt.SelLength := 99;
  edt.update;
  frmcapmain.testmsg('4sel- '+edt.seltext);
 // edt.selstart := stSelPos;
 // edt.SelText := copy(fulltext,stselpos+1,999);
application.processmessages;
//   showmessage('  ');
end;
*)

Procedure TfEdtLV.GenShowlistview(Edt: TEdit; LV: TListView);
Begin
  //lv.top := edt.top+edt.height+2;
  //lv.Left := edt.left+5;
  LV.Show;
  LV.Update;

End;

Function TfEdtLV.GenKeyUp(Edt: TEdit; Var Txt: String; Var Fulltext: String; LV: TListView; Delchar: Boolean = False): Integer;
Var
  i: Integer;
  Li: TListItem;
Begin
  Result := 0;
  Fulltext := '';
  Frmcapmain.Testmsg('2-' + Txt + '    edttxt-' + Txt);
  If Txt = '' Then
  Begin
    LV.Selected := Nil;
    Exit;
  End;
  GenShowlistview(Edt, LV);
  LV.Selected := Nil; // today ? will this be a blinker
  For i := 0 To LV.Items.Count - 1 Do
  Begin
    Li := LV.Items[i];
    If Copy(Li.caption, 1, Length(Txt)) = Txt Then
    Begin
      Result := Result + 1;
      If (Result = 1) Then // first hit
      Begin
        Li.Selected := True;
        Fulltext := Li.caption;
        ScrollItemInView(LV, Li);
        Frmcapmain.Testmsg('3- ' + Edt.Text);
        //today       AutoComplete(edt, li.caption);
      End;
      If (Result > 1) Then Break; // Older Design had all items that matched
                                   //  were selected, not just first one.
    End;
    // today else li.selected := false;
  End;
  If LV.Selcount = 0 Then Messagebeep(MB_ICONEXCLAMATION);
End;

{       when we programmatically select a listitem we have to make
        sure it is visible, not scrolled out of sight.}

Procedure TfEdtLV.ScrollItemInView(LV: TListView; Li: TListItem);
Var
  Lix, TV: Integer;
Begin
  TV := LV.VisibleRowCount;
  Lix := Li.Index;
  While ((LV.TopItem.Index + TV) < Lix) Do
  Begin
    LV.Scroll(0, 40);
    LV.Update;
  End;
  While (LV.TopItem.Index > Lix) Do
  Begin
    LV.Scroll(0, -20);
    LV.Update;
  End;
End;

Procedure TfEdtLV.GenGoToNextControl(Edt: TWinControl);
Var
  Tl: Tlist;
  i: Integer;
  Smsg: String;
  Nextctrlok: Boolean;
Begin
  If Not FAutoTab Then Exit; //WPR AUTO
  //FindNextControl(edt, true, true, true).setfocus;
  Tl := Tlist.Create;
  Smsg := '';
  Try
    Frmcapmain.SbxEditFields.GetTabOrderList(Tl);
    // testing see ctrls in list     for i := 0 to tl.count-1 do
    // testing see ctrls in list     smsg := smsg+(TWincontrol(tl[i]).name)+#13;
    // testing see ctrls in list     showmessage(smsg);
    i := Tl.Indexof(Edt);
    Nextctrlok := False;
    While Not Nextctrlok Do
    Begin
      i := i + 1;
      If (i > (Tl.Count - 1)) Then Break; // don't want to go around
      // testing see ctrls in list     showmessage(TWincontrol(tl[i]).name);
      If TWinControl(Tl[i]).Enabled
        And TWinControl(Tl[i]).Visible
        And TWinControl(Tl[i]).TabStop Then
      Begin
        Nextctrlok := True;
        TWinControl(Tl[i]).SetFocus;
      End;
    End;
  Finally
    Tl.Free;
  End;
End;

Procedure TfEdtLV.GenKeyDown(Edt: TEdit; LV: TListView; Key: Word);
Var
  Li: TListItem;
  Lilast: TListItem;
Begin
  If Key = VK_Return Then
  Begin
    If (LV.Selcount > 0) Then Edt.Text := LV.Selected.caption;
    GenGoToNextControl(Edt);
    LV.Visible := False;
  End;

  If Key = 40 Then //DownArrow
  Begin
    If (Not LV.Visible) Then
    Begin
      LV.Visible := True;
      Exit;
    End;
    Li := LV.Selected;
    Lilast := Li;
    If Li <> Nil Then Li.Selected := False;
    Begin
      Li := LV.Getnextitem(Li, Sdall, [IsNone]);
      If (Li = Nil) Then Li := Lilast;
      Li.Selected := True;
      ScrollItemInView(LV, Li);
      Exit;
    End;
  End;

  If Key = 38 Then //uparrow
  Begin
    If Not LV.Visible Then
    Begin
      LV.Visible := True;
      Exit;
    End;
    Li := LV.Selected;
    Lilast := Li;
    If Li <> Nil Then Li.Selected := False;
    Begin
      Li := LV.Getnextitem(Li, SdAbove, [IsNone]);
      If (Li = Nil) Then Li := Lilast;
      If (Li = Nil) Then Li := LV.Items[(LV.Items.Count - 1)];
      Li.Selected := True;
      ScrollItemInView(LV, Li);
      Exit;
    End;
  End;
End;

Function TfEdtLV.GenOldTextInNewLV(Value: String; LV: TListView): Boolean;
Var
  i: Integer;
Begin
  Result := False;
  For i := 0 To LV.Items.Count - 1 Do
  Begin
    If LV.Items[i].caption = Value Then
    Begin
      LV.Selected := Nil;
      Result := True;
      LV.Items[i].Selected := True;
      Break;
    End;
  End;

End;

Procedure TfEdtLV.GenExiting(Edt: TEdit; LV: TListView);
Var
  Li: TListItem;
Begin
  If Edt.Text = '' Then LV.Selected := Nil;
  Case LV.Selcount Of
    0:
      Begin
        Edt.Text := '';
        //lv.visible := false;
      End;
    1:
      Begin
        Edt.Text := LV.Selected.caption;
        //lv.visible := false
      End;
  Else
    Begin
      { if multiple ListView items are selected, set only the first as
        selected, then take that as text for edit control}
      Li := LV.Selected;
      LV.Selected := Nil;
      Li.Selected := True;
      Edt.Text := LV.Selected.caption;
      // lv.visible := false;
    End;
    LV.Update;
    Edt.Update;
  End;
End;

Procedure TfEdtLV.GenClicked(Edt: TEdit; LV: TListView);
Var
  Li: TListItem;
Begin
  If (LV.Selected = Nil) Then
  Begin
    Edt.SetFocus;
    Exit;
  End;
  If LV.Selcount > 1 Then
  Begin
    Li := LV.Selected;
    LV.Selected := Nil;
    Li.Selected := True;
  End;
  Edt.Text := LV.Selected.caption;
  Edt.SetFocus;
  LV.Visible := False;

End;

End.
