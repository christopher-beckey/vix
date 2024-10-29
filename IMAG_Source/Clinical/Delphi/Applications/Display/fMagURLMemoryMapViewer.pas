unit fMagURLMemoryMapViewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMagDefinitions, ButtonGroup, Grids, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, cMagImageList, uMagClasses;

type
  TfrmURLMemoryMapViewer = class(TForm)
    Panel1: TPanel;
    btnRefreshUrlMapList: TBitBtn;
    Panel2: TPanel;
    lvUrlMap: TListView;
    Splitter1: TSplitter;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    lbTotalEntryCount: TLabel;
    mmoUrl: TMemo;
    mmoMapped: TMemo;
    lbUrlLength: TLabel;
    lbLineNumber: TLabel;
    Panel4: TPanel;
    BitBtn2: TBitBtn;
    edSearch: TEdit;
    BitBtn3: TBitBtn;
    procedure btnRefreshUrlMapListClick(Sender: TObject);
    procedure lvUrlMapColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvUrlMapClick(Sender: TObject);
    procedure lvUrlMapKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure ShowSelection;
    procedure RefreshUrlMap;
    function ParseMimeType(S: String): String;
    function GetIObjNumber(S: String): String;
    { Private declarations }
  public
    procedure Execute(const ImgList: TMagImageList);
  end;

var
  frmURLMemoryMapViewer: TfrmURLMemoryMapViewer;

implementation

{$R *.dfm}

uses
  uMagUtils8,
  MagImageManager,
  ShellAPI;

var
  LastSortedColumn: Integer;
  Ascending: Boolean;
  EnclosingFolder: String;
  LocalObjList: TStringList;

procedure TfrmURLMemoryMapViewer.Execute(const ImgList: TMagImageList);
var
  i: Integer;
begin
  if LocalObjList = nil then
    LocalObjList := TStringList.Create;

  LocalObjList.Clear;
  for i := 0 to ImgList.ObjList.Count - 1 do
    LocalObjList.Add(TImageData(ImgList.ObjList[i]).FFile);
     

  RefreshUrlMap;

  lbLineNumber.Caption := 'Line # ' + IntToStr(lvUrlMap.ItemIndex);

  Show;
end;

procedure TfrmURLMemoryMapViewer.BitBtn2Click(Sender: TObject);
var
  i: Integer;
  StartPoint: Integer;
begin
  if edSearch.Text = '' then
  begin
    MessageDlg('Enter a URL', mtInformation, [mbOk], 0);
    Exit;
  end;

  if lvUrlMap.Selected = nil then
    StartPoint := 0
  else
    StartPoint := lvUrlMap.Selected.Index+1;

  if StartPoint > lvUrlMap.Items.Count then
  begin
    MessageDlg('Reached end of list', mtInformation, [mbOK], 0);
    Exit;
  end;

  for i := StartPoint to lvUrlMap.Items.Count - 1 do
    if Pos(edSearch.Text, lvUrlMap.Items[i].SubItems[2]) > 0 then
    begin
      lvUrlMap.Selected := lvUrlMap.Items[i];
      lvUrlMap.Selected.MakeVisible(False);
      ShowSelection;
      Break;
    end;

end;

procedure TfrmURLMemoryMapViewer.BitBtn3Click(Sender: TObject);
begin
  EnclosingFolder := MagImageManager1.CacheDirectory;
  ShellExecute(handle, 'Open', PChar(EnclosingFolder), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmURLMemoryMapViewer.btnRefreshUrlMapListClick(Sender: TObject);
begin
  RefreshUrlMap;
end;

procedure TfrmURLMemoryMapViewer.RefreshUrlMap;
var
  i: Integer;
  li: TListItem;
  MappedItem: String;
begin
  lvUrlMap.Items.Clear;

  for i := 0 to gsess.MagUrlMap.Count - 1 do
  begin
    li := TListItem.Create(lvUrlMap.Items);
    li := lvUrlMap.Items.Add();
    MappedItem := gsess.MagUrlMap.Get(i);

    li.Caption := ParseMimeType(MagPiece(MappedItem, gsess.MagUrlMap.NVDelimiter, 1));
    li.SubItems.Add(GetIObjNumber(MagPiece(MappedItem, gsess.MagUrlMap.NVDelimiter, 1)));
    li.SubItems.Add(MagPiece(MappedItem, gsess.MagUrlMap.NVDelimiter, 2));
    li.SubItems.Add(MagPiece(MappedItem, gsess.MagUrlMap.NVDelimiter, 1));

  end;

  lbTotalEntryCount.Caption := 'Url Count = ' + IntToStr(lvUrlMap.Items.Count);
end;

function TfrmURLMemoryMapViewer.ParseMimeType(S: String): String;
var
  MimeItem: String;
  MimeItemPos: Integer;
begin
  MimeItemPos := Pos('&imageQuality', S);
  if MimeItemPos > 0 then  
  begin
    MimeItem := Copy(S, MimeItemPos, (Length(S) - MimeItemPos + 1));
    if Pos('20', MimeItem) > 0 then
      Result := 'ABS '
    else if Pos('70', MimeItem) > 0 then
      Result := 'REF '
    else if (Pos('90', MimeItem) > 0) or (Pos('100', MimeItem) > 0) then
      Result := 'DIAG '
    else
      Result := '';
  end;

  MimeItemPos := Pos('&contentType', S);
  if MimeItemPos > 0 then
  begin
    MimeItem := Copy(S, MimeItemPos, (Length(S) - MimeItemPos + 1));
    if Pos('image/jpeg', MimeItem) > 0 then
      Result := Result  + 'jpeg'
    else
    if Pos('application/pdf', MimeItem) > 0 then
      Result := Result  + 'pdf'
    else if Pos('application/msword', MimeItem) > 0 then
      Result := Result  + 'msword'
    else if Pos('text/plain', MimeItem) > 0 then
      Result := Result  + 'ascii'
    else if Pos('application/dicom', MimeItem) > 0 then
      if Pos('image/j2k', MimeItem) > 0 then
        Result := Result  + 'dicom/j2k'
      else
        Result := Result  + 'dicom'
    else
      Result := Result  + ''
  end
  else
    Result := Result  + 'no mime';

end;

procedure TfrmURLMemoryMapViewer.FormDestroy(Sender: TObject);
begin
  LocalObjList.Free;
end;

procedure TfrmURLMemoryMapViewer.lvUrlMapClick(Sender: TObject);
begin
  ShowSelection;
  lbLineNumber.Caption := 'Line # ' + IntToStr(lvUrlMap.ItemIndex);
end;

procedure TfrmURLMemoryMapViewer.lvUrlMapColumnClick(Sender: TObject;
  Column: TListColumn);

  function IsValidNumber(AString : string; var AInteger : Integer): Boolean;
  var
    Code: Integer;
  begin
    Val(AString, AInteger, Code);
    Result := (Code = 0);
  end;

  function CompareNumeric(AInt1, AInt2: Integer): Integer;
  begin
    if AInt1 > AInt2 then
      Result := 1
    else
      if AInt1 = AInt2 then
        Result := 0
    else
      Result := -1;
  end;

  function IntegerInAStringSort(Item1, Item2: TListItem; Data: Integer): Integer;
  var
    I1, I2: Integer;
    R1, R2: Boolean;
    S1, S2: String;
  begin
    S1 := MagPiece(Item1.SubItems[Data-1], '-', 3);
    if Pos('.', S1) > 0 then
      S1 := Copy(S1, 1, Pos('.', S1)-1);

    S2 := MagPiece(Item2.SubItems[Data-1], '-', 3);
    if Pos('.', S2) > 0 then
      S2 := Copy(S2, 1, Pos('.', S2)-1);

    R1 := IsValidNumber(S1, i1);
    R2 := IsValidNumber(S2, i2);
    Result := ord(r1 or r2);
    if Result <> 0 then
      Result := CompareNumeric(i2, i1);
  end;

  function IntegerSort(Item1, Item2: TListItem; Data: Integer): Integer;
  var
    I1, I2: Integer;
    R1, R2: Boolean;
    S1, S2: String;
  begin
    S1 := Item1.SubItems[Data-1];
    S2 := Item2.SubItems[Data-1];
    R1 := IsValidNumber(S1, i1);
    R2 := IsValidNumber(S2, i2);
    Result := ord(r1 or r2);
    if Result <> 0 then
      Result := CompareNumeric(i2, i1);
  end;

  function SortByColumn(Item1, Item2: TListItem; Data: Integer): integer; stdcall;
  begin
    case Data of
      0,3: Result := AnsiCompareText(Item1.Caption, Item2.Caption); {Do a straight string sort}
      1:   Result := IntegerSort(Item1, Item2, Data);  {Do an integer sort}
      2:   Result := IntegerInAStringSort(Item1, Item2, Data); {Do an integer sort on the third part of the string that contains the incremental part}
    end;

    if not Ascending then
      Result := -Result;
  end;
begin
    if Column.Index = LastSortedColumn then
      Ascending := not Ascending
    else 
      LastSortedColumn := Column.Index; 
    TListView(Sender).CustomSort(@SortByColumn, Column.Index);

end;

procedure TfrmURLMemoryMapViewer.lvUrlMapKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) or (Key = VK_UP) then
  begin
    ShowSelection;
    lbLineNumber.Caption := 'Line # ' + IntToStr(lvUrlMap.ItemIndex);
  end;
end;

procedure TfrmURLMemoryMapViewer.ShowSelection;
var
  UrlLen: Integer;
begin
  mmoUrl.Lines.Clear;
  if lvUrlMap.Selected <> nil then
  begin
    mmoUrl.Lines.Add(lvUrlMap.Selected.SubItems[2]);
    mmoMapped.Lines.Add(lvUrlMap.Selected.SubItems[1]);
    UrlLen := Length(lvUrlMap.Selected.SubItems[2]);
    lbUrlLength.Caption := 'Url Length = ' + IntToStr(UrlLen);
    if UrlLen >= 260 then
      lbUrlLength.Font.Color := clRed
    else
      lbUrlLength.Font.Color := clBlack;  
  end;
end;

function TfrmURLMemoryMapViewer.GetIObjNumber(S: String): String;
var
  i: Integer;
begin
  Result := '';

  for i := 0 to LocalObjList.Count - 1 do
    if Trim(S) = Trim(LocalObjList[i]) then
    begin
      Result := IntToStr(i+1);
      Break;
    end;
end;

end.
