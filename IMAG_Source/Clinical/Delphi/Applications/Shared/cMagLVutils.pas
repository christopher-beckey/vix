unit cMagLVutils;
{
 Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created: 3.0.7
Site Name: Silver Spring, OIFO
Developers: Garrett Kirin
[==   unit cMagLVutils;
Description: Image ListView Utilities ( Predecessor to cMagListView.pas)
      This component is designed to be a set of utilities that operate on
      a Delphi TListView component.
      It has a  property ListView: TlistView that can be set at design time.
      All methods of this component operate on the ListView defined as the
      ListView property.
      This design allows the developer to use one TMagLVUtils object as a tool
      for  multiple ListView components.  Changing the ListView property of the
      TMagLVUtils component to the control to be operated on.
      A newer component cMagListView.pas inherits from TListView rather than
      having a pointer to in instance of one is used in Imaging Display
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
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  comctrls, umagutils8
  , imaginterfaces   //122 put in message RCA changed it to magappmsg
  ;
type
  { the listitem.data property will point to an object of this Type}
  TMagLVData = class(Tobject)
  public
    Data: string;
  end;

type
  TMagLVutils = class(Tcomponent)
  private
    Flview: TListView;
    Fcurcolumnindex: integer;
    Fcolumnsorts: string;
    Finverse: boolean;
    procedure ClearColumns;
    procedure LoadColumns(s: string);
    { Integers are strings justified to sort correctly}
    procedure SortJustifystring(var lic: string);
    { Date time values converted to string equivalent to sort correctly}
    procedure SortDateTime(var lic: string);
    {  Specific to VistARad : Radiology Day/Case number}
    procedure SortDayCase(var lic: string);
    {  Create a new instance of object, to store additional data for list item}
    function NewLVData(data: string): TMagLVData;
    {  Create a new instance of object, to store additional data for list item}
    procedure NewLVData2(data: string; var vMagLVData: TMagLVData);
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(Aowner: TComponent);
    destructor Destroy; override;
    {  Load the control from any TStrings object. Each item is a '^' delimited
   string of column data  }
    procedure LoadListFromStrings(t: tstrings; VisibleAtEnd: boolean = true);
    {  //prototype, not used.  Adds one list to another}
    procedure AddListToList(t: tstrings);
    procedure DoColumnSort(Sender: TObject; Column: TListColumn);
    {  called internally to do the sorting of 2 items}
    procedure DoCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure ResizeColumns;
    procedure ClearItems;
    procedure FitLVColumnsToText;
    { prompts user to save list items to a Text File.}
    procedure SaveToFile(Filename: string);
    { Public declarations }
  published
    { The Delphi ListView component to operate on.}
    property ListView: TlistView read Flview write Flview;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('imaging', [TMagLVutils]);
end;

{ TMagLVutils }

procedure TMagLVutils.ClearColumns;
begin

  FLView.Columns.Clear;
end;

procedure TMagLVutils.ClearItems;
var
  i: integer;
  vMagLVData: TMagLVData;
begin
(* this was in to make this simpler, but it didn't call ClearColumns
  if ( not assigned(FLVIew) or (FLView = nil)) then exit;
FLView.Columns.Clear;
exit;
*)
  // WE MAY need to loop through Items and Kill any data structures pointed
  //   to, If we use the Data property to point to information.

  if (FLView.Items.Count > 0) then
  begin
    try
      for i := FLView.items.count - 1 downto 0 do
      begin
        // testing memory usage without this line, shows that
        //  this is freeing memory.
     /////TMagLVdata(FLView.items[i].data).free;

        vMagLVData := FLView.items[i].data;
        vMagLVData.free;
      end;

      //li := nil;
      //FLView.GetNextItem(li,sddown,isall);

      FLView.items.Clear;
      ClearColumns;
    except
      //
    end;
  end;
end;

constructor TMagLVutils.Create(Aowner: TComponent);
begin
    inherited;
  //
end;

destructor TMagLVutils.Destroy;
begin

  try
    if not application.Terminated then
      clearitems;
  except
    on E:Exception do
      magappmsg('s', 'TMagLVutils.Destroy exception = ' + E.Message);  {/ P122T10 - JK 11/21/2011. Added a logging call. /}
  end;
  inherited;
end;

procedure TMagLVutils.DoColumnSort(Sender: TObject; Column: TListColumn);
var
  I: integer;
begin
  for i := 0 to FLView.Columns.Count - 1 do
  begin
    FLview.column[i].AutoSize := false;
    FLview.column[i].minwidth := FLview.column[i].width;
    FLview.column[i].maxwidth := FLview.column[i].width;
    FLView.Column[i].ImageIndex := -1;
  end;
  FInverse := not FInverse;
  Fcurcolumnindex := column.index;
  if FInverse then
    column.ImageIndex := 0
  else
    column.ImageIndex := 1;
  FLView.customsort(nil, 0);
end;

procedure TMagLVutils.DoCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  lic1, lic2: string;
  sortcode: string;
begin


  if Fcurcolumnindex = 0 then
  begin
    lic1 := item1.caption;
    lic2 := item2.caption;
  end
  else
  begin
    lic1 := item1.SubItems[Fcurcolumnindex - 1];
    lic2 := item2.SubItems[Fcurcolumnindex - 1];
  end;
  if copy(lic1, 1, 1) = '+' then
    lic1 := copy(lic1, 2, 9999);
  if copy(lic2, 1, 1) = '+' then
    lic2 := copy(lic2, 2, 9999);
  lic1 := trim(lic1);
  lic2 := trim(lic2);
  { S1,S2 are sort codes S1 : date/time, S2 : number.  W* are default column widths W0 : default width of 0 (hidden)}
  sortcode := magpiece(magpiece(fcolumnsorts, '^', Fcurcolumnindex + 1), '~', 2);
  if sortcode <> '' then
  begin
    if uppercase(sortcode) = 'S1' then
    begin
      SortDateTime(lic1);
      SortDateTime(lic2);
    end;
    if uppercase(sortcode) = 'S2' then
    begin
      SortJustifystring(lic1);
      SortJustifystring(lic2);
    end;
    if uppercase(sortcode) = 'S3' then
    begin
      SortDayCase(lic1);
      SortDayCase(lic2);
    end;
  end;

  if FInverse then
    COMPARE := -CompareText(LIC1, LIC2)
  else
    COMPARE := CompareText(LIC1, LIC2);

end;

procedure TMagLVutils.LoadColumns(s: string);
var
  i, j: integer;
  Column: TListColumn;
begin
  j := maglength(s, '^');
  // new 8/99 WE delete all columns, and make new ones because we never know
  // what the columns will be, they could change with each Exam Listing.
  FLView.columns.clear;
  for I := 1 to j do
  begin
    Column := FLView.columns.add;
    // later , take out this comment
    (*if showrawheaders
       then Column.caption := magpiece(s,'^',i)
       else Column.caption := magpiece(magpiece(s,'^',i),'~',1);
      *)
    Column.caption := magpiece(magpiece(s, '^', i), '~', 1);
    Column.width := columntextwidth; //8/08/01 columnheaderwidth ;
    //columntextwidth;  // auto resize to fit text
   //Column.Alignment := taCenter;
    Column.AutoSize := false;
  end;
end;

procedure TMagLVutils.LoadListFromStrings(t: tstrings; VisibleAtEnd: boolean = true);
var
  i, j, j2: integer;
  Li: Tlistitem;
  columndata: string;
  curviewstyle: Tviewstyle;
  vMagLVData: TMagLVData;
begin
  ClearItems;
  FLView.visible := false;
  curviewstyle := FLView.viewstyle;
  FLView.viewstyle := vslist;
  LoadColumns(t[0]);
  Fcolumnsorts := t[0];
  t.delete(0);
  with FLView do
  begin
    try

      AllocBy := t.count + 3;
      j2 := maglength(magpiece(t[0], '|', 1), '^');
      for I := 0 to t.count - 1 do
      begin
        columndata := magpiece(t[i], '|', 1);
        Li := Items.Add;
        Li.Caption := magpiece(columndata, '^', 1);
        { below is where we were adding extra subitems to existing LI}
        for J := 2 to j2 do
        begin
          Li.SubItems.Add(magpiece(columndata, '^', j));
        end;
        vMagLVData := TMagLVData.create;
        vMagLVData.Data := (magpiece(t[i], '|', 2));
        li.data := vMagLVData;
//        vMagLVData := nil;
        LI.ImageIndex := -1;
      end;
    finally
      if FLView.ViewStyle <> curviewstyle then
        FLView.viewstyle := curviewstyle;
      if VisibleAtEnd then
        FLView.visible := true;
    end;
  end;
end;

procedure TMagLVutils.AddListToList(t: tstrings);
// THIS HAS NOT BEEN TESTED.  01/18/2002
var
  i, j, j2: integer;
  Li: Tlistitem;
  columndata: string;
  //load curviewstyle : Tviewstyle;
begin
  //load ClearItems;
  //load LView.visible := false;
  //load curviewstyle := FLView.viewstyle;
  //load FLView.viewstyle := vslist;

  //load LoadColumns(t[0]);
  //load Fcolumnsorts := t[0];
  //load t.delete(0);
  with FLView do
  begin
    try
      //load AllocBy := t.count+3;
      j2 := maglength(magpiece(t[0], '|', 1), '^');
      for I := 0 to t.count - 1 do
      begin
        columndata := magpiece(t[i], '|', 1);
        Li := Items.Add;
        Li.Caption := magpiece(columndata, '^', 1);
        // below is where we were adding extra subitems to existing LI
        for J := 2 to j2 do
        begin
          Li.SubItems.Add(magpiece(columndata, '^', j));
        end;
        li.data := NewLVData(magpiece(t[i], '|', 2));
        LI.ImageIndex := -1;
      end;
    finally
      //load if FLView.ViewStyle <> curviewstyle  then FLView.viewstyle := curviewstyle;
      //load FLView.visible := true;
    end;
  end;
end;

function TMagLVutils.NewLVData(data: string): TMagLVData;

begin
  result := TMagLVData.create;
  result.Data := data;
end;

procedure TMagLVutils.ResizeColumns;
var
  I: integer;
begin

  for I := 0 to FLView.columns.count - 1 do
  begin
    FLView.columns[i].width := columntextwidth;
    (*case i of
         2 : lvradexams.columns[i].width := columnheaderwidth;
         end;
         *)
  end;
end;

procedure TMagLVutils.SortDateTime(var lic: string);
begin
  (* This was expected format in Johns; lists.
    We need to make it more generic. i.e. handle any date format
   //  02/05/1996@07:08
   lic := copy(lic,7,4)+copy(lic,1,2)+copy(lic,4,2)
             +copy(lic,12,2)+copy(lic,15,2)+copy(lic,18,2);
   *)
  try
    lic := formatdatetime('yyyymmddhhmmnn', strtodatetime(lic));
  except
    lic := lic;
  end;
end;

procedure TMagLVutils.SortDayCase(var lic: string);
var
  yr, mthdy, xcase: string;
  int1: integer;
begin
  int1 := strtoint(copy(lic, 5, 2));
  if (int1 < 5) then
    int1 := 2000 + int1
  else
    int1 := 1900 + int1;
  yr := inttostr(int1);
  mthdy := copy(lic, 1, 4);
  xcase := magpiece(lic, '-', 2);
  lic := yr + mthdy + xcase;
end;

procedure TMagLVutils.SortJustifystring(var lic: string);
begin
  lic := copy('0000000000', 1, 10 - length(lic)) + lic;
end;

procedure TMagLVutils.FitLVColumnsToText;
var
  i: integer;
begin

  for I := 0 to FLView.Columns.Count - 1 do
  begin
    FLView.columns[i].Width := columnheaderwidth;
    FLView.columns[i].Width := columntextwidth;
    //Column.Alignment := taCenter;
    //Column.AutoSize := false;
  end;

end;

procedure TMagLVutils.SaveToFile(Filename: string);
var
  i, j: integer;
  li: tlistitem;
  t: tstrings;
  s: string;
begin
  t := tstringlist.create;
  try
    t.add(Fcolumnsorts);
    for i := 0 to FLView.items.count - 1 do
    begin
      li := FLView.items[i];
      s := li.Caption;
      for j := 0 to li.SubItems.Count - 1 do
      begin
        s := s + '^' + li.SubItems[j];
      end;
      t.add(s);
    end;
    t.savetofile(filename);
  finally
    t.free;
  end;
end;

procedure TMagLVutils.NewLVData2(data: string; var vMagLVData: TMagLVData);
begin
  //  result := TMagLVData.create;
  //  result.Data := data;
end;

end.

