Unit cMagListView;
{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
[==  unit cMagListView;
Description: Imaging List View component.
- Adds Imaging Specific methods to the Delphi ListView component with the
procedure LoadListFromMagImageList(mil: TMagImageList);
- Links each list item to the TImageData object in the associated TmagImageList component.
- Adds function to fit all columns into the visible are of the component.
- Adds column sorting and selecting utilities as built in features of the component.
     Creates Form TfrmColumnSelect in unit fmagColumnSelect to display a list of columns
     and allow user to check/uncheck the visible status
- Sort codes can be defined in the Column headers
 S1,S2 are sort codes S1 : date/time, S2 : number.
- Column width defaults can be defined in the Column Header
 W0 : default width of 0 (hidden)
Patch 59
Add Event TMagListViewRefresh, fired whenever list is refreshed.
Add Procedures for TIU Functions.
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
  ComCtrls,
  //Imaging
  Umagutils8,
  UMagClasses,
  UMagDefinitions,
  ImagInterfaces {,maggut4 } {, cMagImageList}
  {//45},
  MagImageManager; {TODO: Get rid of dependency on MagImageManager }
Type
  { an object of TmagListViewData is created for each item in the list view.
    it holds pointers to the actual data in the TMagImageList object
    The Data property of each list item points to a object of this type.}
  TMagListViewData = Class(Tobject)
  Public
    Data: String; // index of this item in the TMagImageList object
    Index: Integer; // index of this item in the TMagImageList object
    IObj: TImageData; // pointer to the TImageData object of this item
  End;
  ////
          {This is fired whenever the list is loaded, reloaded with data}
  TMagListViewRefresh = Procedure(Sender: Tobject) Of Object;
  ////
Type
  TMagListView = Class(TListView)
  Private
    FMagListViewDataArray: Array Of TMagListViewData;//106 RLM Fixing MemoryLeak 6/18/2010
    FColZeroWidth: Integer;
    FMagListViewRefresh: TMagListViewRefresh;
    FColumnWidthDefaults: String;
    Fcurcolumnindex: Integer;
    Fcolumnsorts: String;
    Finverse: Boolean;
    { Column Captions to display in List View control. '^' delimited string.}
    Procedure LoadColumns(s: String);
    { Integers are strings justified to sort correctly}
    Procedure SortJustifystring(Var Lic: String);
    { Date time values converted to string equivalent to sort correctly}
    Procedure SortDateTime(Var Lic: String);
    {  Specific to VistARad : Radiology Day/Case number}
    Procedure SortDayCase(Var Lic: String);
    {  Create a new instance of object, to store additional data for list item}
    Function NewListViewData(Data: String): TMagListViewData;
    {  called internally to do the sorting of 2 items}
    Procedure DoCompare(Sender: Tobject; Item1, Item2: TListItem; Data: Integer; Var Compare: Integer);
    {  uses the user preferences string of column widths  FColumnWidthDefaults: string;
       resizes the columns according to the '^' delimited string of user prefs.}
    Procedure ApplyColumnWidthDefaults;
    Procedure ComputeColumnWidths;
    Function ComputeVisibleColumns: Integer;
    Function ComputeXtraWidth(Wmin: Integer): Integer;
    Function ColWidthPlusXtra(Index: Integer; Minwidth: Integer; Var Xtra: Integer): Integer;

    Function GetImageState(IObj: TImageData): Integer;

  Protected
    Procedure ColClick(Column: TListColumn); Override;
    Property OnCompare;

  Public
    LockSort: Boolean;
    FUseFakeName: Boolean;
    FColWidth: Array Of Integer;
    FColVisible: Array Of Boolean;
    FIImageQuery: ImagImageQuery;
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

    //93
    Procedure SetColumnZeroWidth(Value: Integer);
    Function ColumnSetGetCurrentValue: String;
    Procedure ColumnSetApply(Value: String);
    Function GetSelectedImageObj: TImageData;
    Procedure ImageStateChange(VIobj: TImageData; Value: Integer);
    Procedure ImageStatusChange(VIobj: TImageData; Value: Integer);
    // end 93
       {procedure ScrollToItem - Scroll to certain item in the list}
    Procedure ScrollToItem(Li: TListItem); Overload;
    Procedure ScrollToItem(ListIndex: Integer); Overload;
    {}
    Procedure SortBycolumn(ColIndex: Integer; VInverse: Boolean);
    {  called with the User preferences of '^' delimited column widths.}
    Procedure SetColumnWidths(ColWidths: String);
    {  returns '^' delimitd string of column widths.  Then saved as user pref}
    Function GetColumnWidths: String; //comma delimited string of col widths
    {  Loads columns and data from Imaging object TmagImageList}
    Procedure LoadListFromMagImageList(BaseList: TStrings; ObjList: Tlist); //t46 (mil: TMagImageList);
    {procedure LoadListFromoTIUList -   Loads a TIU List of data into the MagListView component. }
    Procedure LoadListFromoTIUList(t: Tstringlist);
    {  //prototype, not used.  Adds one list to another}
    Procedure AddListToList(t: TStrings; AtIndex: Integer = -1; AllowdUp: Boolean = False);
    {  utility to resize all columns so that they are all visible }
    Procedure FitColumnsToForm;
    {  utility to resize columns to the longest value of a column entry.}
    Procedure FitColumnsToText;
    {  Opens the Utility Dialog window TfrmColumnSelect.  Use can select columns
       to be visible/invisible  (invisible columns have Width = 0 }
    Procedure SelectColumns;
    {  Load the control from any TStrings object. Each item is a '^' delimited
       string of column data  }
    Procedure LoadListFromStrings(t: TStrings);
    {  //prototype.  Highlight the List item that is associated with IObj.
         used to synchronize with selected images in TMag4Viewer}
    Procedure SyncWithIMage(IObj: TImageData);
    {function IndexOfDataStr -  	find location of DataStr in the list.}
    Function IndexOfDataStr(s: String): Integer;
    {function GetDataStr - 	get DataStr from an index in the list.}
    Function GetDataStr(Item: Integer): String;
    {function GetClosestIndex -    Return the closes index to value.  If no entries contain value, return
        first entry alphabetically after value;}
    Function GetClosestIndex(Value: String): Integer;
    {}
    Procedure ClearItems;
  Published
    // change the defaults of certain properties.
    Property ViewStyle Default Vsreport;
    Property ReadOnly Default True;
    Property RowSelect Default True;
    Property HideSelection Default False;
    Property OnListViewRefresh: TMagListViewRefresh Read FMagListViewRefresh Write FMagListViewRefresh;
    {FMagListViewRefresh : TMagListViewRefresh;}
  End;

Procedure Register;

Implementation
Uses FmagColumnSelect;

Constructor TMagListView.Create(AOwner: TComponent);
Begin
  Inherited;
  FColZeroWidth := 50;
  FIImageQuery := Nil;
  OnCompare := DoCompare;
  ViewStyle := Vsreport;
  ReadOnly := True; //
  RowSelect := True;
  HideSelection := False;
  LockSort := False;
End;

Destructor TMagListView.Destroy;
Var
  i: Integer;
Begin
 // 93,94 were calling  ClearItems, but that was causing error , like other LVUtils.
  //  For i := 0 To (Length(FMagListViewDataArray) - 1) Do //RLM Fixing MemoryLeak 6/18/2010
  //FreeAndNil(FMagListViewDataArray[i]);
  {  had above , gek, determine why above wasn't working}
  For i := 0 To (Length(FMagListViewDataArray) - 1) Do //RLM 106 Fixing MemoryLeak 6/18/2010
  Begin
    If FMagListViewDataArray[i]<> nil Then
    Begin
      Try
        FreeAndNil(FMagListViewDataArray[i]);//p106 rlm 20100922 CR 475
      Except
      End;
    End;
  End;
  Inherited;
End;

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagListView]);
End;

Procedure TMagListView.ApplyColumnWidthDefaults;
Var
  i: Integer;
  w: String;
Begin
  Try
    Self.Items.BeginUpdate;
    Try
      If (FColumnWidthDefaults = '') Or (Maglength(FColumnWidthDefaults, ',') = 0) Then
        Exit;
      For i := 1 To Maglength(FColumnWidthDefaults, ',') Do
        If Columns.Count < i Then
          Exit
        Else
        Begin
          w := MagPiece(FColumnWidthDefaults, ',', i);
          If (w = '') Then
            w := '0';
          FColVisible[i - 1] := (w <> '0');
          Columns[i - 1].Width := Strtoint(w);
        End;
    Except
      //
    End;
  Finally
    Self.Items.EndUpdate;
  End;
End;

{       Patch 59 Uses the AddListToList}

Procedure TMagListView.AddListToList(t: TStrings; AtIndex: Integer = -1; AllowdUp: Boolean = False);
Var
  i, Int, j, J2: Integer;
  Li: TListItem;
  ColumnData: String;
  Newcap, NewTitle, CompNew: String;
  Exist: Boolean;

Begin
  If AtIndex = -1 Then
    AtIndex := Items.Count;
  Try
    Self.Items.BeginUpdate;
    J2 := Maglength(MagPiece(t[0], '|', 1), '^');
    For i := t.Count - 1 Downto 0 Do
    Begin
      Exist := False;
      ColumnData := MagPiece(t[i], '|', 1);
      CompNew := MagPiece(ColumnData, '^', 1) + MagPiece(ColumnData, '^', 2);
      Newcap := MagPiece(ColumnData, '^', 1);
      NewTitle := MagPiece(ColumnData, '^', 2);
      If Not AllowdUp Then
        For Int := 0 To Items.Count - 1 Do
        Begin
          If (Items[Int].caption = Newcap) And (Items[Int].SubItems[0] = NewTitle) Then
          Begin
            Exist := True;
            Break;
          End;
        End;
      If Exist Then
        Continue;
      Li := Items.AddItem(Nil, AtIndex);
      Li.caption := MagPiece(ColumnData, '^', 1);
      {        below is where we were adding extra subitems to existing LI}
      For j := 2 To J2 Do
      Begin
        Li.SubItems.Add(MagPiece(ColumnData, '^', j));
      End;
      Li.Data := NewListViewData(MagPiece(t[i], '|', 2));
    End;
    ScrollToItem(Selected);
  Finally
    Self.Items.EndUpdate;
  End;
End;
{Delphi syntax:
function AddItem(Item: TListItem; Index: Integer = -1): TListItem;
Description: Call AddItem to add an Item at any place in the list.
   The properties of Item are duplicated if Item is not nil.
   Index is location of the added item; if Index is negative,
   the TListItem is appended to the end of the list.
   AddItem returns the TListItem that was added.}

Procedure TMagListView.ClearItems;
Var
  i: Integer;

Begin
  {DONE: WE MAY need to loop through Items and Kill any data structures pointed
      to, If we use the Data property to point to information.}
  Try
    {93 out//   visible := false;}
    Self.Items.BeginUpdate;

    For i := Items.Count - 1 Downto 0 Do
    Begin
      { watch the memory usage without this line, shows that this is freeing memory.}
      TMagListViewData(Items[i].Data).Free;
    End;
    //li := nil;
    //GetNextItem(li,sddown,isall);
    Items.Clear;
    // ClearColumns;
  Finally
    Visible := True;
    Self.Items.EndUpdate;
  End;
End;

Procedure TMagListView.SortBycolumn(ColIndex: Integer; VInverse: Boolean);
Var
  i: Integer;
Begin
  Inherited;
  For i := 0 To Columns.Count - 1 Do
  Begin
    Columns[i].AutoSize := False;
  End;
  Finverse := VInverse;
  Fcurcolumnindex := ColIndex;
  //5-23-02 if FInverse then column.ImageIndex := 0
  //5-23-02  else column.ImageIndex := 1;
  If Not LockSort Then
    CustomSort(Nil, 0);

End;

Procedure TMagListView.ColClick(Column: TListColumn);
Begin
  SortBycolumn(Column.Index, Not (Finverse))
End;

Procedure TMagListView.DoCompare(Sender: Tobject; Item1, Item2: TListItem;
  Data: Integer; Var Compare: Integer);
Var
  Lic1, Lic2: String;
  Sortcode: String;
Begin
  //exit;
  Inherited;
  If Fcurcolumnindex = 0 Then
  Begin
    Lic1 := Item1.caption;
    Lic2 := Item2.caption;
  End
  Else
  Begin
    Lic1 := Item1.SubItems[Fcurcolumnindex - 1];
    Lic2 := Item2.SubItems[Fcurcolumnindex - 1];
  End;
  If Copy(Lic1, 1, 1) = '+' Then
    Lic1 := Copy(Lic1, 2, 9999);
  If Copy(Lic2, 1, 1) = '+' Then
    Lic2 := Copy(Lic2, 2, 9999);
  Lic1 := Trim(Lic1);
  Lic2 := Trim(Lic2);
  //S1,S2 are sort codes S1 : date/time, S2 : number.  W* are default column widths W0 : default width of 0 (hidden)
  Sortcode := MagPiece(MagPiece(Fcolumnsorts, '^', Fcurcolumnindex + 1), '~', 2);
  If Sortcode <> '' Then
  Begin
    If Uppercase(Sortcode) = 'S1' Then
    Begin
      SortDateTime(Lic1);
      SortDateTime(Lic2);
    End;
    If Uppercase(Sortcode) = 'S2' Then
    Begin
      SortJustifystring(Lic1);
      SortJustifystring(Lic2);
    End;
    If Uppercase(Sortcode) = 'S3' Then
    Begin
      SortDayCase(Lic1);
      SortDayCase(Lic2);
    End;
  End;

  If Finverse Then
    Compare := -CompareText(Lic1, Lic2)
  Else
    Compare := CompareText(Lic1, Lic2);

End;

Procedure TMagListView.LoadColumns(s: String);
Var
  i, j: Integer;
  Column: TListColumn;
  FSameColumns: Boolean;
Begin
  FSameColumns := True;
  j := Maglength(s, '^');
  //Only clearing columns if the number of columns changed.
  // otherwise we assume the columns are the same
  {TODO: review this clearing of columns logic.}
  // we did delete all columns, and make new ones because we never know
  // what the columns will be, they could change with each Exam Listing.
  If Columns.Count <> j Then
    FSameColumns := False
  Else
    For i := 1 To j Do
    Begin
      If (Columns[i - 1].caption <> MagPiece(MagPiece(s, '^', i), '~', 1)) Then
        FSameColumns := False;
    End;
  If FSameColumns Then
    Exit;
  Columns.Clear;
  For i := 1 To j Do
  Begin
    Column := Columns.Add;
    Column.AutoSize := False;
    // old debugging to show the Sort Code in the Caption
    (*if showrawheaders
       then Column.caption := magpiece(s,'^',i)
       else Column.caption := magpiece(magpiece(s,'^',i),'~',1);
      *)
    Column.caption := MagPiece(MagPiece(s, '^', i), '~', 1);
    // Try to default some columns to 0 width.
    If MagPiece(MagPiece(s, '^', i), '~', 3) = 'W0' Then
      Column.Width := 0 {TODO: this isn't working,  Column width goes to 96 ?}
    Else
      Column.Width := 100; //8/08/01 columnheaderwidth ;
  End;
  // set length of arrays
  SetLength(FColWidth, Columns.Count);
  SetLength(FColVisible, Columns.Count);
  // set minimum width equal to column header
  For i := 0 To Columns.Count - 1 Do
  Begin
    FColWidth[i] := Canvas.Textwidth(Columns[i].caption);
    Columns[i].Width := FColWidth[i] + 15;
    // initially all are visible
    FColVisible[i] := True;
  End;
  // we will only get here if new columns and headers are created.
  ApplyColumnWidthDefaults;
End;

{ any Tstrings can be put into this listview control
  This method expects the first item (t[0]) are the column headers delimited
  by the '^', and all other items are '^' delimited data. }

Procedure TMagListView.LoadListFromStrings(t: TStrings);
Var
  i, j, J2: Integer;
  Li: TListItem;
  ColumnData: String;
  CurViewStyle: Tviewstyle;
Begin
  Visible := False;
  ClearItems;
  CurViewStyle := ViewStyle;
  ViewStyle := Vslist;
  Try
    LoadColumns(t[0]);
    Fcolumnsorts := t[0];
    AllocBy := t.Count + 3;
    J2 := Maglength(MagPiece(t[0], '|', 1), '^');
    For i := 1 To t.Count - 1 Do
    Begin
      ColumnData := MagPiece(t[i], '|', 1);
      Li := Items.Add;
      Li.ImageIndex := -1; //45     Loading from a string (dir listing)
      Li.caption := MagPiece(ColumnData, '^', 1);
      // below is where we were adding extra subitems to existing LI
      For j := 2 To J2 Do
      Begin
        Li.SubItems.Add(MagPiece(ColumnData, '^', j));
      End;
      Li.Data := NewListViewData(MagPiece(t[i], '|', 2));
    End;
  Finally
    If ViewStyle <> CurViewStyle Then
      ViewStyle := CurViewStyle;
    Visible := True;
  End;
End;

Function TMagListView.NewListViewData(Data: String): TMagListViewData;
Begin
  //106   RLM Fixing MemoryLeak 6/18/2010
  {TODO: DETERMINE WHY ATTACHING AS DATA PROPERTY, AND CLEARING ON EXIT WASN'T WORKING}
  SetLength(FMagListViewDataArray, Length(FMagListViewDataArray) + 1);
  FMagListViewDataArray[Length(FMagListViewDataArray) - 1] := TMagListViewData.Create;
  FMagListViewDataArray[Length(FMagListViewDataArray) - 1].Data := Data;
  Result := FMagListViewDataArray[Length(FMagListViewDataArray) - 1];
End;

{Specific to TmagImageList objects.  This will load the list}

Procedure TMagListView.LoadListFromMagImageList(BaseList: TStrings; ObjList: Tlist); //t46 (mil: TMagImageList);
Var
  i, j, J2: Integer;
  Li: TListItem;
  ColumnData: String;
  CurViewStyle: Tviewstyle;
  Maglistviewdata1: TMagListViewData;
Begin
  Visible := False;
  Items.BeginUpdate;
  Try
    ClearItems;
    CurViewStyle := ViewStyle;
    ViewStyle := Vslist;
    Try
      //t46 From here to end, we replaced all mil.baselist to baselist
      //  and mil.objlist to objlist
      If BaseList.Count = 0 Then
        Exit;
      LoadColumns(BaseList[0]);
      Fcolumnsorts := BaseList[0];

      AllocBy := BaseList.Count + 3;
      J2 := Maglength(MagPiece(BaseList[0], '|', 1), '^');
      For i := 1 To BaseList.Count - 1 Do
      Begin
        ColumnData := MagPiece(BaseList[i], '|', 1);
        Li := Items.Add;
        // li.ImageIndex := -1; //45     initial load from imagebase list.
        Li.caption := MagPiece(ColumnData, '^', 1);

        // below is where we were adding extra subitems to existing LI
        For j := 2 To J2 Do
        Begin
          Li.SubItems.Add(MagPiece(ColumnData, '^', j));
        End;
        { each item in the list view holds the internal data needed by
          methods of the control and other interested parties. }
        Maglistviewdata1 := TMagListViewData.Create;
        Maglistviewdata1.Data := MagPiece(BaseList[i], '|', 2);
        Maglistviewdata1.Index := Strtoint(Maglistviewdata1.Data);
        Maglistviewdata1.IObj := ObjList[Maglistviewdata1.Index];
        Li.Data := Maglistviewdata1;
        Li.ImageIndex := Maglistviewdata1.IObj.MagViewStatus; //93
        Li.StateIndex := Self.GetImageState(Maglistviewdata1.IObj);
      End;

    Finally
      If ViewStyle <> CurViewStyle Then
        ViewStyle := CurViewStyle;
      Visible := True;
    End;
  Finally
    Items.EndUpdate;
  End;

End;

Procedure TMagListView.LoadListFromoTIUList(t: Tstringlist);
Var
  i: Integer;
  s: String;
  Li: TListItem;
  TiuObj: TMagTIUData;
  CurViewStyle: Tviewstyle;
Begin
  Visible := False;
  Items.BeginUpdate;
  Try
    // ClearItems;
    CurViewStyle := ViewStyle;
    ViewStyle := Vslist;

    //IF (lv.columns.count = 0 ) then LoadListViewColumns(lvPatientExams,t[0]);

    Try

      //while (lv.items.count > 0) do
      For i := 1 To Items.Count - 1 Do
      Begin
        TiuObj := Items[i].Data;
        //dispose(tiuinfoptr);
        TiuObj.Free;
      End;
      Items.Clear;
      If (t.Count = 0) Then
        Exit;
      // t[0] := t[0] + '^#~S2';  //p59 TIU showadd sort
      LoadColumns(t[0]);
      Fcolumnsorts := t[0];
      AllocBy := t.Count + 3;

      For i := 1 To t.Count - 1 Do
      Begin
        Li := Items.Add;
        //StatusBar2.panels[0].text := inttostr(i+1)+' of '+ inttostr(t.count);
        //StatusBar2.update;
  // 162)=2452^General Note^2910528.1533^HOOD, ROBIN  (H2591)^
  //  10;MELANIE BUECHLER^^completed^Visit: 05/28/91^        ^^0
        If (Maglength(t[i], '^') < 14) Then //p8t38
        Begin
          //p8t38
          Li.caption := 'CORRUPT ENTRY';
          //maggmsgf.MagMsg('','Corrupt entry in Note Listing.');
          //maggmsgf.magmsg('s','*** entry = '+t[i]);
//             TIUInfoPtr := NEW(ptrTIUInfo);
          TiuObj := TMagTIUData.Create;
          TiuObj.TiuDA := '0'; //strtoint(magpiece(t[i], '^', 1));
          TiuObj.IntDT := MagPiece(t[i], '^', 3);
          TiuObj.DispDT := FmtoDispDt(MagPiece(t[i], '^', 3));
          TiuObj.Title := MagPiece(t[i], '^', 2);
          TiuObj.AuthorDUZ := MagPiece(MagPiece(t[i], '^', 5), ';', 1);
          TiuObj.AuthorName := MagPiece(MagPiece(t[i], '^', 5), ';', 2);
          // Patch 7 t6 Added status of TIU Docuemnt ( for CP undictated)
          TiuObj.Status := MagPiece(t[i], '^', 7);
          // TIUInfoPtr.DFN :=  strtoint(             );
          TiuObj.PatientName := MagPiece(t[i], '^', 4);
        End
        Else
        Begin
          Li.caption := MagPiece(t[i], '^', 2);
          Li.StateIndex := -1; //loading from TIU List.
          Li.ImageIndex := -1; //loading from TIU List.
          //TIUInfoPtr := NEW(ptrTIUInfo);
          Li.Data := TMagTIUData.Create;
          TiuObj := Li.Data;
          //TIUObj := TmagTIUData.create;
          TiuObj.TiuDA := MagPiece(t[i], '^', 1);
          TiuObj.IntDT := MagPiece(t[i], '^', 3);
          TiuObj.DispDT := FmtoDispDt(MagPiece(t[i], '^', 3), True);
          TiuObj.Title := MagPiece(t[i], '^', 2);
          TiuObj.AuthorDUZ := MagPiece(MagPiece(t[i], '^', 5), ';', 1);
          TiuObj.AuthorName := MagPiece(MagPiece(t[i], '^', 5), ';', 2);
          // Patch 7 t6 Added status of TIU Docuemnt ( for CP undictated)
          TiuObj.Status := MagPiece(t[i], '^', 7);

          //      TIUInfoPtr.DFN :=  strtoint(             );
          TiuObj.PatientName := MagPiece(t[i], '^', 4);

          If FUseFakeName Then
          Begin
            s := TiuObj.PatientName;
            MagReplaceString(', ', ',', s);
            TiuObj.PatientName := s;
          End;
        End; {else}
        Li.SubItems.Add(TiuObj.DispDT);
        //Li.SubItems.Add(magpiece(t[i],'^',4));
          // Patch 7 t6 Added status of TIU Docuemnt ( for CP undictated)
        Li.SubItems.Add(TiuObj.Status);
        Li.SubItems.Add(TiuObj.AuthorName);
        Li.SubItems.Add(MagPiece(t[i], '^', 11));
        //li.subitems.add(inttostr(i));   //p59 TIU showadd sort
        Li.Data := TiuObj;
        If TiuObj.Status = 'completed' Then
          Li.ImageIndex := 2 //loading from TIU List.
        Else
          Li.ImageIndex := 0; //loading from TIU List.
        If MagPiece(t[i], '^', 11) <> '0' Then
          Li.StateIndex := 1; //loading from TIU List.

      End;
      //StatusBar2.panels[0].text := inttostr(t.count)+' Notes';
    Finally
      If ViewStyle <> CurViewStyle Then
        ViewStyle := CurViewStyle;
      Visible := True;
    End;
  Finally
    Items.EndUpdate;
    Visible := True;
  End;
End;

Procedure TMagListView.SortDateTime(Var Lic: String);
Begin
  (* This was expected format in Johns; lists.
    We need to make it more generic. i.e. handle any date format
   //  02/05/1996@07:08
   lic := copy(lic,7,4)+copy(lic,1,2)+copy(lic,4,2)
             +copy(lic,12,2)+copy(lic,15,2)+copy(lic,18,2);
   *)
  Try
    If Lic <> '' Then
      Lic := Formatdatetime('yyyymmddhhmmnn', Strtodatetime(Lic));
  Except
    // FOR TESTING use this -> SHOWMESSAGE('Execption in Date : ' + lic  );
    Lic := Lic;
  End;
End;

Procedure TMagListView.SortDayCase(Var Lic: String);
Var
  Yr, Mthdy, Xcase: String;
  Int1: Integer;
Begin
  Int1 := Strtoint(Copy(Lic, 5, 2));
  If (Int1 < 5) Then
    Int1 := 2000 + Int1
  Else
    Int1 := 1900 + Int1;
  Yr := Inttostr(Int1);
  Mthdy := Copy(Lic, 1, 4);
  Xcase := MagPiece(Lic, '-', 2);
  Lic := Yr + Mthdy + Xcase;
End;

Procedure TMagListView.SortJustifystring(Var Lic: String);
Begin
  Lic := Copy('0000000000', 1, 10 - Length(Lic)) + Lic;
End;

Procedure TMagListView.SelectColumns;
Begin
  { TODO : Change this method to frmColumnSelect.Execute(self) }
  With TfrmColumnSelect.Create(Self) Do
  Begin
    DisplayColumns(Self);
    Showmodal;
    Release;
  End;
End;

{ Highlite the list entry when the image is selected in another control, (Abs win, Full Win
   Tree View etc ) }

Procedure TMagListView.SyncWithIMage(IObj: TImageData);
Var
  Li: TListItem;
  sync1ien, sync2ien: String;
Begin

  sync1ien := IObj.SyncIENG;

  Li := Self.Selected;
  If (Li <> Nil) And (Li.Data <> Nil) Then
  Begin
    sync2ien := TImageData(TMagListViewData(Li.Data).IObj).SyncIEN;
    If (sync2ien = sync1ien) Then
      Exit;
  End;
  Li := Nil;
  Li := Getnextitem(Li, Sdall, [IsNone]);
  While Li <> Nil Do
  Begin

    If TMagListViewData(Li.Data).IObj.SyncIEN = sync1ien Then
    Begin
      If Not Li.Selected Then
        Li.Selected := True;
      Li.Focused := True; //93
      Self.ItemIndex := Li.Index; //93
      Li.MakeVisible(False);
      Break;
    End;
    Li := Getnextitem(Li, Sdall, [IsNone])
  End;

End;

Function TMagListView.IndexOfDataStr(s: String): Integer;
Var
  i: Integer;
Begin
  Result := -1;
  For i := 0 To Items.Count - 1 Do
  Begin
    If TMagListViewData(Items[i].Data).Data = s Then
    Begin
      Result := i;
      Break;
    End;
  End;
End;

Function TMagListView.GetDataStr(Item: Integer): String;
Begin
  Result := TMagListViewData(Items[Item].Data).Data;
End;

Function TMagListView.GetSelectedImageObj(): TImageData;
Begin
  If Self.Selcount = 0 Then
    Result := Nil
  Else
  Begin
    Result := TMagListViewData(Self.Selected.Data).IObj;
  End;
End;

Procedure TMagListView.ScrollToItem(Li: TListItem);
Begin
  If Li = Nil Then
    Exit;
  ScrollToItem(Li.Index);
End;

Procedure TMagListView.ScrollToItem(ListIndex: Integer);
Var
  Vrc: Integer;
Begin
  Try
    Items.BeginUpdate;
    Vrc := VisibleRowCount;

    If ((TopItem.Index + Vrc) <= ListIndex) Then
    Begin
      While ((TopItem.Index + Vrc) <= ListIndex) Do
      Begin
        Scroll(0, 20);
        Update;
      End;
      //for i := 1 to (vrc div 2) do Scroll(0,20);
      //for i := 1 to (vrc ) do Scroll(0,20);
      Exit;
    End;
    If (TopItem.Index > ListIndex) Then
    Begin
      While (TopItem.Index <> ListIndex) Do
      Begin
        Scroll(0, -20);
        Update;
      End;
      //for i := 1 to (tv div 2) do Scroll(0,-20);
      //fRIDAY   for i := 1 to 1 do Scroll(0,-20);
    End;
  Finally
    Items.EndUpdate;
  End;
End;

Function TMagListView.GetClosestIndex(Value: String): Integer;
Begin
  Result := -1;
  {TODO: finish this.}
End;

procedure TMagListView.ImageStatusChange(vIobj: Timagedata; value: integer);
var
  i: integer;

begin


  for i := 0 to items.count - 1 do
  begin
    if TMagListViewData(items[i].Data).Iobj.Mag0 = vIobj.Mag0 then
    begin
      items[i].ImageIndex := value; {ImageStatusChange}
      break;
    end;
  end;
end;

procedure TmagListView.ImageStateChange(vIobj: Timagedata; value: integer);
var
  i: integer;
    ien : string;  //117
begin
   {/gek 117  if the passed Iobj is in a group, it won't be listed in the 
      Image list here.  so we'll look for it's parent.}
  if vIobj.IsInImageGroup
      then ien  := inttostr(vIobj.IGroupIEN)
      else ien  := vIobj.Mag0;

  for i := 0 to items.count - 1 do
  begin
    if TMagListViewData(items[i].Data).Iobj.Mag0 = ien then
    begin
      items[i].StateIndex := value; {ImageStateChange}
      if value = umagdefinitions.mistDeleted then
      {/gek 117  only want to show 'deleted' if it's not a group}
      if not vIobj.IsImageGroup  then
      begin
        items[i].SubItems[1] := 'Deleted-' + items[i].SubItems[1];
        items[i].SubItems[5] := 'Deleted-' + items[i].SubItems[5];
      end;
      break;
    end;
  end;
end;

(*
procedure TMagListView.FitColumnsToForm;
var lasti, I,spc, cused, viscolct, wmin, curcolw, wused, wxtra, cxtra, wid : integer;
arrb, arrb2 :  array of integer;
begin

cxtra := 0;
wused := 0;
try
// self.Enabled := false;
 spc := 15;
// Items.BeginUpdate;
 ComputeColumnWidths;  {This sets the FColWidths array with min width for each col.}
 viscolct := ComputeVisibleColumns; {This sets FColVisible and returns count of visible columns.}

  setlength(arrb,columns.Count - 1 );
  for i := 0 to columns.Count - 1  do
    if FcolVisible[i] then arrb[i] := -1
                       else arrb[i] := 0;   {we'll skip these}

 cxtra := viscolct;
 wmin := 0;
 wxtra := width - 15;

//repeat
  wmin := wmin + ((wxtra) div cxtra);
  wxtra := ((wxtra) mod cxtra);

for i := 0 to self.Columns.Count - 1 do
  begin
  columns[i].Width := wmin;
  end;
exit;
//////////////////    I give up trying to make it useful.  2 days of memory overun leaks, and just not working is enough.

  cxtra := 0;
  cused := 0;
  for I := 0 to columns.count - 1 do
    begin
        {       if colwidth is less that average, use that and increase the next
                columns width by the amount saved.}
      if (arrb[i]  = -1) then
          begin
          CurColW :=  (FColWidth[i] + spc);
          if  (CurColW < wmin) then
              begin
              arrb[i] := curcolw;
              wxtra  := wxtra + (wmin - curcolw);
              wused := wused + curcolw;
              cused := cused + 1;
              end
              else
              begin
              cxtra := cxtra + 1;
              end;
          end ;
    end;
//until cused = 0;

{       compute new min width and new xtra width start.}

  wmin := (width - 15 - wused) div cxtra ;
  wxtra := ((width - 15 - wused) mod cxtra);

for i := 0 to columns.Count - 1 do
  begin
  if arrb[i] > -1 then columns[i].Width := arrb[i]
                   else
                   begin
                   columns[i].Width := wmin;
                   lasti := i;
                   end;
  end;
columns[lasti].Width := columns[lasti].Width + wxtra;

finally
 // Items.EndUpdate;
//  enabled := true;
end;
end;  *)

Function TMagListView.ComputeXtraWidth(Wmin: Integer): Integer;
Var
  i, Xtra: Integer;
Begin
  Xtra := 0;
  For i := 0 To Columns.Count - 1 Do
  Begin
    If FColVisible[i] Then
      If ((FColWidth[i] + 15) < Wmin) Then
        Xtra := Xtra + (Wmin - (FColWidth[i] + 15));
  End;
  Result := Xtra;
End;

Function TMagListView.ColWidthPlusXtra(Index: Integer; Minwidth: Integer; Var Xtra: Integer): Integer;
Var
  x, i: Integer;
Begin
  //self.Columns[index].width := minwidth;
  //exit;
  If ((FColWidth[Index] + 15) <= Minwidth) Then
  Begin
    Result := (FColWidth[Index] + 15);
    Exit;
  End;

  x := (FColWidth[Index] + 15) - Minwidth;

  If (x >= Xtra) Then
  Begin
    Result := Minwidth + Xtra;
    Xtra := 0;
  End
  Else
  Begin
    Result := Minwidth + x;
    Xtra := Xtra - x;
  End;

End;

Procedure TMagListView.ColumnSetApply(Value: String);
Var
  i: Integer;
Begin
  Try
    Items.BeginUpdate;
    For i := 0 To Columns.Count - 1 Do
    Begin
      Columns[i].Width := MagStrToInt(MagPiece(Value, ',', i + 1));
    End;
  Finally
    Items.EndUpdate;
  End;
End;

Procedure TMagListView.FitColumnsToForm;
Var
  i, Xtra, Cvis, Wmin: Integer;
Begin
  Try
    Self.Items.BeginUpdate;
    ComputeColumnWidths;
    {   get count of visible columns}
    Cvis := ComputeVisibleColumns;
    Wmin := (Width - 15) Div Cvis;
    Xtra := ComputeXtraWidth(Wmin);
    //xtra := xtra - 10 ; if xtra < 0 then xtra := 0;
    For i := 0 To Columns.Count - 1 Do
    Begin
      If FColVisible[i] Then
        Columns[i].Width := ColWidthPlusXtra(i, Wmin, Xtra); {JK 6/5/2009 - replaced with below}
    End;
  Finally
    Self.Items.EndUpdate;
  End;
End;

Procedure TMagListView.FitColumnsToText;
Var
  i, Xtra: Integer;
Begin
  Xtra := 15;
  Try
    Self.Items.BeginUpdate;
    ComputeColumnWidths;
    ComputeVisibleColumns;
    For i := 0 To Columns.Count - 1 Do
    Begin
      If FColVisible[i] Then
        Columns[i].Width := FColWidth[i] + Xtra;
    End;
  Finally
    Self.Items.EndUpdate;
  End;
End;

Function TMagListView.ComputeVisibleColumns: Integer;
Var
  i, Viscolct: Integer;
Begin
  Viscolct := 0;
  {     get count of visible columns.
        and Set the FcolVisible[i] array}
  For i := 0 To Columns.Count - 1 Do
    If (Columns[i].Width > 0) Then
    Begin
      Viscolct := Viscolct + 1;
      FColVisible[i] := True;
    End
    Else
    Begin
      FColVisible[i] := False;
    End;
  Result := Viscolct;
End;

Procedure TMagListView.SetColumnZeroWidth(Value: Integer);
Begin
  FColZeroWidth := Value;
End;

{       Set the FcolWidth[i] array with minimum width of column to see text}

Procedure TMagListView.ComputeColumnWidths;
Var
  i, cc: Integer;
  Li: TListItem;
Begin
  For cc := 0 To Columns.Count - 1 Do
  Begin
    {     to compute column widths when new data, we need to start from minimum}
    If (cc = 0) And (FColZeroWidth > -1) Then
    Begin
      FColWidth[cc] := FColZeroWidth;
      Continue;
    End;
    FColWidth[cc] := Canvas.Textwidth(Columns[cc].caption);
  End;
  Li := Nil;
  Li := Getnextitem(Li, Sdall, [IsNone]);
  While Li <> Nil Do
  Begin
    //IF FColZeroWidth is set. i.e. it is > -1,  then no need to compute;
    If (FColZeroWidth = -1) Then
      If (FColWidth[0] < Canvas.Textwidth(Li.caption)) Then
        FColWidth[0] := Canvas.Textwidth(Li.caption);
    For i := 1 To Columns.Count - 1 Do
      If (FColWidth[i] < Canvas.Textwidth(Li.SubItems[i - 1])) Then
        FColWidth[i] := Canvas.Textwidth(Li.SubItems[i - 1]);
    Li := Getnextitem(Li, Sdall, [IsNone]);
  End;
End;

Procedure TMagListView.SetColumnWidths(ColWidths: String);
Begin
  FColumnWidthDefaults := ColWidths;
  ApplyColumnWidthDefaults;
End;

{       Returns a comma delimited string of col widths}

Function TMagListView.GetColumnWidths: String;
Var
  i: Integer;
Begin
  Result := '';
  For i := 0 To Columns.Count - 1 Do
    Result := Result + Inttostr(Columns[i].Width) + ',';
  Result := Copy(Result, 1, Length(Result) - 1);
End;

Function TMagListView.GetImageState(IObj: TImageData): Integer;
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
End;

Function TMagListView.ColumnSetGetCurrentValue: String;
Var
  i: Integer;
Begin
  Result := '';
  For i := 0 To Columns.Count - 1 Do
  Begin
    Result := Result + Inttostr(Columns[i].Width) + ',';
  End;
  Result := StripFirstLastComma(Result);
End;

End.
