Unit UMagGearUtils;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
   Description: Imaging ImageGear utilities.
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
cMag4VGear,
 GearFORMATSlib_TLB,
 GearCORElib_TLB,
//p129  GEARLib_TLB,
//p129  Geardef,
//p129  GEAR,

  SysUtils;

//p129 Function GetLoadedFormat(Gearx: TGear): String;
//p129 Function GetSaveFormat(Gearx: TGear): String;
Function GetReadableLoadFormat(Filetype: Longint): String;
Function GetReadableSaveFormat(Saveformat: Longint): String;
//p129 Procedure SetAutoDetects(Gearx: TGear);
Implementation


//p129
{ TODO -o129  Do these functions need modified for 129 ? }
(*
Procedure SetAutoDetects(vmg1 : TMag4VGear) ; //(Gearx: TGear);
Begin

  Gearx.AutoDetectOn := IG_FORMAT_UNKNOWN; //result := 'Unknown' ;
  Gearx.AutoDetectOn := IG_FORMAT_BMP; //result := 'BMP';
  Gearx.AutoDetectOn := IG_FORMAT_DIB; //result := 'DIB';
  Gearx.AutoDetectOn := IG_FORMAT_G3; //result := 'G3';
  Gearx.AutoDetectOn := IG_FORMAT_G4; //result := 'G4';
  Gearx.AutoDetectOn := IG_FORMAT_GIF; //result := 'GIF';
  Gearx.AutoDetectOn := IG_FORMAT_JPG; //result := 'JPG';
  Gearx.AutoDetectOn := IG_FORMAT_KFX; //result := 'KFX';
  Gearx.AutoDetectOn := IG_FORMAT_TGA; //result := 'TGA';
  Gearx.AutoDetectOn := IG_FORMAT_TIF; //result := 'TIF';
  Gearx.AutoDetectOn := IG_FORMAT_TXT; //result := 'TXT';
  Gearx.AutoDetectOn := IG_FORMAT_DCM; //result := 'DCM';
  Gearx.AutoDetectOn := IG_FORMAT_PJPEG; //result := 'PJPEG';
  Gearx.AutoDetectOn := IG_FORMAT_AVI; //result := 'AVI';
  Gearx.AutoDetectOn := IG_FORMAT_PDF; //result := 'PDF';
  Gearx.AutoDetectOn := IG_FORMAT_JBIG; //result := 'JBIG';
  Gearx.AutoDetectOn := IG_FORMAT_RAW; //result := 'RAW';

End;
*)

//p129
(*Function GetLoadedFormat(Gearx: TGear): String;
Begin
  Result := GetReadableLoadFormat(Gearx.Filetype);
End;
*)

//p129
(*
Function GetSaveFormat(Gearx: TGear): String;
Begin
  Result := GetReadableSaveFormat(Gearx.Saveformat)
End;
*)
Function GetReadableLoadFormat(Filetype: Longint): String;
Begin
  Case Filetype Of
    IG_FORMAT_UNKNOWN: Result := 'Unknown';
    IG_FORMAT_ATT: Result := 'ATT';
    IG_FORMAT_BMP: Result := 'BMP';
    IG_FORMAT_BRK: Result := 'BRK';
    IG_FORMAT_CAL: Result := 'CAL';
    IG_FORMAT_CLP: Result := 'CLP';
//p129     IG_FORMAT_CIF: Result := 'CIF';
    IG_FORMAT_CUT: Result := 'CUT';
    IG_FORMAT_DCX: Result := 'DCX';
    IG_FORMAT_DIB: Result := 'DIB';
    IG_FORMAT_EPS: Result := 'DPS';
    IG_FORMAT_G3: Result := 'G3';
    IG_FORMAT_G4: Result := 'G4';
    IG_FORMAT_GEM: Result := 'GEM';
    IG_FORMAT_GIF: Result := 'GIF';
//p129     IG_FORMAT_GX2: Result := 'GX2';
    IG_FORMAT_ICA: Result := 'ICA';
    IG_FORMAT_ICO: Result := 'ICO';
    IG_FORMAT_IFF: Result := 'IFF';
//p129     IG_FORMAT_IGF: Result := 'IGF';
    IG_FORMAT_IMT: Result := 'IMT';
    IG_FORMAT_JPG: Result := 'JPG';
    IG_FORMAT_KFX: Result := 'KFX';
    IG_FORMAT_LV: Result := 'LV';
    IG_FORMAT_MAC: Result := 'MAC';
    IG_FORMAT_MSP: Result := 'MSP';
    IG_FORMAT_MOD: Result := 'MOD';
    IG_FORMAT_NCR: Result := 'NCR';
    IG_FORMAT_PBM: Result := 'PBM';
    IG_FORMAT_PCD: Result := 'PCD';
    IG_FORMAT_PCT: Result := 'PCT';
    IG_FORMAT_PCX: Result := 'PCX';
    IG_FORMAT_PGM: Result := 'PGM';
    IG_FORMAT_PNG: Result := 'PNG';
    IG_FORMAT_PNM: Result := 'PNM';
    IG_FORMAT_PPM: Result := 'PPM';
    IG_FORMAT_PSD: Result := 'PSD';
    IG_FORMAT_RAS: Result := 'RAS';
    IG_FORMAT_SGI: Result := 'SGI';
    IG_FORMAT_TGA: Result := 'TGA';
    IG_FORMAT_TIF: Result := 'TIF';
    IG_FORMAT_TXT: Result := 'TXT';
    IG_FORMAT_WPG: Result := 'WPG';
    IG_FORMAT_XBM: Result := 'XBM';
    IG_FORMAT_WMF: Result := 'WMF';
    IG_FORMAT_XPM: Result := 'XPM';
    IG_FORMAT_XRX: Result := 'XRX';
    IG_FORMAT_XWD: Result := 'XWD';
    IG_FORMAT_DCM: Result := 'DCM';
    IG_FORMAT_AFX: Result := 'AFX';
    IG_FORMAT_FPX: Result := 'FPX';
//p129 duplicate    IG_FORMAT_PJPEG: Result := 'PJPEG';
    IG_FORMAT_AVI: Result := 'AVI';
    IG_FORMAT_G32D: Result := 'G32D';
    IG_FORMAT_ABIC_BILEVEL: Result := 'ABIC BILEVEL';
    IG_FORMAT_ABIC_CONCAT: Result := 'ABIC CONCAT';
    IG_FORMAT_PDF: Result := 'PDF';
    IG_FORMAT_JBIG: Result := 'JBIG';
    IG_FORMAT_RAW: Result := 'RAW';
    IG_FORMAT_IMR: Result := 'IMR';
//p129     IG_FORMAT_STX: Result := 'STX';
  Else
    Result := Inttostr(Filetype);

  End;
End;

Function GetReadableSaveFormat(Saveformat: Longint): String;
Begin
 //case saveformat of
  If Saveformat = IG_SAVE_TIF_G4 Then
  Begin
    Result := 'TIF_G4';
    Exit;
  End; //  (IG_FORMAT_TIF+(IG_COMPRESSION_CCITT_G4 * $10000));
  If Saveformat = IG_SAVE_JPG Then
  Begin
    Result := 'JPG';
    Exit;
  End; //  (IG_FORMAT_JPG);
  If Saveformat = IG_SAVE_TGA Then
  Begin
    Result := 'TGA';
    Exit;
  End; //  (IG_FORMAT_TGA);
  If Saveformat = IG_SAVE_DCM Then
  Begin
    Result := 'DCM';
    Exit;
  End; //(IG_FORMAT_DCM);
  If Saveformat = IG_SAVE_JBIG Then
  Begin
    Result := 'JBIG';
    Exit;
  End; //(IG_FORMAT_JBIG);
  If Saveformat = IG_SAVE_PJPEG Then
  Begin
    Result := 'PJPEG';
    Exit;
  End; //(IG_FORMAT_PJPEG+(IG_COMPRESSION_PROGRESSIVE * $10000))

  If Saveformat = IG_SAVE_UNKNOWN Then
  Begin
    Result := 'UNKNOWN';
    Exit;
  End; // (IG_FORMAT_UNKNOWN) { Uses extension on the file name string to determine which format};

  If Saveformat = IG_SAVE_TIF_UNCOMP Then
  Begin
    Result := 'TIF_UNCOMP';
    Exit;
  End; // (IG_FORMAT_TIF+(IG_COMPRESSION_NONE * $10000));
  If Saveformat = IG_SAVE_TIF_G3 Then
  Begin
    Result := 'TIF_G3';
    Exit;
  End; //  (IG_FORMAT_TIF+(IG_COMPRESSION_CCITT_G3 * $10000));
  If Saveformat = IG_SAVE_TIF_G3_2D Then
  Begin
    Result := 'TIF_G3_2D';
    Exit;
  End; //  (IG_FORMAT_TIF+(IG_COMPRESSION_CCITT_G32D * $10000));
  ;
  If Saveformat = IG_SAVE_TIF_HUFFMAN Then
  Begin
    Result := 'TIF_HUFFMAN';
    Exit;
  End; //(IG_FORMAT_TIF+(IG_COMPRESSION_HUFFMAN * $10000));
  If Saveformat = IG_SAVE_TIF_JPG Then
  Begin
    Result := 'TIF_JPG';
    Exit;
  End; // (IG_FORMAT_TIF+(IG_COMPRESSION_JPEG * $10000));
  If Saveformat = IG_SAVE_TIF_LZW Then
  Begin
    Result := 'TIF_LZW';
    Exit;
  End; // (IG_FORMAT_TIF+(IG_COMPRESSION_LZW * $10000));
  If Saveformat = IG_SAVE_TIF_PACKED Then
  Begin
    Result := 'TIF_PACKED';
    Exit;
  End; // (IG_FORMAT_TIF+(IG_COMPRESSION_PACKED_BITS * $10000));

  If Saveformat = IG_SAVE_BRK_G3 Then
  Begin
    Result := 'BRK G3';
    Exit;
  End; //  (IG_FORMAT_BRK+(IG_COMPRESSION_CCITT_G3 * $10000));
  If Saveformat = IG_SAVE_BRK_G3_2D Then
  Begin
    Result := 'BRK G3 2D';
    Exit;
  End; //  (IG_FORMAT_BRK+(IG_COMPRESSION_CCITT_G32D * $10000));
  If Saveformat = IG_SAVE_BMP_RLE Then
  Begin
    Result := 'BMP RLE';
    Exit;
  End; // (IG_FORMAT_BMP+(IG_COMPRESSION_RLE * $10000));
  If Saveformat = IG_SAVE_BMP_UNCOMP Then
  Begin
    Result := 'BMP UNCOMP';
    Exit;
  End; // (IG_FORMAT_BMP+(IG_COMPRESSION_NONE * $10000));
  If Saveformat = IG_SAVE_CAL Then
  Begin
    Result := 'CAL';
    Exit;
  End; //  (IG_FORMAT_CAL);
  If Saveformat = IG_SAVE_CLP Then
  Begin
    Result := 'CLP';
    Exit;
  End; //  (IG_FORMAT_CLP);
  If Saveformat = IG_SAVE_DCX Then
  Begin
    Result := 'DCX';
    Exit;
  End; //  (IG_FORMAT_DCX);
//p129
(*
  If Saveformat = IG_SAVE_EPS Then
  Begin
    Result := 'EPS';
    Exit;
  End; //  (IG_FORMAT_EPS);
*)
  If Saveformat = IG_SAVE_GIF Then
  Begin
    Result := 'GIF';
    Exit;
  End; //  (IG_FORMAT_GIF);
  If Saveformat = IG_SAVE_ICA_G3 Then
  Begin
    Result := 'ICA G3';
    Exit;
  End; //  (IG_FORMAT_ICA+(IG_COMPRESSION_CCITT_G3 * $10000));
  If Saveformat = IG_SAVE_ICA_G4 Then
  Begin
    Result := 'ICA G4';
    Exit;
  End; //  (IG_FORMAT_ICA+(IG_COMPRESSION_CCITT_G4 * $10000));
  If Saveformat = IG_SAVE_ICA_IBM_MMR Then
  Begin
    Result := 'ICA IBM MMR';
    Exit;
  End; //(IG_FORMAT_ICA+(IG_COMPRESSION_IBM_MMR * $10000));
  If Saveformat = IG_SAVE_ICO Then
  Begin
    Result := 'ICO';
    Exit;
  End; //  (IG_FORMAT_ICO);
  If Saveformat = IG_SAVE_IMT Then
  Begin
    Result := 'IMT';
    Exit;
  End; //  (IG_FORMAT_IMT);
  If Saveformat = IG_SAVE_IFF Then
  Begin
    Result := 'IFF';
    Exit;
  End; //  (IG_FORMAT_IFF);
  If Saveformat = IG_SAVE_MOD_G3 Then
  Begin
    Result := 'MOD G3';
    Exit;
  End; //  (IG_FORMAT_MOD+(IG_COMPRESSION_CCITT_G3 * $10000));
  If Saveformat = IG_SAVE_MOD_G4 Then
  Begin
    Result := 'MOD G4';
    Exit;
  End; //  (IG_FORMAT_MOD+(IG_COMPRESSION_CCITT_G4 * $10000));
  If Saveformat = IG_SAVE_MOD_IBM_MMR Then
  Begin
    Result := 'MOD IBM MMR';
    Exit;
  End; //(IG_FORMAT_MOD+(IG_COMPRESSION_IBM_MMR * $10000));
  If Saveformat = IG_SAVE_NCR Then
  Begin
    Result := 'NCR';
    Exit;
  End; //  (IG_FORMAT_NCR);
  If Saveformat = IG_SAVE_NCR_G4 Then
  Begin
    Result := 'NCR G4';
    Exit;
  End; //  (IG_FORMAT_NCR+(IG_COMPRESSION_CCITT_G4 * $10000));
  If Saveformat = IG_SAVE_PBM_ASCII Then
  Begin
    Result := 'PBM ASCII';
    Exit;
  End; // (IG_FORMAT_PBM);
  If Saveformat = IG_SAVE_PBM_RAW Then
  Begin
    Result := 'PBM RAW';
    Exit;
  End; //(IG_FORMAT_PBM+(IG_COMPRESSION_PACKED_BITS * $10000));
  If Saveformat = IG_SAVE_PCT Then
  Begin
    Result := 'PCT';
    Exit;
  End; //  (IG_FORMAT_PCT);
  If Saveformat = IG_SAVE_PCX Then
  Begin
    Result := 'PCX';
    Exit;
  End; //  (IG_FORMAT_PCX);
  If Saveformat = IG_SAVE_PNG Then
  Begin
    Result := 'PNG';
    Exit;
  End; //  (IG_FORMAT_PNG);
  If Saveformat = IG_SAVE_PSD Then
  Begin
    Result := 'PSD';
    Exit;
  End; //  (IG_FORMAT_PSD);
  If Saveformat = IG_SAVE_RAS Then
  Begin
    Result := 'RAS';
    Exit;
  End; //  (IG_FORMAT_RAS);
  If Saveformat = IG_SAVE_RAW_G3 Then
  Begin
    Result := 'RAW G3';
    Exit;
  End; //  (IG_FORMAT_G3+(IG_COMPRESSION_CCITT_G3 * $10000));
  If Saveformat = IG_SAVE_RAW_G4 Then
  Begin
    Result := 'RAW G4';
    Exit;
  End; //  (IG_FORMAT_G4+(IG_COMPRESSION_CCITT_G4 * $10000));
  If Saveformat = IG_SAVE_RAW_G32D Then
  Begin
    Result := 'RAW_G32D';
    Exit;
  End; //(IG_FORMAT_G3+(IG_COMPRESSION_CCITT_G32D * $10000));
  If Saveformat = IG_SAVE_RAW_LZW Then
  Begin
    Result := 'RAW_LZW';
    Exit;
  End; // (IG_FORMAT_UNKNOWN+(IG_COMPRESSION_LZW * $10000));
  If Saveformat = IG_SAVE_RAW_RLE Then
  Begin
    Result := 'RAW_RLE';
    Exit;
  End; // (IG_FORMAT_UNKNOWN+(IG_COMPRESSION_RLE * $10000));
  If Saveformat = IG_SAVE_SGI Then
  Begin
    Result := 'SGI';
    Exit;
  End; //  (IG_FORMAT_SGI);
  If Saveformat = IG_SAVE_XBM Then
  Begin
    Result := 'XBM';
    Exit;
  End; //  (IG_FORMAT_XBM);
  If Saveformat = IG_SAVE_XPM Then
  Begin
    Result := 'XPM';
    Exit;
  End; //  (IG_FORMAT_XPM);
  If Saveformat = IG_SAVE_XWD Then
  Begin
    Result := 'XWD';
    Exit;
  End; //  (IG_FORMAT_XWD);
  If Saveformat = IG_SAVE_WMF Then
  Begin
    Result := 'WMF';
    Exit;
  End; //  (IG_FORMAT_WMF);

  If Saveformat = IG_SAVE_FPX_NOCHANGE Then
  Begin
    Result := 'FPX_NOCHANGE';
    Exit;
  End; //  (IG_FORMAT_FPX+(IG_COMPRESSION_FPX_NOCHANGE * $10000));
  If Saveformat = IG_SAVE_FPX_UNCOMP Then
  Begin
    Result := 'FPX_UNCOMP';
    Exit;
  End; // (IG_FORMAT_FPX+(IG_COMPRESSION_NONE * $10000));
  If Saveformat = IG_SAVE_FPX_JPG Then
  Begin
    Result := 'FPX_JPG';
    Exit;
  End; // (IG_FORMAT_FPX+(IG_COMPRESSION_JPEG * $10000));
  If Saveformat = IG_SAVE_FPX_SINCOLOR Then
  Begin
    Result := 'FPX_SINCOLOR';
    Exit;
  End; //  (IG_FORMAT_FPX+(IG_COMPRESSION_FPX_SINCOLOR * $10000));

End;

End.
