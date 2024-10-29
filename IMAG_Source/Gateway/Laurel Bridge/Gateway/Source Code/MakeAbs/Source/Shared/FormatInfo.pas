unit FormatInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, GearFORMATSLib_TLB, AxCtrls, GearVIEWLib_TLB,
  GearDISPLAYLib_TLB, GearPROCESSINGLib_TLB, OleCtrls, GearCORELib_TLB,
  GearDIALOGSLib_TLB;

type
  TfrmFormatInfo = class(TForm)
    btnOK: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    label10: TLabel;
    Label11: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    lblPageNumberValue: TLabel;
    lblFileFormatValue: TLabel;
    lblImageWidthValue: TLabel;
    lblBitDepthValue: TLabel;
    lblCompressionValue: TLabel;
    lblImageHeightValue: TLabel;
    lblColorSpaceValue: TLabel;
    lblChannelCountValue: TLabel;
    lblTileCountValue: TLabel;
    ListBox1: TListBox;
    lblChannelTypeValue: TLabel;
    lblChannelDepthValue: TLabel;
    ListBox2: TListBox;
    lblTileWidthValue: TLabel;
    lblTileHeightValue: TLabel;
    lblDibSizeValue: TLabel;
    lblDibPlanesValue: TLabel;
    lblDibClrUsedValue: TLabel;
    lblDibWidthValue: TLabel;
    lblDibHeightValue: TLabel;
    lblDibBitCountValue: TLabel;
    lblDibClrImportantValue: TLabel;
    lblDibCompressionValue: TLabel;
    lblDibXPelsPerMeterValue: TLabel;
    lblDibImageSizeValue: TLabel;
    lblDibYPelsPerMeterValue: TLabel;
    lblResolutionUnitsValue: TLabel;
    lblResolutionXValue: TLabel;
    lblResolutionYValue: TLabel;
    lblFileNameValue: TLabel;
    lblPageCountValue: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    pageInfo: IGFormatPageInfo;
  public
    { Public declarations }

    formatIOLocation: IIGIOLocation;
    formatCurrentPageNumber: Integer;
    formatTotalPageCount: Integer;
  end;

var
  frmFormatInfo: TfrmFormatInfo;

implementation

uses MainForm;

{$R *.DFM}

procedure TfrmFormatInfo.FormActivate(Sender: TObject);
var
   resInfo: IGImageResolution;
begin

    // retreieve format page info object
    // requires that formatIOLocation, formatCurrentPageNumber, formatTotalPageCount have been previously initialized
    pageInfo := frmMain.IGFormatsCtl1.GetPageInfo(formatIOLocation, formatCurrentPageNumber, IG_FORMAT_UNKNOWN);

    resInfo := pageInfo.ImageResolution;

    // File info
    Case frmMain.ioLocation.Type_ of
        IG_LOC_FILE, IG_LOC_STREAM:
            lblFileNameValue.caption := (frmMain.ioLocation As IGIOFile).FileName;
        IG_LOC_MEMORY:
            lblFileNameValue.caption := 'Memory';
        IG_LOC_URL:
            lblFileNameValue.caption := 'URL';
        Else
            lblFileNameValue.caption := 'unknown!';
    End;

    // set page count based on number of pages in file
    // NOTE: in document mode, it's possible that this value will differ from the page count in igDocument!
    lblPageCountValue.caption := IntToStr(formatTotalPageCount);
    lblFileFormatValue.caption := IntToStr(pageInfo.Format); // TODO use string here

    // Page Info frame
    lblPageNumberValue.caption := IntToStr(formatCurrentPageNumber);
    lblCompressionValue.caption := IntToStr(pageInfo.Compression); // TODO use string here
    lblImageWidthValue.caption := IntToStr(pageInfo.ImageWidth);
    lblImageHeightValue.caption := IntToStr(pageInfo.ImageHeight);
    lblBitDepthValue.caption := IntToStr(pageInfo.BitDepth);

    lblColorSpaceValue.caption := IntToStr(pageInfo.ColorSpace); // TODO use string here
    lblChannelCountValue.caption := IntToStr(pageInfo.ChannelCount);
    lblTileCountValue.caption := IntToStr(pageInfo.TileCount);

    // Channel frame
    {
    updChannel.Min := 0;
    updChannel.Max := pageInfo.ChannelCount;
    updChannel.Value := 0;

    // Tile frame
    updTile.Min := 0;
    updTile.Max := pageInfo.TileCount;
    updTile.Value := 0;
    }

    // DIB frame
    lblDibSizeValue.caption := IntToStr(pageInfo.dibInfo.Size) + (' bytes');
    lblDibWidthValue.caption := IntToStr(pageInfo.dibInfo.Width);
    lblDibHeightValue.caption := IntToStr(pageInfo.dibInfo.Height);

    lblDibPlanesValue.caption := IntToStr(pageInfo.dibInfo.PLANES);
    lblDibBitCountValue.caption := IntToStr(pageInfo.dibInfo.BitCount);
    lblDibCompressionValue.caption := IntToStr(pageInfo.dibInfo.Compression);
    lblDibImageSizeValue.caption := IntToStr(pageInfo.dibInfo.ImageSize) + (' bytes');

    lblDibXPelsPerMeterValue.caption := IntToStr(pageInfo.dibInfo.XPelsPerMeter);
    lblDibYPelsPerMeterValue.caption := IntToStr(pageInfo.dibInfo.YPelsPerMeter);
    lblDibClrUsedValue.caption := IntToStr(pageInfo.dibInfo.ClrUsed);
    lblDibClrImportantValue.caption := IntToStr(pageInfo.dibInfo.ClrImportant);

    // Resolution frame
    lblResolutionUnitsValue.caption := IntToStr(resInfo.Units); // TODO use string here
    lblResolutionXValue.caption := IntToStr(resInfo.XNumerator) + ' / ' + IntToStr(resInfo.XDenominator);
    lblResolutionYValue.caption := IntToStr(resInfo.YNumerator) + ' / ' + IntToStr(resInfo.YDenominator);

end;

procedure TfrmFormatInfo.btnOKClick(Sender: TObject);
begin

   Close;

end;

end.
