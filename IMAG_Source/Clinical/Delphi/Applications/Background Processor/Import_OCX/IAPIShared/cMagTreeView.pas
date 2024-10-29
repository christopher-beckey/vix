Unit cMagTreeView;
   {
   Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
 Date Created:
 Site Name: Silver Spring, OIFO
 Developers: Garrett Kirin
[==  unit cMagTreeView;
 Description: Imaging Tree View component.
 An Alternate to the Abstract Window and Image List for viewing a list of patient Images.
 - Adds Imaging Specific methods to the Delphi TreeView component with the
 procedure LoadListFromMagImageList(mil: TMagImageList);
 - Links each Tree Node item to the TImageData object in the associated TmagImageList component.
 - Adds custom sorting feature to allow user to select any column as the next Tree Node.
        Creates Form TfrmTreeViewEdit in unit fmagTreeViewEdit to display a list of columns
        and allow user to arrange columns into tree nodes.
 - Enables an 'AutoSelect' function that uses mouse over events and a timer to automatically select
   a Tree Node .
Add procedures for 508 (Keyboard) functions.
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
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls
    {     Imaging}
  ,
  Umagutils8
  ,
  UMagDefinitions
  ,
  UMagClasses
  ,
  cMagImageList
  ,
  cmag4viewer // ? ? why is this here
  ,
  FmagTreeViewEdit
  ,
  MagImageManager {TODO: Get rid of dependency on MagImageManager }
    //93

  ;
Type
  TMagTreeViewData = Class(Tobject)
  Public
    Data: String;
      Index: Integer;
    IObj: TImageData;
  End;
Type
  TMagTreeView = Class(TTreeView)
  Private
    FDiscardSelect: Boolean;
    Froots: String;
    Function FindTreeViewNode(Txtval: String): TTreeNode;
    Function FindTreeNodeChild(TN: TTreeNode; Txtval: String): TTreeNode;

    Procedure GetTreeNodeImages(TN: TTreeNode; t: Tlist);
    Function GetRoots(Roots: String): String;
    Function GetImageState(IObj: TImageData): Integer;
    Procedure DoCompare(Sender: Tobject; Item1, Item2: TTreeNode; Data: Integer; Var Compare: Integer);
    Procedure SortDateTime(Var Lic: String);

        { Private declarations }
  Protected
        { Protected declarations }
  Public
    AutoSelect: Boolean;
    Constructor Create(AOwner: TComponent); Override;
    Procedure SelectedTreeItemsToMagViewer(TV: TMagTreeView; MV: TMag4Viewer);
    Procedure LoadListFromMagImageList(Mil: TMagImageList; Roots: String = '');
    Procedure AddListToList(t: TStrings);
    Procedure SyncWithIMage(IObj: TImageData);
    Function SelectBranches(VMagImageList: TMagImageList): Boolean;
    Procedure ClearItems;
    Procedure ImageStateChange(VIobj: TImageData; Value: Integer);
    Procedure ImageStatusChange(VIobj: TImageData; Value: Integer);

  Published
        { Published declarations }
  End;

Procedure Register;

Implementation
//  uses  cmagmgrimage;
Uses Umagdisplaymgr;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagTreeView]);
End;

{ TMagTreeView }
{[=p procedure TMagTreeView.AddListToList(t: tstrings);
      AddListToList is a carryover from TMagImageList. Adding a string list of non TImageData formatted images
      (mostly for a 'View all Images from a Directory Function' ) The Design at one time was to have an Interface of ImageListings.
      and the ImageListView, TreeView and abstract viewer would all implement it.  It never made it that far.
      What we do is Subject Observer, so that when the cmagimagelist changes, all it's subjects (Image LIst, Abstracts, TreeView)
      would get notified and then update themselves with data from the cmagimagelist.  Although that is implemented, it's not
      all the same connection and notification process.}

Procedure TMagTreeView.AddListToList(t: TStrings);
Begin
    {}
End;

Procedure TMagTreeView.LoadListFromMagImageList(Mil: TMagImageList; Roots: String);
Var

  Magtreeviewdata1: TMagTreeViewData;
  Visdata: String;
  i, j: Integer;
  Idxnode, Idxval: TStrings;
  Ntn: TTreeNode;
Begin
    { These are the baseline columns.  }{TODO: 62+ this needs changed like planned. i.e. no dependency on column, the object will have all needed data}
    { Item~S2^Site^Note Title~~W0^Proc DT~S1^Procedure^# Img~S2^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt~S1~W0^Cap by~~W0^Image ID~S2~W0}
    {   1    2    3          4        5        6      7        8    9    10    11     12      13     14     15      16           17
      Item^Site^Note Title^Proc DT^Procedure^# Img^Short Desc^Pkg^Class^Type^Specialty^Event^Origin^Cap Dt^Cap by^Image ID ^ Creation Date}
    { roots is the Column Header and Which $P('^') of the BaseImage list this column is.
      Example :     'pkg-8,class-9,type-10' }

  Items.Clear;
  Idxnode := Tstringlist.Create;
  Idxval := Tstringlist.Create;
  Froots := GetRoots(Roots);
  For i := 1 To Maglength(Froots, ',') Do
  Begin
    Idxnode.Add(MagPiece(Froots, ',', i));
  End;
    { idxnode :   (0) = 'pkg-8'
                  (1) = 'class-9'
                  (2) = 'type-10' }
  Application.Processmessages;
  For i := 1 To Mil.BaseList.Count - 1 Do
  Begin
    Visdata := MagPiece(Mil.BaseList[i], '|', 1);
    Idxval.Clear;
    For j := 0 To Idxnode.Count - 1 Do
    Begin
      Idxval.Add(MagPiece(Visdata, '^', Strtoint(MagPiece(Idxnode[j], '-', 2))));
      If Idxval[j] = '' Then
        Idxval[j] := '<no ' + MagPiece(Idxnode[j], '-', 1) + '>';
    End;
        {idxval:  (0) = 'MED'
                  (1) = 'CLIN'
                  (2) = 'IMAGE'     }
    Ntn := FindTreeViewNode(Idxval[0]);
    For j := 1 To Idxval.Count - 1 Do
      Ntn := FindTreeNodeChild(Ntn, Idxval[j]);
        {  Here is where the Visible text is determined.
           Note : also ntn.Text can reset the visible text.}
    Ntn := Items.AddChild(Ntn, MagPiece(Mil.BaseList[i], '^', 7));
        ////
    Magtreeviewdata1 := TMagTreeViewData.Create;
    Magtreeviewdata1.Data := MagPiece(Mil.BaseList[i], '|', 2);
    Magtreeviewdata1.Index := Strtoint(Magtreeviewdata1.Data);
    Magtreeviewdata1.IObj := Mil.ObjList[Magtreeviewdata1.Index];
        //
    Ntn.Data := Magtreeviewdata1;
    Ntn.Text := Magtreeviewdata1.IObj.ExpandedDescription(False); //  ExpandedDescDtID(false);

        //out for 62 testing  ntn.Data := mil.objlist[strtoint(magpiece(mil.baselist[i], '|', 2))];
        //out for 62 testing  if ntn.data = nil then //
  End;
  For i := 0 To Items.Count - 1 Do
  Begin
    If Items[i].HasChildren Then
    Begin
            //93 out  items[i].selectedIndex := mistSelectArrowB;
      Items[i].SelectedIndex := MistFolderWithDoc; //93 in
      Items[i].ImageIndex := MistFolderClosed; //93   was 18;
    End
    Else
    Begin
            //inproto Items[i].ImageIndex :=  mistViewable; //93   was 14;
            //inproto items[i].SelectedIndex := TImageData(TMagTreeViewData(items[i].Data).Iobj).MagViewStatus ; //93 was 12;
            //inproto if TImageData(TMagTreeViewData(items[i].Data).Iobj).IsImageGroup then Items[i].stateindex := mistImageGroup; //93
            //inproto if TImageData(TMagTreeViewData(items[i].Data).Iobj).QAMsg <> '' then Items[i].imageindex := mistQI; //93
      Items[i].ImageIndex := TImageData(TMagTreeViewData(Items[i].Data).IObj).MagViewStatus;
            //93 out     items[i].SelectedIndex :=  umagdefinitions.mistSelectArrowB;
      Items[i].SelectedIndex := Items[i].ImageIndex;
      Items[i].StateIndex := Self.GetImageState(TImageData(TMagTreeViewData(Items[i].Data).IObj));
    End;
  End;
  Self.AlphaSort(False);
End;

Function TMagTreeView.GetImageState(IObj: TImageData): Integer;
Var
  Grp, Sens, Cached: Boolean;
Begin
  Result := -1;
  If IObj.IsViewAble() {//93} Then
  Begin
        { TODO -cRefactor : Get rid of dependency on MagImageManager }
    Cached := MagImageManager1.IsStudyCached(IObj.FFile, IObj.GroupCount);
    If Cached Then
      Result := MistateCached;
    If (Cached And IObj.IsImageGroup) Then
      Result := MistateCachedGroup; //93
    If (IObj.IsImageGroup And (Not Cached)) Then
      Result := MistateImageGroup; //93
    If IObj.MagSensitive And IObj.IsImageGroup Then
      Result := MistateSensitiveGroup; //93
    If ((Not IObj.IsImageGroup) And IObj.MagSensitive) Then
      Result := MistateSensitive; //93
  End;
  Exit;
    { TODO -cRefactor : Get rid of dependency on MagImageManager
above taken from cMagListView.  Not the way I want to go.  I don't want the
dependency on cMagImageManger  ..   The interface IMagImageQuery will be made
for components to find information on an Image, and not have to 'use' or know
about every pascal file.... low coupling. }

  Result := -1;
  If IObj.IsViewAble() Then
  Begin
    If IObj.IsImageGroup Then
      Result := MistImageGroup; //93
    If IObj.MagSensitive Then
      Result := MistSensitive;
  End;
End;

Function TMagTreeView.GetRoots(Roots: String): String;
Begin
  If Froots = '' Then
    Froots := 'pkg-9,type-11';
  If Roots <> '' Then
    Froots := Roots;
  Result := Froots;
End;

Function TMagTreeView.FindTreeViewNode(Txtval: String): TTreeNode;
Var
  j: Integer;
  TN: TTreeNode;
Begin
  Result := Nil;

  For j := 0 To Items.Count - 1 Do
  Begin
    If Items[j].Level <> 0 Then
      Continue;
    If Items[j].Text = Txtval Then
            //if items[j].text = txtval then
    Begin
      Result := Items[j];
      Break;
    End;
  End;
    { TN := TTreenode.create(Treeview1.items);}
  If Result = Nil Then
  Begin
    TN := TTreeNode.Create(Items);
    Result := Items.Add(TN, Txtval);
        //result.StateIndex := 0;
       // result.ImageIndex := 14;
       // result.SelectedIndex := 11;
  End;
End;

Function TMagTreeView.FindTreeNodeChild(TN: TTreeNode; Txtval: String): TTreeNode;
Var
  j: Integer;
Begin
  Result := Nil;
  For j := 0 To TN.Count - 1 Do
  Begin
    If TN.Item[j].Text = Txtval Then
    Begin
      Result := TN.Item[j];
      Break;
    End;
  End;
  If Result = Nil Then
  Begin
    Result := Items.AddChild(TN, Txtval);
        //result.StateIndex := 0;
        //result.ImageIndex := 14;
        //result.SelectedIndex := 11;
  End;
End;

Procedure TMagTreeView.SelectedTreeItemsToMagViewer(TV: TMagTreeView; MV: TMag4Viewer);
Var
  t: Tlist;
  i: Integer;
  Retmsg: String;
    //  Iobj: TimageData;
  TN: TTreeNode;
Begin
  t := Tlist.Create;
  Try
    TN := TV.Selected;
    If TN <> Nil Then
      GetTreeNodeImages(TN, t);
    If (t.Count = 0) Then
      Exit;
    Screen.Cursor := crHourGlass;
    For i := 0 To t.Count - 1 Do
    Begin
      Self.Update;
      Retmsg := OpenSelectedImage(TImageData(t[i]), 1, 0, 1, 0);

            //fix if magpiece(retmsg,'^',1)='0'
               //fix   then GmagLog.LogMsg_('ID# '+ TimageData(t[i]).IEN+' '+TimageData(t[i]).ImgDes+' ' + magpiece(retmsg,'^',2));
    End;

        //   MV.ImagesToMagView(t);
  Finally
    t.Free;
    Screen.Cursor := crDefault;
    Self.Update;

  End;
End;

Procedure TMagTreeView.GetTreeNodeImages(TN: TTreeNode; t: Tlist);
Var
  i: Integer;
  Ntn: TTreeNode;
Begin
  If TN.HasChildren Then
  Begin
    For i := 0 To TN.Count - 1 Do
    Begin
      Ntn := TN.Item[i];
      If Ntn.HasChildren Then
      Begin
        GetTreeNodeImages(Ntn, t);
        Continue;
      End;
      t.Add(TMagTreeViewData(TN.Item[i].Data).IObj);
    End;
  End
  Else
  Begin
    t.Add(TMagTreeViewData(TN.Data).IObj);
  End;

End;
////////////////////
//2006 patch 62

Procedure TMagTreeView.SyncWithIMage(IObj: TImageData);
Var
  i: Integer;
  sync1ien, sync2ien: String;
Begin
  FDiscardSelect := True;
  Try
    sync1ien := IObj.SyncIENG;
    If (Selected <> Nil) And ((Selected.Data) <> Nil) Then
    Begin
      sync2ien := TImageData(TMagTreeViewData(Selected.Data).IObj).SyncIEN;
      If (sync2ien = sync1ien) Then
        Exit;
    End;

    For i := 0 To Items.Count - 1 Do
    Begin
        //fix     gmaglog.LogMsg_(items[i].Text);
      If Items[i].HasChildren Then
        Continue;
      If Items[i].Data = Nil Then
        Continue;
      If TMagTreeViewData(Items[i].Data).IObj = Nil Then
        Continue;
      sync2ien := TImageData(TMagTreeViewData(Items[i].Data).IObj).SyncIEN;
      If sync1ien = sync2ien Then
      Begin
        If Not Items[i].Selected Then
          Items[i].Selected := True;
        Break;
      End;
    End;
  Finally
    FDiscardSelect := False;
  End;

End;

Function TMagTreeView.SelectBranches(VMagImageList: TMagImageList): Boolean;
Var
  Roots: String;
Begin

    //application.CreateForm(TfrmTreeViewEdit,frmTreeViewEdit);
    //try

  FrmTreeViewEdit.Execute(Roots, VMagImageList);
  If Roots <> '' Then
  Begin
    Result := True;
    LoadListFromMagImageList(VMagImageList, Roots);
    AlphaSort;
  End
  Else
    Result := False;

    //finally
    //frmTreeViewEdit.Free;
    //end;
End;

Procedure TMagTreeView.ClearItems;
Begin
  Items.Clear;
    (*
    {from MagListView}
    var i: integer;

    begin
    {DONE: WE MAY need to loop through Items and Kill any data structures pointed
        to, If we use the Data property to point to information.}
      visible := false;
      try
        for i := items.count - 1 downto 0 do
          begin
        // testing memory usage without this line, shows that
        //  this is freeing memory.
            TMagListViewData(items[i].data).free;
          end;
      //li := nil;
      //GetNextItem(li,sddown,isall);
        items.Clear;
      // ClearColumns;
      finally
        visible := true;
      end;
    end;
    *)
End;

Procedure TMagTreeView.ImageStatusChange(VIobj: TImageData; Value: Integer);
Var
  i: Integer;
Begin
  For i := 0 To Items.Count - 1 Do
  Begin
    If Items[i].HasChildren Then
      Continue;
    If Items[i].Data = Nil Then
      Continue;
    If TMagTreeViewData(Items[i].Data).IObj = Nil Then
      Continue;
    If VIobj.Mag0 = TImageData(TMagTreeViewData(Items[i].Data).IObj).Mag0 Then
    Begin
      Items[i].ImageIndex := Value;
      Break;
    End;
  End;
End;

Procedure TMagTreeView.ImageStateChange(VIobj: TImageData; Value: Integer);
Var
  i: Integer;
Begin
  For i := 0 To Items.Count - 1 Do
  Begin
    If Items[i].HasChildren Then
      Continue;
    If Items[i].Data = Nil Then
      Continue;
    If TMagTreeViewData(Items[i].Data).IObj = Nil Then
      Continue;
    If VIobj.Mag0 = TImageData(TMagTreeViewData(Items[i].Data).IObj).Mag0 Then
    Begin
      Items[i].StateIndex := Value;
      Break;
    End;
  End;
End;

Procedure TMagTreeView.DoCompare(Sender: Tobject; Item1, Item2: TTreeNode;
  Data: Integer; Var Compare: Integer);
Var
  Lic1, Lic2: String;
  Sortcode, node1: String;
Begin

  Inherited;

//tree gtc  if Fcurcolumnindex = 0 then
 //if froots <> 'Cap Dt-14' then exit;

  Begin
    Lic1 := Item1.Text; // .caption;
    Lic2 := Item2.Text; //.caption;
  End
  ;
  Sortcode := 'S2';
  node1 := MagPiece(Froots, ',', 1);
  If Item1.Parent = Nil Then
    If ((Pos('Cap Dt', node1) > 0) Or (Pos('Proc DT', node1) > 0) Or (Pos('Creation Date', node1) > 0)) Then
      Sortcode := 'S1' // Date
    Else
      Sortcode := 'S2';
  //else
  //  begin
  //    lic1 := item1.SubItems[Fcurcolumnindex - 1];
  //    lic2 := item2.SubItems[Fcurcolumnindex - 1];
  //  end;
  If Copy(Lic1, 1, 1) = '+' Then Lic1 := Copy(Lic1, 2, 9999);
  If Copy(Lic2, 1, 1) = '+' Then Lic2 := Copy(Lic2, 2, 9999);
  Lic1 := Trim(Lic1);
  Lic2 := Trim(Lic2);
 { S1,S2 are sort codes S1 : date/time, S2 : number.  W* are default column widths W0 : default width of 0 (hidden)}
//  sortcode := magpiece(magpiece(fcolumnsorts, '^', Fcurcolumnindex + 1), '~', 2);
//  if sortcode <> '' then

  If Uppercase(Sortcode) = 'S1' Then
  Begin
    SortDateTime(Lic1);
    SortDateTime(Lic2);
  End;
(*      if uppercase(sortcode) = 'S2' then begin
          SortJustifystring(lic1);
          SortJustifystring(lic2);
        end;
      if uppercase(sortcode) = 'S3' then begin
          SortDayCase(lic1);
          SortDayCase(lic2);
        end
*)

  { this is out now, John passes a sort code in the column header
  Case Fcurcolumnindex of
       0: begin                // ~S3
          SortDayCase(lic1);
          SortDayCase(lic2);
          end;
       6: begin                     // ~S1  (date time )
          SortDateTime(lic1);
          SortDateTime(lic2);
          end;
       8: begin                      // ~S2  ( Number )
          SortJustifystring(lic1);
          SortJustifystring(lic2);
          end;
       end;
      }
  { Try 08/07/01  CompareText Function instead of this
  if FInverse then COMPARE := -lstrcmp(PChar(LIC1), PChar(LIC2))
             else COMPARE := lstrcmp(PChar(LIC1), PChar(LIC2));
  }

//  if FInverse then COMPARE := -CompareText(LIC1, LIC2)
//  else COMPARE := CompareText(LIC1, LIC2);

  If Sortcode = 'S1' Then
    Compare := -CompareText(Lic1, Lic2)

  Else
    Compare := CompareText(Lic1, Lic2);
{ Note : The compare :=...  works for Cap Dt-14 fine,  we're trying reverse chronolocical.   }

End;

Procedure TMagTreeView.SortDateTime(Var Lic: String);
Begin
  (* This was expected format in Johns; lists.
    We need to make it more generic. i.e. handle any date format
   //  02/05/1996@07:08
   lic := copy(lic,7,4)+copy(lic,1,2)+copy(lic,4,2)
             +copy(lic,12,2)+copy(lic,15,2)+copy(lic,18,2);
   *)
  Try
    If Lic <> '' Then Lic := Formatdatetime('yyyymmddhhmmnn', Strtodatetime(Lic));
  Except
    // FOR TESTING use this -> SHOWMESSAGE('Execption in Date : ' + lic  );
    Lic := Lic;
  End;
End;

Constructor TMagTreeView.Create(AOwner: TComponent);
Begin
  Inherited;
  OnCompare := DoCompare;
End;

End.
