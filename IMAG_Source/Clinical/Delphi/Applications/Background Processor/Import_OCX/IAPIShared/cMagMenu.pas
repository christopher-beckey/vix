Unit cMagMenu;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   [==     unit cMagMenu;
   Description: Dynamic menu component. History menu
   This component was developed to allow adding 'history' elements as menu items.
   i.e. the last 10 patients, the last 8 reports opened, etc.
   The instance of the Class will maintain the Max number of menu items.
     Used for History menu's of Patients, Reports, Filters,

    New Menu options can be added by the method
         AddItem(xCaption: string; xID: string; xHint: string);

    developer completes the Published Properties
           MenuBarItem:
               is the main menu item where the dynamic items will be added
           InsertAfterItem:
               is the menu item on MenuBarItem to insert after
           MaxInsert
                Maximum number of history elements to maintain.
           OnNewItemClick event.
                Developer defines a handler to be called when any added item is clicked.

    Developer uses the ID property of the TMagMenuItem clicked as unique identifier
        (NOIS. DFN's had '.', Delphi name property cannont accept '.'
        Patch 8 T 46 . Stopped using Name Property for ID.
          Created new Class TMagMenuItem with an ID property.
          Developer uses the ID property of the TMagMenuItem that was clicked.

        **************   example   *************
        procedure TfrmMain.PatMenuitemSelected(sender: Tobject);
        begin
            // dynamic patient menu item clicked;
           changetopatient((Sender as TMagmenuItem).id);
        end;
        ****************************************

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
  Classes,
  Forms,
  Menus
  ;

//Uses Vetted 20090929:Dialogs, Controls, Graphics, Messages, WinProcs, WinTypes, umagutils, SysUtils

Type
  TNewItemClick = Procedure(Sender: Tobject) Of Object;
  //TMagMenuItem is P8t46
  TMagMenuItem = Class(TMenuItem)
  Public
    ID: String;
  End;

  TMag4Menu = Class(TComponent)
  Private
    FOnNewItemClick: TNewItemClick;
    FMaxInsert: Integer;
    FListofItems: Tstringlist;
    Ftopmenu: TMenuItem;
    Fmenudivider: TMenuItem;
    Fmenuform: TForm;
    FExitItem: Boolean;

  Protected

  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;
    {   DiableItems : not implemented.}
    Procedure DisableItems(Mon: Boolean);

    {   Add a new item to the menu.
            xCaption  = the Menu Items Caption (visible text on menu)
            xID     = Stored ID, used by developer when menu item is clicked.
        **************   example   *************
        procedure TfrmMain.PatMenuitemSelected(sender: Tobject);
        begin
            // dynamic patient menu item clicked;
           changetopatient((Sender as TMagmenuItem).id);
        end;
        ****************************************
            xHint     = the hint when mouse pauses over menu item.}
    Procedure AddItem(XCaption: String; XID: String; XHint: String);
    Procedure ClearAll;

  Published

        {   select the main menu item where the dynamic items will be added}
    Property MenuBarItem: TMenuItem Read Ftopmenu Write Ftopmenu;

        {   select the menu item on MenuBarItem to insert after }
    Property InsertAfterItem: TMenuItem Read Fmenudivider Write Fmenudivider;

        {   Developer defines a handler to be called when any added item is clicked.}
    Property OnNewItemClick: TNewItemClick Read FOnNewItemClick Write FOnNewItemClick;

        {    Maximum number of history elements to maintain.}
    Property MaxInsert: Integer Read FMaxInsert Write FMaxInsert;

        {     not implemented}
    Property ExitItem: Boolean Read FExitItem Write FExitItem;
  End;

Procedure Register;

Implementation
Uses
  SysUtils,
  Umagutils8
  ;

Constructor TMag4Menu.Create(AOwner: TComponent);
Begin
  Inherited Create(AOwner);
  FListofItems := Tstringlist.Create;
End;

Destructor TMag4Menu.Destroy;
Begin
  FListofItems.Free;
  Inherited Destroy;
End;

Procedure TMag4Menu.ClearAll;
Var
  i, j, ct: Integer;
Begin
  ct := FListofItems.Count;
  If (ct = 0) Then Exit;
  FListofItems.Clear;
  j := Ftopmenu.Indexof(Fmenudivider);
  For i := j + 1 + ct - 1 Downto j + 1 Do
  Begin
    Ftopmenu.Delete(i);
  End;

End;

Procedure TMag4Menu.AddItem(XCaption: String; XID: String; XHint: String);
Var
  i, j, ct: Integer;
  NewItem: TMagMenuItem;
  Ts: String;
Begin
  ct := FListofItems.Count;
  j := Ftopmenu.Indexof(Fmenudivider);
  {     Delete all the dynamic menu items.  }
  For i := j + 1 + ct - 1 Downto j + 1 Do
  Begin
    Ftopmenu.Delete(i);
  End;

  Ts := XCaption + '^' + XID;
  {     If item we are adding is already in list.  Delete it and add it to top}
  If FListofItems.Indexof(Ts) > -1 Then
  Begin
    FListofItems.Delete(FListofItems.Indexof(Ts));
  End;
  FListofItems.Insert(0, Ts);
  If FListofItems.Count > MaxInsert Then FListofItems.Delete(MaxInsert);

  For i := 0 To FListofItems.Count - 1 Do
  Begin
        {      Creates the new menu item}
    NewItem := TMagMenuItem.Create(Fmenuform);
        {      Visible Caption for the new menu item}
    NewItem.caption := '&' + Inttostr(i + 1) + '  ' + MagPiece(FListofItems[i], '^', 1);
        {       used by developer to retieve identifier of menu item}
    NewItem.ID := MagPiece(FListofItems[i], '^', 2);
    NewItem.Hint := XHint;
      {         If an event handler is assigned to the TMag4Menu, then
                 Assign it to the new item.}
    If Assigned(FOnNewItemClick) Then
      NewItem.Onclick := OnNewItemClick;
      {       Inserts the new menu item}
    Ftopmenu.Insert(j + i + 1, NewItem);
  End;
End;

Procedure TMag4Menu.DisableItems(Mon: Boolean);
Var
  i, j: Integer;
Begin
  j := Ftopmenu.Indexof(Fmenudivider);
  For i := Ftopmenu.Count - 1 Downto j + 1 Do
  Begin
    If Not Mon Then
      Ftopmenu.Items[i].Enabled := True
    Else
      Ftopmenu.Items[i].Enabled := False;
  End;
End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMag4Menu]);
End;

End.
