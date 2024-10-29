unit fMAGSelectClinics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, VA508AccessibilityManager;

type
  TfrmSelectClinic = class(TForm)
    amgrMain: TVA508AccessibilityManager;
    lstAvailable: TListBox;
    lstSelected: TListBox;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    btnToSelected2: TButton;
    btnToAvailable2: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnToSelectedClick(Sender: TObject);
    procedure btnToAvailableClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstAvailableKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lstSelectedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure PopulateAvailableClinics;
    procedure MoveToSelected;
    procedure MoveToAvailable;
    procedure RemoveSelectedFromAvailable;
  public
    { Public declarations }
    sSiteIEN: string;
  end;

var
  frmSelectClinic: TfrmSelectClinic;

implementation

uses
  uMAGGlobalsTRA, dmMAGTeleReaderAdmin, MagFMComponents, trpcb, DiTypLib, Fmcmpnts, MagFileVersion;

{$R *.dfm}

procedure TfrmSelectClinic.FormShow(Sender: TObject);
begin
  PopulateAvailableClinics;
  RemoveSelectedFromAvailable;
  GetFormPosition(self);
end;

// Select a clinic
procedure TfrmSelectClinic.lstAvailableKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key = VK_RETURN) and (ssCtrl in Shift) then
    btnToAvailableClick(sender);
end;

// Deselect a clinic
procedure TfrmSelectClinic.lstSelectedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_RETURN) and (ssCtrl in Shift) then
    btnToSelectedClick(sender);
end;

//see string layout of slStationNumners in uMagGlobalsTRA.pas
function GetSiteNameFromIEN(sIEN: string): string;
var i, iPos: integer; sTemp, sSite: string;
begin
  result := emptystr;
  for i := 0 to slStationNumbers.Count - 1 do
  begin
    sTemp := slStationNumbers.strings[i];
    iPos := Pos('=', sTemp);
    sSite := copy(sTemp, 1, iPos - 1);
    sTemp := copy(sTemp, iPos + 1, length(sTemp) - iPos);
    sTemp := MagStrPiece(sTemp, '^', 2);
    if sTemp = sIEN then
    begin
      result := sSite;
      exit;
    end;
  end;
end;

{[Data]
27^99^
6^1A^SALT LAKE CITY
19^2 EAST^SALT LAKE CITY}
procedure TfrmSelectClinic.PopulateAvailableClinics;
var i: integer; sClinRec, sSite: string;
begin
  sSite := GetSiteNameFromIEN(sSiteIEN);
  for i := 1 to slClinicData.Count - 1 do
  begin
    sClinRec := slClinicData.Strings[i];
    if MagStrPiece(sClinRec, '^', 3) = sSite then
      lstAvailable.Items.AddObject(MagStrPiece(sClinRec, '^', 2), TIENObj.Create(MagStrPiece(sClinRec, '^', 1)));
  end;
end;

procedure TfrmSelectClinic.MoveToSelected;
var i: integer;
begin
  for i := lstAvailable.Items.Count - 1 downto 0 do
    if lstAvailable.Selected[i] then
    begin
      lstSelected.Items.AddObject(lstAvailable.Items.Strings[i], lstAvailable.Items.Objects[i]);
      lstAvailable.Items.Delete(i);
    end;
end;

procedure TfrmSelectClinic.MoveToAvailable;
var i: integer;
begin
  for i := lstSelected.Items.Count - 1 downto 0 do
    if lstSelected.Selected[i] then
    begin
      lstAvailable.Items.AddObject(lstSelected.Items.Strings[i], lstSelected.Items.Objects[i]);
      lstSelected.Items.Delete(i);
    end;
end;

procedure TfrmSelectClinic.RemoveSelectedFromAvailable;
var i, NDX: integer;
begin
  for i := lstSelected.Items.Count - 1 downto 0 do
  begin
    NDX := lstAvailable.Items.IndexOf(lstSelected.Items.Strings[i]);
    lstAvailable.Items.Delete(NDX);
  end;
end;

procedure TfrmSelectClinic.btnToSelectedClick(Sender: TObject);
begin
  MoveToSelected;
  btnSave.Enabled := true;
end;

procedure TfrmSelectClinic.btnToAvailableClick(Sender: TObject);
begin
  MoveToAvailable;
  btnSave.Enabled := true;
end;

procedure TfrmSelectClinic.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormPosition(self);
  FreeStringsIENObj(lstAvailable.Items);
end;

end.
