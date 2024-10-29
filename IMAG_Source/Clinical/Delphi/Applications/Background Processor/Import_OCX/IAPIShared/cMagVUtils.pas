Unit cMagVUtils;
   {
   Package: MAG - VistA Imaging
   WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
   Date Created:  Version 3.0.8
   Site Name: Silver Spring, OIFO
   Developers: Garrett Kirin
[==      unit cMagVUtils;
   Description:  Imaging Viewer utilities
    Some functions and methods are used by many Forms (windows) and components of
    the application.  Utility components are designed to be a repository of such
    utility functions used throughout the application.
    Other Compontents that need the methods contained in the utililty components
    can declare a property of that type and have the utility object set at design time.

Class : TMagVUtils
    This utility class has methods dealing with Image Information and properties.
    Mainly used by the Image Viewer (TMag4Viewer).
    Patch 59
    function TMagVUtils.ResolveAbstract
    Modifed to use dMagImageManager to get Cached Image, or Image.  Not to do it by itself.
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
  Classes,
  cMagUtils,
  UMagClasses
  ;

//Uses Vetted 20090929:fmxutils, Printers, Dialogs, Forms, Controls, Graphics, Messages, Windows, umagutils, uMagDefinitions, MagImageManager, SysUtils

Type
  TMagVUtils = Class(TComponent)
  Private
    Futl: TMagUtils;
  Protected
    { Protected declarations }
  Public
    Constructor Create(AOwner: TComponent); Override;
    Destructor Destroy; Override;

            {   string from Image List returned by RPC convert to TImageData Object.}
//93    function StringToIMageObj(str: string): TImageData;

            {   actual Abstract or Canned Bitmap }
 //59 msghint  //45  closesecurity.
    Function ResolveAbstract(ImgObj: TImageData; Var Msghint: String; ShowJB: Boolean = False; CloseSecurity: Boolean = True): String;

            {   Images from an OpenFile Dialog into List of TImageData objects.}
    Function DirImagesToObjList(t: TStrings): Tlist;

            {   gets the VistA Image field Object Type, from the file's Extension}
    Function ResolveTypeFromExt(Filename: String): Integer;

            {   Image used to Clear TGear component}
    Function BlankImage: String;

            {   full path where the application is running}
    Function GetAppPath: String;
  Published
    { Published declarations }
  End;

Procedure Register;

Implementation

Uses
  MagImageManager,
  SysUtils,
  UMagDefinitions,
  Umagutils8
  ;

//Uses Vetted 20090929:dmsingle, u magdisplaymgr, cMag4VGear, cMag4Viewer

Function TMagVUtils.GetAppPath: String;
Begin
  Result := Futl.GetAppPath;
End;

Function TMagVUtils.BlankImage: String;
Begin
  Result := Futl.BlankImage;
End;

Constructor TMagVUtils.Create(AOwner: TComponent);
Begin
  Inherited;
  Futl := TMagUtils.Create(Nil);
End;

Destructor TMagVUtils.Destroy;
Begin
  Futl.Free;
  Inherited;
End;

Function TMagVUtils.DirImagesToObjList(t: TStrings): Tlist;
Var
  i: Integer;
  IObj: TImageData;
Begin
  Result := Tlist.Create;
  Try
    For i := 0 To t.Count - 1 Do
    Begin
      { TODO : Create Abstracts, and Resolve Image Format for the images in the directory. }
      IObj := TImageData.Create;
      IObj.AFile := t[i];
      IObj.FFile := t[i];
      IObj.Proc := t[i];
      IObj.ImgDes := t[i];
      IObj.ImgType := ResolveTypeFromExt(IObj.FFile);
      IObj.Mag0 := Inttostr(i);
      Result.Add(IObj);
    End;
  Finally
    //
  End;
End;

Function TMagVUtils.ResolveAbstract(ImgObj: TImageData; Var Msghint: String; ShowJB: Boolean = False; CloseSecurity: Boolean = True): String;
Var
  Xmsg, VApppath: String;
  ImgResult: TMagImageTransferResult;
Begin
  Try
    ImgResult := Nil;
    Msghint := ''; //59
    VApppath := Futl.GetAppPath;

  { TODO :  need to change the 'O' and 'W' to enumerated type. maglocMag, maglocJB, }
    Result := MagImageManager1.GetCachedImage(ExtractFileName(ImgObj.AFile), ImgObj.PlaceCode);
    If Result <> '' Then Exit;

    If (Uppercase(ImgObj.AbsLocation) = 'O') Then
    Begin
      Result := VApppath + '\BMP\JBOFFLN.ABS';
      Msghint := 'Abstract is located on a JukeBox platter that is offline';
      Exit;
    End;
    If (Uppercase(ImgObj.AbsLocation) = 'W') Then
    Begin
     { Abstract is on JukeBox. 'W' means 'Worm Drive'}
      If (Not ShowJB)
        {if not viewing JukeBox Abstracts then Display the BMP}Then
      Begin
        Result := VApppath + '\BMP\ABSJBOX.BMP';
        Msghint := 'Abstract is located on a JukeBox.';
        Exit;
      End
        { we are viewing JB Abs, so Queue it also}
      Else //old   queabs.add(ptrMagRecord^.Mag0);
    End;
    If ImgObj.PlaceCode <> GSess.WrksPlaceCODE Then
    Begin
      If (Not Upref.AbsViewRemote) Then //IniViewRemoteAbs
      Begin
        Result := VApppath + '\BMP\ABSREMOTE.BMP';
        Msghint := 'Abstract is located on a Remote Image Server.';
        Exit;
      End
      Else {later maybe  queue to local sserver .  ?}
    End;
  { 12-PACS Group   10-PACS Resident    13-ECG     14-cine }
    Case ImgObj.ImgType Of
      12: Result := VApppath + '\BMP\ABSPACG.BMP';
      10: Result := VApppath + '\BMP\ABSPACI.BMP';
      13: Result := VApppath + '\bmp\absekg.bmp';
      14: Result := VApppath + '\bmp\abscine.bmp';
      21: Result := VApppath + '\bmp\magavi.bmp';
      101: Result := VApppath + '\bmp\maghtml.bmp';
      102: Result := VApppath + '\bmp\magdoc.bmp';
      103: Result := VApppath + '\bmp\magtext.bmp';
      104: Result := VApppath + '\bmp\magpdf.bmp';
      105: Result := VApppath + '\bmp\magrtf.bmp';
      106: Result := VApppath + '\bmp\magwav.bmp';
    End; {case}
    If (Pos('\bmp\', Result) > 0) Then Exit;
        {       Gets NetworkFile with option to Cache it.}
  // JMW 2/15/08 P72 - Need to use getFile because it handles images from the ViX
    ImgResult := MagImageManager1.GetFile(ImgObj.AFile, ImgObj.PlaceCode,
      ImgObj.ImgType, Not CloseSecurity);
    If (ImgResult.FTransferStatus <> IMAGE_COPIED) Then
    Begin
      Msghint := Xmsg;
      Result := VApppath + '\bmp\AbsError.bmp';
    End
    Else
    Begin
      Result := ImgResult.FDestinationFilename;
    End;
    If ImgResult <> Nil Then
      FreeAndNil(ImgResult);
  Except
    On e: Exception Do
    Begin
      Msghint := 'OS Message: ' + SysErrorMessage(Getlasterror);
      Result := VApppath + '\bmp\AbsError.bmp';
    End;
  End; {try except}
End;

Function TMagVUtils.ResolveTypeFromExt(Filename: String): Integer;
Var
  Ext, StrType: String;
  i: Integer;
Begin
  If FExtensionlist.Count > 0 Then
  Begin
    Result := 1;
    For i := 0 To FExtensionlist.Count - 1 Do
    Begin
      If Uppercase(MagPiece(FExtensionlist[i], '^', 1)) = Uppercase(Ext) Then
      Begin
        StrType := MagPiece(MagPiece(FExtensionlist[i], '|', 2), '^', 3);
        Result := MagStrToInt(StrType);
        If Result = 0 Then Result := 1;
        Break;
      End;
    End;
  End;

{TODO: need to make a DB Call for this, and should be moved to cMagUtilsDB.pas}
  Ext := Uppercase(Copy(ExtractFileExt(Filename), 2, 99));
  Result := 1;
  //case imgobj.ImgType of
  If Ext = 'AVI' Then
    Result := 21
  Else
    If Ext = 'MPG' Then
      Result := 21
    Else
      If Ext = 'MP3' Then
        Result := 21
      Else
        If Ext = 'MP4' Then
          Result := 21
        Else
          If Ext = 'MPEG' Then
            Result := 21
          Else
            If Ext = 'HTM' Then
              Result := 101
            Else
              If Ext = 'MHT' Then
                Result := 101
              Else
                If Ext = 'MHTML' Then
                  Result := 101
                Else
                  If Ext = 'HTML' Then
                    Result := 101
                  Else
                    If Ext = 'DOC' Then
                      Result := 102
                    Else
                      If Ext = 'TXT' Then
                        Result := 103
                      Else
                        If Ext = 'ASC' Then
                          Result := 103
                        Else
                          If Ext = 'PDF' Then
                            Result := 104
                          Else
                            If Ext = 'RTF' Then
                              Result := 105
                            Else
                              If Ext = 'WAV' Then Result := 106;

End;

(*93   function TMagVUtils.StringToIMageObj(str: string): TImageData;
var length: integer;
begin
  Result := TImageData.create;
//93 this is moved to TImageData.
*)

Procedure Register;
Begin
  RegisterComponents('Imaging', [TMagVUtils]);
End;

End.
