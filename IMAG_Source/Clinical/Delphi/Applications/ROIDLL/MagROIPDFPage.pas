unit MagROIPDFPage;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   March, 2012
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==   unit MagROIPDFPage.pas
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
  ActiveX, Buttons, GearPDFLib_TLB, GearCoreLib_TLB, GearDialogsLib_TLB, GearFormatsLib_TLB;

	function CreateImage(xy: IGPDFFixedPoint; FitToPage: Boolean; rasterPage: IGPage): IGPDEImage;

implementation

uses
  MagROIGlobals,
  cMag_ROI_IGManager,
  MagROIpdfImage;

function CreateImage(xy: IGPDFFixedPoint; FitToPage: Boolean; rasterPage: IGPage): IGPDEImage;
var
	dialogLoadOptions: IGFileDlgDocumentLoadOptions;
	bIsRGBA: Boolean;
	pixels, pixelsSM: IGIntegerArray;
	dScaleX, dScaleY, dRectW, dRectH: Double;
	pdeColorSpace, pdeColorSpaceSM: IGPDEColorSpace;
	pdeFilterArray: IGPDEFilterArray;
	pdeEncoding, pdeCompression: IGPDEFilterSpec;
	pdeImageAttrs: IGPDEImageAttrs;
	transMatrix: IGPDFFixedMatrix;
	pdeImage, pdeImageSM: IGPDEImage;
	csAtom: IGPDFAtom;

  IoLocation: IIGIOLocation;
  LoadOptions: IGLoadOptions;

begin
	try
			// Is it an RGBA image? If so, we should create a SoftMask for it
			bIsRGBA := (IG_COLOR_SPACE_RGBA=rasterPage.ColorSpace) and (32=rasterPage.BitDepth);

			// Get raster pixels
			GetPixels(rasterPage, bIsRGBA, pixels, pixelsSM);

			// Image scale factor
			dScaleX := 1.0;
			dScaleY := 1.0;

			// Create color space
			pdeColorSpace := CreateColorSpace(rasterPage);

			// Set filters
			pdeFilterArray := GetIGManager.IGPdfCtrl.CreateObject(IG_PDE_FILTERARRAY) as IIGPDEFilterArray;

			// Set text encoding
			pdeEncoding := CreateEncoding(IG_PDF_ENCODING_ASCII_HEX);
			if  pdeEncoding <> nil then begin
				pdeFilterArray.AddSpec(pdeEncoding);
			end;

			// Set compression
			pdeCompression := CreateCompression(curPDFDoc, rasterPage, IG_PDF_COMPRESSION_DEFLATE);
			if  pdeCompression <> nil then begin
				pdeFilterArray.AddSpec(pdeCompression);
			end;

			// Initialize image attributes
			pdeImageAttrs := CreateImageAttrs(rasterPage);

			// Initialize transformation matrix
			transMatrix := GetIGManager.IGPdfCtrl.CreateObject(IG_PDF_FIXEDMATRIX) as IIGPDFFixedMatrix;

			if not FitToPage then
      begin
				dRectW := 100;
				dRectH := rasterPage.ImageHeight * 100 / rasterPage.ImageWidth;
				dScaleX := dRectW/rasterPage.ImageWidth;
				dScaleY := dRectH/rasterPage.ImageHeight;
				xy.V := xy.V - GetIGManager.IGPdfCtrl.LongToFixed(Round(rasterPage.ImageHeight * dScaleY));
			end;

			transMatrix.A := GetIGManager.IGPdfCtrl.LongToFixed(Round(rasterPage.ImageWidth * dScaleX)); // x-scaling factor
			transMatrix.D := GetIGManager.IGPdfCtrl.LongToFixed(Round(rasterPage.ImageHeight * dScaleY)); // y-scaling factor
			transMatrix.B := IG_PDF_FIXED_ZERO;
			transMatrix.C := IG_PDF_FIXED_ZERO;
			transMatrix.H := xy.H; // x-coord to place image
			transMatrix.V := xy.V; // y-coord to place image

			// Create PDEImage
			pdeImage := GetIGManager.IGPdfCtrl.CreatePDEImage(pdeImageAttrs,
                                                        transMatrix,
                                                        AT_PDE_IMAGE_DATA_NOT_ENCODED,
                                                        pdeColorSpace,
                                                        nil,
                                                        pdeFilterArray,
                                                        nil,
                                                        pixels);


			// Create SoftMask, if needed
			if (bIsRGBA) then begin
				csAtom.String_ := 'DeviceGray';

				pdeColorSpaceSM := GetIGManager.IGPdfCtrl.CreatePDEColorSpace(csAtom, nil);

				pdeImageSM := GetIGManager.IGPdfCtrl.CreatePDEImage(pdeImageAttrs, transMatrix, AT_PDE_IMAGE_DATA_NOT_ENCODED, pdeColorSpaceSM, nil, pdeFilterArray, nil, pixelsSM);

				pdeImage.SetSoftMask(pdeImageSM);
			end;

		Result := pdeImage;

	except
		GetIGManager.checkErrors();
	end;
end;

end.
