unit uMagCapDef;

interface
Uses
  Classes,
  Controls,
  Graphics,
  ExtCtrls
  //
  , uMagClasses
  , uMagDefinitions
  , uMagutils8
  ;
const

   mcSrcLumisys75 = 1;
   mcSrcLumisys150 = 2;
   mcSrcMeteor = 3;
   mcSrcTwain = 4;
   mcSrcClipboard = 5;
   mcSrcImport = 6;
   mcSrcScanDoc = 7;

Type
 { CapX}
  TCapConfigObj = Class(Tobject)
  Private

  {}
  Public
  {var}
    mSourceID : integer;
    mScanMode : string;

    mBatch : boolean;
    mMultipage : boolean;
    mTwain : boolean;
    mTwainWindow : boolean;

    m140RLE : boolean  ;
    m140JPG : boolean;
    m140MultSources : boolean;
    m140PDFConvert : boolean;
    m140CombineScans : boolean;

  mOtherDesc : string;
  mFormatDesc : string; //Frmcapmain.Lbformatdesc.caption := 'Xray(8 bit)';
  mFormat : string; //= '.TGA'; {var format}
  mImageType : integer; // := 3;   This maps to a VISTA FM File.   Ojbect Type.

  mIGSaveFormat : integer; //= mag_IG_SAVE_TGA;     kk

  mIGScanFormat : integer; // := mag_IG_FORMAT_BMP;     kk
  mIGScanPixelType : integer; // := mag_IG_TW_PT_GRAY;   kk
  mIGScanCompression : integer; // := mag_IG_COMPRESSION_NONE;   kk
  mIGScanBitDepth : integer; // := 8;                   kk

  mIGSaveJPEGQuality : integer;          //          kk

  {functions}
   Function GetSourceDesc: string;
   Function GetFormatDesc: String;
 //  Function mFormatDesc : string;
  {Procedures}

  End;


var

 CapX :  TCapConfigObj;

implementation


{ TCapConfigObj }

function TCapConfigObj.GetFormatDesc: String;
begin
  Result := self.mFormatDesc;
  if self.m140PDFConvert then
     begin
        Result := 'Adobe PDF';
     end;
end;

function TCapConfigObj.GetSourceDesc: string;
begin
   case mSourceID of
   mcSrcLumisys75 : result := 'Lumisys75';
   mcSrcLumisys150 : result := 'Lumisys150';
   mcSrcMeteor : result := 'Meteor';
   mcSrcTwain : result := 'Twain';
   mcSrcClipboard : result := 'Clipboard';
   mcSrcImport : result := 'Import';
   mcSrcScanDoc : result := 'ScanDoc';
   end;
end;



end.
