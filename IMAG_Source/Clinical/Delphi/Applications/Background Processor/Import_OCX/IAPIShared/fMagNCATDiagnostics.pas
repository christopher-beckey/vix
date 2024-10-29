unit fMagNCATDiagnostics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMagDefinitions, ButtonGroup, Grids, StdCtrls, ComCtrls, Buttons,
  ExtCtrls;

type
  TfrmNCATDiagnostics = class(TForm)
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
    edSearch: TEdit;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    lbLineNumber: TLabel;
    procedure btnRefreshUrlMapListClick(Sender: TObject);
    procedure lvUrlMapColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvUrlMapClick(Sender: TObject);
    procedure lvUrlMapKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    procedure ShowSelection;
    procedure RefreshUrlMap;
    { Private declarations }
  public

  end;

var
  frmNCATDiagnostics: TfrmNCATDiagnostics;

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

procedure TfrmNCATDiagnostics.BitBtn2Click(Sender: TObject);
var
  i: Integer;
begin
  if edSearch.Text = '' then
  begin
    MessageDlg('Enter a URL', mtInformation, [mbOk], 0);
    Exit;
  end;

  for i := 0 to lvUrlMap.Items.Count - 1 do
    if Pos(edSearch.Text, lvUrlMap.Items[i].Caption) > 0 then
    begin
      lvUrlMap.Selected := lvUrlMap.Items[i];
      lvUrlMap.Selected.MakeVisible(False);
      ShowSelection;
      Break;
    end;

end;

procedure TfrmNCATDiagnostics.BitBtn3Click(Sender: TObject);
begin
  EnclosingFolder := MagImageManager1.CacheDirectory;
  ShellExecute(handle, 'Open', PChar(EnclosingFolder), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmNCATDiagnostics.btnRefreshUrlMapListClick(Sender: TObject);
begin
  RefreshUrlMap;
end;

procedure TfrmNCATDiagnostics.RefreshUrlMap;
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
    li.caption := MagPiece(MappedItem, gsess.MagUrlMap.NVDelimiter, 1);
    li.SubItems.Add(MagPiece(MappedItem, gsess.MagUrlMap.NVDelimiter, 2));
  end;

  lbTotalEntryCount.Caption := 'Url Count = ' + IntToStr(lvUrlMap.Items.Count);
end;

procedure TfrmNCATDiagnostics.FormShow(Sender: TObject);
begin
  RefreshUrlMap;
  lbLineNumber.Caption := 'Line # ' + IntToStr(lvUrlMap.ItemIndex);
end;

procedure TfrmNCATDiagnostics.lvUrlMapClick(Sender: TObject);
begin
  ShowSelection;
  lbLineNumber.Caption := 'Line # ' + IntToStr(lvUrlMap.ItemIndex);
end;

procedure TfrmNCATDiagnostics.lvUrlMapColumnClick(Sender: TObject;
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

  function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
  var
    I1, I2: Integer;
    r1, r2: Boolean;
    s1, s2: String;
  begin
    if Data = 0 then
      {Do a string sort}
      Result := AnsiCompareText(Item1.Caption, Item2.Caption)
    else
    begin
      {Do an integer sort on the third part of the string that contains the incremental part}
      s1 := MagPiece(Item1.SubItems[Data-1], '-', 3);
      s2 := MagPiece(Item2.SubItems[Data-1], '-', 3);
      r1 := IsValidNumber(s1, i1);
      r2 := IsValidNumber(s2, i2);
      Result := ord(r1 or r2);
      if Result <> 0 then
        Result := CompareNumeric(i2, i1);
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

procedure TfrmNCATDiagnostics.lvUrlMapKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DOWN) or (Key = VK_UP) then
  begin
    ShowSelection;
    lbLineNumber.Caption := 'Line # ' + IntToStr(lvUrlMap.ItemIndex);
  end;
end;

procedure TfrmNCATDiagnostics.ShowSelection;
var
  UrlLen: Integer;
begin
  mmoUrl.Lines.Clear;
  if lvUrlMap.Selected <> nil then
  begin
    mmoUrl.Lines.Add(lvUrlMap.Selected.Caption);
    mmoMapped.Lines.Add(lvUrlMap.Selected.SubItems[0]);
    UrlLen := Length(lvUrlMap.Selected.Caption);
    lbUrlLength.Caption := 'Url Length = ' + IntToStr(UrlLen);
    if UrlLen >= 260 then
      lbUrlLength.Font.Color := clRed
    else
      lbUrlLength.Font.Color := clBlack;  
  end;
end;

end.
