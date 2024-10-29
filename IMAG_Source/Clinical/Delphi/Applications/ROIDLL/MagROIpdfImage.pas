unit MagROIpdfImage;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   March, 2012
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==   unit MagROIpdfImage.pas
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, ToolWin, ExtCtrls, CheckLst, Menus,
  ActiveX, Buttons, Math, GearPDFLib_TLB, GearCoreLib_TLB,
  cMag_ROI_IGManager;

	function CreateColorSpace(Page: IGPage): IGPDEColorSpace;
	function CreateEncoding(Encoding: enumIGPDFTextEncoding): IGPDEFilterSpec;
	function CreateCompression(curPDFDoc: IGPdfDoc; Page: IGPage; Compression: enumIGPDFCompressions): IGPDEFilterSpec;
	function CreateImageAttrs(Page: IGPage): IGPDEImageAttrs;
	function IsPaletteGray(BitDepth: Longint; palette: IGPalette): Boolean;
	function GetPixels(Page: IGPage; bIsRGBA: Boolean; var pixels: IGIntegerArray; pixelsSM: IGIntegerArray): OleVariant;
	function CreateImagePage(Width: Longint; Height: Longint; ChannelCount: Longint; ChannelDepth: Longint; pixels: IGIntegerArray; palette: IGIntegerArray): IGPage;
	function Unpack1bitPixel(pixels: IGIntegerArray; RasterSize: Longint; X: Smallint; Y: Smallint): Longint;
	function Unpack4bitPixel(pixels: IGIntegerArray; RasterSize: Longint; X: Smallint; Y: Smallint): Longint;
	procedure ProcessRGBARaster(Src: IGPixelArray; Dst: IGIntegerArray; DstSM: IGIntegerArray; Index: Longint; Count: Longint);
	procedure Pack4bitRaster(Src: IGPixelArray; Dst: IGIntegerArray; Index: Longint; Count: Longint);
	procedure UnpackRaster(ChannelCount: Longint; ChannelDepth: Longint; PixelCount: Longint; Source: IGIntegerArray; dest: IGIntegerArray; Line: Longint; DestBytes: Longint);

implementation

function CreateColorSpace(Page: IGPage): IGPDEColorSpace;
var
	csAtom: IGPDFAtom;
	pdeColorSpace, pdeBaseColorSpace: IGPDEColorSpace;
	palette: IGPalette;
	bIsRGBA: Boolean;
	nResBitDepth: Longint;
	pdeColorData: IGPDEColorData;
	i: Smallint;
begin
	try

		pdeColorSpace := nil;
		pdeBaseColorSpace := nil;

		bIsRGBA := (IG_COLOR_SPACE_RGBA=Page.ColorSpace) and (32=Page.BitDepth);

		if (bIsRGBA) then begin
			nResBitDepth := 24;
		end else begin
			nResBitDepth := Page.BitDepth;
		end;

    csAtom := GetIGManager.IGPdfCtrl.CreateObject(IG_PDF_ATOM) as IIGPDFAtom;

		// Specify the correct color space
		if (nResBitDepth >= 1) and (nResBitDepth <= 8) then
    begin

			if Page.GetPaletteSize > 0 then
      begin
				palette := Page.GetPaletteCopy;
			end;

			if IsPaletteGray(nResBitDepth, palette) then
      begin
				csAtom.String_ := 'DeviceGray';
				pdeColorSpace := GetIGManager.IGPdfCtrl.CreatePDEColorSpace(csAtom, nil);
			end else
      begin
				csAtom.String_ := 'DeviceRGB';
				pdeBaseColorSpace := GetIGManager.IGPdfCtrl.CreatePDEColorSpace(csAtom, nil);
			end;
		end
		else if nResBitDepth = 24 then
    begin
			csAtom.String_ := 'DeviceRGB';
			pdeColorSpace := GetIGManager.IGPdfCtrl.CreatePDEColorSpace(csAtom, nil);
		end
		else if nResBitDepth = 32 then
    begin
			csAtom.String_ := 'DeviceCMYK';
			pdeColorSpace := GetIGManager.IGPdfCtrl.CreatePDEColorSpace(csAtom, nil);
		end;

		if  pdeBaseColorSpace <> nil then
    begin
			pdeColorData := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_COLORDATA) as IIGPDEColorData;

      pdeColorData.type_ := IG_INDEXED;
			pdeColorData.Indexed.BaseColorSpace := pdeBaseColorSpace;
			pdeColorData.Indexed.HiVal := palette.Size - 1;
			pdeColorData.Indexed.LookUp.Resize(palette.Size * 3, 1);

			for i := 0 to pdeColorData.Indexed.LookUp.Size - 1 do
      begin
				pdeColorData.Indexed.LookUp.Item[i*3]   := palette.Red[i];
				pdeColorData.Indexed.LookUp.Item[i*3+1] := palette.Green[i];
				pdeColorData.Indexed.LookUp.Item[i*3+2] := palette.Blue[i];
			end; // i

			csAtom.String_ := 'Indexed';
			pdeColorSpace := GetIGManager.IGPdfCtrl.CreatePDEColorSpace(csAtom, pdeColorData);
		end;

		Result := pdeColorSpace;

	except
		GetIGManager.checkErrors();
	end;
end;

function CreateEncoding(Encoding: enumIGPDFTextEncoding): IGPDEFilterSpec;
var
	pdeFilterSpec: IGPDEFilterSpec;
	name, key: IGPDFAtom;
begin
	try

		pdeFilterSpec := nil;

		// Set text encoding
    if Encoding = IG_PDF_ENCODING_ASCII_85 then begin
			pdeFilterSpec := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_FILTERSPEC) as IIGPDEFilterSpec;
			pdeFilterSpec.name.String_ := 'ASCII85Decode';
		end
    else if Encoding = IG_PDF_ENCODING_ASCII_HEX then begin
			pdeFilterSpec := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_FILTERSPEC) as IIGPDEFilterSpec;
			pdeFilterSpec.name.String_ := 'ASCIIHexDecode';
		end
    else if Encoding = IG_PDF_ENCODING_NONE then begin
			// Do nothing
		end;

		Result := pdeFilterSpec;

	except
		GetIGManager.checkErrors();
	end;
end;

function CreateCompression(curPDFDoc: IGPdfDoc; Page: IGPage; Compression: enumIGPDFCompressions): IGPDEFilterSpec;
var
	pdeFilterSpec: IGPDEFilterSpec;
	name, key: IGPDFAtom;
	dict: IGPDFBasDict;
	clrComps: Longint;
begin
	try

		pdeFilterSpec := nil;

		// Set image compression
		key := GetIGManager.IGPdfCtrl.CreateObject(IG_PDF_ATOM) as IIGPDFAtom;

		if Compression=IG_PDF_COMPRESSION_CCITT_G4 then begin

			pdeFilterSpec := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_FILTERSPEC) as IIGPDEFilterSpec;
			pdeFilterSpec.name.String_ := 'CCITTFaxDecode';
			dict := GetIGManager.IGPdfCtrl.CreateBasDict(curPDFDoc, false, 2) as IIGPDFBasDict;
			key.String_ := 'K';
			dict.PutInt(key, false, -1);
			key.String_ := 'Columns';
			dict.PutInt(key, false, Page.ImageWidth);
			pdeFilterSpec.DecodeParams := dict;
			pdeFilterSpec.EncodeParams := dict;

		end
		else if Compression=IG_PDF_COMPRESSION_CCITT_G32D then begin
			pdeFilterSpec := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_FILTERSPEC) as IIGPDEFilterSpec;
			pdeFilterSpec.name.String_ := 'CCITTFaxDecode';
			dict := GetIGManager.IGPdfCtrl.CreateBasDict(curPDFDoc, false, 2) as IIGPDFBasDict;
			key.String_ := 'K';
			dict.PutInt(key, false, 4);
			key.String_ := 'Columns';
			dict.PutInt(key, false, Page.ImageWidth);
			pdeFilterSpec.DecodeParams := dict;
			pdeFilterSpec.EncodeParams := dict;

		end
		else if Compression=IG_PDF_COMPRESSION_CCITT_G3 then begin
			pdeFilterSpec := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_FILTERSPEC) as IIGPDEFilterSpec;
			pdeFilterSpec.name.String_ := 'CCITTFaxDecode';
			dict := GetIGManager.IGPdfCtrl.CreateBasDict(curPDFDoc, false, 2) as IIGPDFBasDict;
			key.String_ := 'K';
			dict.PutInt(key, false, 0);
			key.String_ := 'Columns';
			dict.PutInt(key, false, Page.ImageWidth);
			pdeFilterSpec.DecodeParams := dict;
			pdeFilterSpec.EncodeParams := dict;

		end
		else if Compression=IG_PDF_COMPRESSION_JPEG then begin
			pdeFilterSpec := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_FILTERSPEC) as IIGPDEFilterSpec;
			pdeFilterSpec.name.String_ := 'DCTDecode';
			dict := GetIGManager.IGPdfCtrl.CreateBasDict(curPDFDoc, false, 3) as IIGPDFBasDict;
			key.String_ := 'Columns';
			dict.PutInt(key, false, Page.ImageWidth);
			key.String_ := 'Rows';
			dict.PutInt(key, false, Page.ImageHeight);
			if Page.BitDepth<=8 then begin
				clrComps := 1;
			end else begin
				clrComps := Floor(Page.BitDepth) div  8;
			end;
			key.String_ := 'Colors';
			dict.PutInt(key, false, clrComps);
			pdeFilterSpec.DecodeParams := dict;
			pdeFilterSpec.EncodeParams := dict;

		end
		else if Compression=IG_PDF_COMPRESSION_LZW then begin
			pdeFilterSpec := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_FILTERSPEC) as IIGPDEFilterSpec;
			pdeFilterSpec.name.String_ := 'LZWDecode';
		end
		else if Compression=IG_PDF_COMPRESSION_RLE then begin
			pdeFilterSpec := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_FILTERSPEC) as IIGPDEFilterSpec;
			pdeFilterSpec.name.String_ := 'RunLengthDecode';
		end
		else if Compression=IG_PDF_COMPRESSION_DEFLATE then begin
			pdeFilterSpec := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_FILTERSPEC) as IIGPDEFilterSpec;
			pdeFilterSpec.name.String_ := 'FlateDecode';
		end;

		Result := pdeFilterSpec;
	except
		GetIGManager.checkErrors();
	end;
end;

function CreateImageAttrs(Page: IGPage): IGPDEImageAttrs;
var
	pdeImageAttrs: IGPDEImageAttrs;
	VBtoVar: Variant;
begin
	try

		pdeImageAttrs := nil;

		pdeImageAttrs := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_IMAGEATTRS) as IIGPDEImageAttrs;
		pdeImageAttrs.Flags := IG_PDE_IMAGE_EXTERNAL; // image is an XObject
		if Page.BitDepth<=8 then begin
			if Page.GetPaletteSize>0 then begin
				if  not IsPaletteGray(Page.BitDepth, Page.GetPaletteCopy) then begin
					pdeImageAttrs.Flags := pdeImageAttrs.Flags+IG_PDE_IMAGE_INDEXED; // image uses an indexed color space
				end;
			end;
		end;
		pdeImageAttrs.Width := Page.ImageWidth;
		pdeImageAttrs.Height := Page.ImageHeight;
		VBtoVar := Page.BitDepth;
		if (VBtoVar>=1) and (VBtoVar<=7) then begin

			pdeImageAttrs.BitsPerComponent := Page.BitDepth;
		end
		else if VBtoVar=16 then begin
			pdeImageAttrs.BitsPerComponent := 16;
		end
		else if (VBtoVar=8) or (VBtoVar=24) or (VBtoVar=32) then begin
			pdeImageAttrs.BitsPerComponent := 8;
		end;

		Result := pdeImageAttrs;

	except
		GetIGManager.checkErrors();
	end;
end;

function IsPaletteGray(BitDepth: Longint; palette: IGPalette): Boolean;
var
	i: Smallint;
begin
	try

		Result := false;

		if (BitDepth=8) and (palette=nil) then begin
			Result := true;
			Exit;
		end;

		if (palette.Size=0) then begin
			Result := true;
			Exit;
		end;

		if (BitDepth>8) or (palette=nil) or (palette.Size=0) then begin
			Exit;
		end;

		for i:=0 to palette.Size-1 do begin
			if (palette.Red[i] <> palette.Green[i]) or (palette.Green[i] <> palette.Red[i]) or (palette.Blue[i] <> palette.Green[i]) then begin
				Exit;
			end;
		end; // i

		for i:=1 to palette.Size-1 do begin
			if ((palette.Red[i] <= palette.Red[i-1]) or (palette.Green[i] <> palette.Green[i-1]) or (palette.Blue[i] <> palette.Blue[i-1])) then begin
				Exit;
			end;
		end; // i

		Result := true;

	except
		GetIGManager.checkErrors();
	end;
end;

// VBto upgrade warning: pixels As IGIntegerArray	OnWrite(IGIntegerArray, Longint)
function GetPixels(Page: IGPage; bIsRGBA: Boolean; var pixels: IGIntegerArray; pixelsSM: IGIntegerArray): OleVariant;
var
	nResBitDepth, yPos: Smallint;
	bytesRasterSize, nDibSize: Longint;
	raster: IGPixelArray;
begin
	try

		pixels := nil;
		pixels := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_INTEGERARRAY) as IIGIntegerArray;
		if (bIsRGBA) then begin
			pixelsSM := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_INTEGERARRAY) as IIGIntegerArray;
		end;

		if (bIsRGBA) then begin
			nResBitDepth := 24;
		end else begin
			nResBitDepth := Page.BitDepth;
		end;

		bytesRasterSize := (Page.ImageWidth*nResBitDepth+7) div 8;
		nDibSize := bytesRasterSize*Page.ImageHeight;
		pixels.Resize(nDibSize, 1);
		if (bIsRGBA) then begin
			pixelsSM.Resize((Page.ImageWidth*Page.ImageHeight), 1);
		end;

		for yPos:=0 to Page.ImageHeight-1 do begin
			if nResBitDepth=1 then begin

				raster := Page.GetPixRasterCopy(yPos, IG_PIX_ACC_PACKED);
				raster.CopyTo(pixels, yPos*bytesRasterSize, bytesRasterSize);
			end
			else if nResBitDepth=4 then begin
				raster := Page.GetPixRasterCopy(yPos, IG_PIX_ACC_UNPACKED);
				Pack4bitRaster(raster, pixels, yPos*bytesRasterSize, bytesRasterSize);
			end
			else if (nResBitDepth>=8) and (nResBitDepth<=32) then begin
				raster := Page.GetPixRasterCopy(yPos, IG_PIX_ACC_UNPACKED);
				if (bIsRGBA) then begin
					ProcessRGBARaster(raster, pixels, pixelsSM, yPos*Page.ImageWidth, Page.ImageWidth);
				end else begin
					raster.CopyTo(pixels, yPos*bytesRasterSize, bytesRasterSize);
				end;
			end;
		end; // yPos

	except
		GetIGManager.checkErrors();
	end;
end;

function CreateImagePage(Width: Longint; Height: Longint; ChannelCount: Longint; ChannelDepth: Longint; pixels: IGIntegerArray; palette: IGIntegerArray): IGPage;
var
	vOnErrorGoToLabel: Integer;
	i: Smallint;
	BitDepth, RasterSize, yPos: Longint;
	Page: IGPage;
	allocateParms: IGImageAllocationParams;
	igPal: IGPalette;
	pixel: IGPixel;
	raster: IGIntegerArray;
	DataFormat: enumIGPixelAccessType;
begin
	vOnErrorGoToLabel := 0;
	try

		// Public Function CreateImagePage(Width As Long, Height As Long, Bit_
		// BitDepth As Long, pixels As IGIntegerArray, palette As IGIntegerArray)
		// s IGPage

		Page := nil;
		Page := GetIGManager.IGCoreCtrl.CreatePage;

		BitDepth := ChannelDepth*ChannelCount;

		// set the IGImageAllocationParams
		allocateParms := GetIGManager.IGCoreCtrl.CreateObject(IG_OBJ_IMAGE_ALLOC_PARAMS) as IIGImageAllocationParams;
		allocateParms.BitDepth := BitDepth;
		allocateParms.Compression := IG_BI_RGB;
		allocateParms.ImageWidth := Width;
		allocateParms.ImageHeight := Height;

		// allocate the paramaters to page
		Page.AllocateImage(allocateParms);

		// Set image palette
		igPal := nil;
		 {? On Error Resume Next  }
		igPal := Page.GetPaletteCopy;

		if  igPal <> nil then begin
			for i:=0 to igPal.Size-1 do begin
				if  palette <> nil then begin
					igPal.Red[i] := palette.Item[i*3];
					igPal.Green[i] := palette.Item[i*3+1];
					igPal.Blue[i] := palette.Item[i*3+2];
				end else begin
					if BitDepth=1 then begin
						igPal.Red[i] := i*255;
						igPal.Green[i] := i*255;
						igPal.Blue[i] := i*255;
					end else begin
						igPal.Red[i] := i;
						igPal.Green[i] := i;
						igPal.Blue[i] := i;
					end;
				end;
			end; // i
			Page.UpdatePaletteFrom(igPal);
		end;

		// Set image pixels
		RasterSize := (Page.ImageWidth*Page.BitDepth+7) div 8;
		if Page.BitDepth=1 then begin
			DataFormat := IG_PIX_ACC_PACKED;
		end else begin
			DataFormat := IG_PIX_ACC_UNPACKED;
		end;

		for yPos:=0 to Page.ImageHeight-1 do begin
			raster := Page.GetRasterCopy(yPos, DataFormat);

			UnpackRaster(ChannelCount, ChannelDepth, Page.ImageWidth, pixels, raster, yPos, RasterSize);

			Page.UpdateRasterFrom(yPos, DataFormat, raster);
			raster := nil;
		end; // yPos

		Result := Page;

		GetIGManager.checkErrors();

	except
		 GetIGManager.checkErrors();
	end;
end;

function Unpack1bitPixel(pixels: IGIntegerArray; RasterSize: Longint; X: Smallint; Y: Smallint): Longint;
var
	offset, mask: Longint;
begin
	try

		offset := X div  8;

		mask := Round(Power(2, (7-(X mod  8))));

    if pixels.Item[RasterSize*Y+offset] = mask then begin
			Result := 1;
		end else begin
			Result := 0;
		end;

	except
		GetIGManager.checkErrors();
	end;
end;

function Unpack4bitPixel(pixels: IGIntegerArray; RasterSize: Longint; X: Smallint; Y: Smallint): Longint;
var
	offset, mask: Longint;
begin
	try

		offset := X div  2;

		if (X mod  2)=0 then begin
			Result := pixels.Item[RasterSize*Y+offset];
		end else begin
			Result := pixels.Item[RasterSize*Y+offset];
		end;

	except
		GetIGManager.checkErrors();
	end;
end;

procedure ProcessRGBARaster(Src: IGPixelArray; Dst: IGIntegerArray; DstSM: IGIntegerArray; Index: Longint; Count: Longint);
var
	i, k1, k2: Longint;
begin
	try

		k1 := Index*3;
		k2 := Index;

		for i:=0 to Count-1 do begin
			Dst.Item[k1+0] := Src.CMYK_C[i];
			Dst.Item[k1+1] := Src.CMYK_M[i];
			Dst.Item[k1+2] := Src.CMYK_Y[i];
			k1 := k1+3;

			DstSM.Item[k2] := Src.CMYK_K[i];
			k2 := k2+1;
		end; // i

	except
		GetIGManager.checkErrors();
	end;
end;


procedure Pack4bitRaster(Src: IGPixelArray; Dst: IGIntegerArray; Index: Longint; Count: Longint);
var
	i: Smallint;
begin
	try

		for i:=0 to Count-1 do begin
			Dst.Item[Index+i] := Src.Index[i*2]*16+Src.Index[i*2+1];
		end; // i

	except
		GetIGManager.checkErrors();
	end;
end;

procedure UnpackRaster(ChannelCount: Longint; ChannelDepth: Longint; PixelCount: Longint; Source: IGIntegerArray; dest: IGIntegerArray; Line: Longint; DestBytes: Longint);
var
	Cnt, Pix, BitCnt: Smallint;
begin
	try
		case ChannelCount of
			1: begin

				case ChannelDepth of
					1,
					8,
					16: begin

						Source.CopyTo(dest, Line*DestBytes, DestBytes);
					end;
					4: begin
						for  Cnt:=0 to PixelCount-1 do begin
							if Cnt mod  2=0 then begin
								dest.Item[Cnt] := Floor(Source.Item[(Line*DestBytes)+(Cnt div  2)]) div 16;
							end else begin
								dest.Item[Cnt] := Floor(Source.Item[(Line*DestBytes)+(Cnt div  2)]) mod 16;
							end;
						end; // Cnt
					end;
					else begin
						Source.CopyTo(dest, Line*DestBytes, DestBytes);
					end;
				end;
			end;
			3: begin
				case ChannelDepth of
					8,
					16: begin

						Source.CopyTo(dest, Line*DestBytes, DestBytes);
					end;
					else begin
						Source.CopyTo(dest, Line*DestBytes, DestBytes);
					end;
				end;
			end;
			4: begin
				case ChannelDepth of
					1: begin

						for Cnt:=0 to PixelCount-1 do begin
							if Cnt mod  2=0 then begin
								Pix := Floor(Source.Item[(Line*DestBytes)+(Cnt div  2)]) div 16;
							end else begin
								Pix := Floor(Source.Item[(Line*DestBytes)+(Cnt div  2)]) mod 16;
							end;
							for BitCnt:=0 to 3 do begin
								if (Pix = (Power(2,  BitCnt)))= False then begin
									Source.Item[Cnt*4+BitCnt] := 0;
								end else begin
									Source.Item[Cnt*4+BitCnt] := 1;
								end;
							end; // BitCnt
						end; // Cnt


					end;
					8,
					16: begin
						Source.CopyTo(dest, Line*DestBytes, DestBytes);
					end;
					else begin
						Source.CopyTo(dest, Line*DestBytes, DestBytes);
					end;
				end;

			end;
		end;

	except
		GetIGManager.checkErrors();
	end;
end;

end.
