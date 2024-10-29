Unit MagImageManager;
(*
        ;; +---------------------------------------------------------------------------------------------------+
        ;;  MAG - IMAGING
        ;;  Property of the US Government.
        ;;  WARNING: Pe VHA Directive xxxxxx, this unit should not be modified.
        ;;  No permission to copy or redistribute this software is given.
        ;;  Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;;
        ;;  Date created: June 2005
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: This is an image manager to control the caching of all
        ;;  images in the Display client. This also uses the MagCacheManager for
        ;;  background caching.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Classes,
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
//RCA  Maggmsgu,
  imaginterfaces,
  cMagSecurity,
  cMagUtils,
  MagCacheManager,
  UMagClasses
  ;

//Uses Vetted 20090929:hash, cMagImageUtility, umagutils, uMagDefinitions, MagRemoteInterface, sysutils, fmxutils

Type
  TMagImageType = (MagImageTypeAbs, MagImageTypeFull, MagImageTypeBig, MagImageTypeTxt);
Type
  TMagCannedAbs = (MagAbsPacGroup, MagAbsPacImage, MagAbsEKG, MagAbsCine, MagAbsAVI,
                   MagAbsHTML, MagAbsDoc, MagAbsText, MagAbsPDF, MagAbsRTF, MagAbsWav,
                   MagAbsQA, MagAbsJB, MagAbsError, MagAbsDeletedImage, MagAbsDeletedGroup); {/ P117 - JK 8/31/2010 added MagAbsDeletedImage and MagAbsDeletedGroup /}

    {
        12: result := AppPath + '\BMP\ABSPACG.BMP';
        10: Result := AppPath + '\BMP\ABSPACI.BMP';
        13: Result := AppPath + '\bmp\absekg.bmp';
        14: Result := AppPath + '\bmp\abscine.bmp';
        //   21: Result := AppPath + '\bmp\MotionVideoAbs.bmp';
        21: Result := AppPath + '\bmp\magavi.bmp';
        101: Result := AppPath + '\bmp\maghtml.bmp';
        102: Result := AppPath + '\bmp\magdoc.bmp';
        103: Result := AppPath + '\bmp\magtext.bmp';
        104: Result := AppPath + '\bmp\magpdf.bmp';
        105: Result := AppPath + '\bmp\magrtf.bmp';
        106: Result := AppPath + '\bmp\magwav.bmp';
    }

Type
  TMagImageManager = Class

  Private
    FCacheDirectory: String;
    ImagesToCache: TStrings;
    CacheManager: TCacheManager;

    MagUtilities: TMagUtils;

    CachedImageList: Tlist;

        //FOnLogEvent: TMagLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}

    FMagSecurity: TMag4Security;
    FSecurityOn: Boolean;
        // if true, only cache images from HTTP locations (not local or UNC paths)
    FCacheOnlyHttpImages: Boolean;
    FStylesheetsDirectory : String;

//Was for RCA decouple magmsg, not now.        procedure MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);  //RCA

    Procedure SetCacheDirectory(Value: String);

    Function IsRadiology(ImageType: Integer): Boolean;
    Function ResolveCannedAbstract(ImgObj: TImageData; ShowJB: Boolean = False; CloseSecurity: Boolean = True): String;
    procedure CreateCacheDirectory(Directory : String);

        //procedure LogMsg(MsgType: string; Msg: string; Priority: TMagLogPriority = MagLogINFO); {JK 10/5/2009 - Maggmsgu refactoring - remove old method}

  Public
    Procedure GetImageTxtFileText(IObj: TImageData; Var t: TStrings; Xmsg: String); //p94 new function
    //Function IsLocalImage(IObj: TImageData): Boolean;
	Function IsThisImageLocaltoSite(IObj: TImageData): Boolean;
    Constructor Create();
    Destructor Destroy; Override;
    Procedure StartCache(Images: TStrings);
    Procedure StopCache();

    Function ExtractGroupImages(GroupNetworkFilename: String; GroupCount: Integer; InList: TStrings): TStrings;
    Function ExtractGroupImagesFromImageData(GroupNetworkFilename: String; GroupCount: Integer; InList: Tlist): TStrings;
    Function ExtractSingleImage(IObj: TImageData): TStrings;

    Property CacheDirectory: String Read FCacheDirectory Write SetCacheDirectory;

    Function IsFileCurrentlyCaching(Fname: String): Boolean;
    Procedure WaitForImageThread();
    Function IsImageCurrentlyCaching(): Boolean;

    Function GetFile(NetworkFilename: String; SiteAbbr: String;
      ImgFormatType: Integer; KeepConnectionActive: Boolean = False;
      IsTXTFile: Boolean = False): TMagImageTransferResult;
        {function getImageFile - Gets Image from Network or Cache, Caches it if needed}
    Function GetImageFile(NetworkFilename: String; SiteAbbr: String; Var Xmsg: String; CacheAlso: Boolean = True; KeepConnectionActive: Boolean = False):
      String;
    Function GetCachedImage(Filename: String; SiteAbbr: String): String;
    Procedure SafeCloseNetworkConnections();

    Function IsImageCached(NetworkFilename: String): Boolean;
    Function IsStudyCached(NetworkFilename: String; ImageCount: Integer): Boolean;
    Procedure AddCachedImage(NetworkFilename: String; ImageCount: Integer);

        {
        function isImageCached(ImageIEN, PlaceIEN : String) : boolean;
        function isStudyCached(ImageIEN, PlaceIEN : String; ImageCount : integer) : boolean;
        procedure AddCachedImage(ImageIEN, PlaceIEN : String; ImageCount : integer);
        }

        //procedure setImageCached(ImageIEN, PlaceIEN : String);
    Procedure SetImageCached(NetworkFilename: String);

        // this was out in 59, and getImageFile was in.
   //    function canGetFile(NetworkFilename, SiteAbbr : String) : boolean;
//    Function GetImageGuaranteed(IObj: TImageData; ImgType:
//      TMagImageType = MagImageTypeFull; KeepConnectionActive: Boolean = False): TMagImageTransferResult;

    Function GetImageGuaranteed(IObj: TImageData; ImgType:
                                 TMagImageType = MagImageTypeFull;
                                 KeepConnectionActive: boolean = false;
                                 ignBlock: boolean = false): TMagImageTransferResult;

    Function GetCannedBMP(AbsType: TMagCannedAbs): String;

        //property OnLogEvent: TMagLogEvent read FOnLogEvent write FOnLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
    Property SecurityOn: Boolean Read FSecurityOn Write FSecurityOn;
    Property MagSecurity: TMag4Security Write FMagSecurity;
    Property CacheOnlyHttpImages: Boolean Read FCacheOnlyHttpImages Write FCacheOnlyHttpImages;

    Function CreateRequestPathForImage(IObj: TImageData; ImageType: TMagImageType): String;
    function ResolveAbstract(ImageObj: TImageData; ShowJB: Boolean = False; CloseSecurity: Boolean = True): String;

    Property StylesheetsDirectory : String read FStylesheetsDirectory write FStylesheetsDirectory;
  Protected
  End;

  TCachedImageInformation = Class
  Public
    NetworkFilename: String;
    ImageCount: Integer;
    CacheComplete: Boolean;

  End;

Procedure Initialize();
Function CheckSiteAbbr(SiteAbbr: String): String;

Var
  MagImageManager1: TMagImageManager;

Implementation

Uses
  cMagImageUtility,
  ImagDMinterface, // DmSingle,
  Fmxutils,
  Magremoteinterface,
  SysUtils,
  UMagDefinitions,
  Umagutils8
  ;


//RCA 11/11/2011  gek  remove dependency on maggmsgu and VCLZip.  Use interface (if it is declared).
(* procedure TMagImageManager.MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);
begin
if ImsgObj <> nil then  ImsgObj.LogMsg(msgtype,msg,priority);
end;
*)

Procedure Initialize();
Begin
  If MagImageManager1 = Nil Then MagImageManager1 := TMagImageManager.Create();//RLM Fixing MemoryLeak 6/18/2010
  //MagImageManager1.CachedImageList := Tlist.Create();
  MagImageManager1.FSecurityOn := True;
  MagImageManager1.FCacheOnlyHttpImages := False;
End;

Constructor TMagImageManager.Create();
Begin
  CachedImageList := Tlist.Create();
  FSecurityOn := True;
  FCacheOnlyHttpImages := False;
  FStylesheetsDirectory := '';
End;

Destructor TMagImageManager.Destroy();
Begin
  If CachedImageList <> Nil Then
  Begin
    FreeAndNil(CachedImageList);
  End;
  If MagImageUtility <> Nil Then
    FreeAndNil(MagImageUtility);
  Inherited;
End;

{JK 10/6/2009 - Maggmsgu refactoring - remove old method}
//procedure TMagImageManager.LogMsg(MsgType: string; Msg: string; Priority: TMagLogPriority = MagLogINFO);
//begin
//    if assigned(OnLogEvent) then
//        OnLogEvent(self, MsgType, Msg, Priority);
//end;

Function TMagImageManager.IsImageCurrentlyCaching(): Boolean;
Begin
  If CacheManager = Nil Then
  Begin
    Result := False;
  End
  Else
  Begin
    Result := CacheManager.CurrentlyCachingImage();
  End;
End;

{
procedure TMagImageManager.setDestinationDirectory(Value : String);
begin
  FDestinationDirectory := Value;
end;
}

Procedure TMagImageManager.SetCacheDirectory(Value: String);
Begin
  FCacheDirectory := Value;
  GetImageUtility().SetImageCacheDirectory(FCacheDirectory);
End;

Procedure TMagImageManager.WaitForImageThread();
Var
  aThread: TThread;
Begin
  If CacheManager <> Nil Then
  Begin
    aThread := CacheManager.GetExecutingThread();
    If aThread <> Nil Then
    Begin
      aThread.WaitFor();
    End;
  End;
End;

Function TMagImageManager.IsFileCurrentlyCaching(Fname: String): Boolean;
Begin
  If CacheManager = Nil Then
  Begin
    Result := False;
  End
  Else
  Begin
    If CacheManager.CurrentCacheFile = Fname Then
    Begin
      Result := True;
    End
    Else
    Begin
      Result := False;
    End;
  End;
End;

Function TMagImageManager.ExtractSingleImage(IObj: TImageData): TStrings;
Var
  OldList: TStrings;
  NewList: TStrings;
  Part2: String;
  i: Integer;
  NetworkFilename, SiteAbbr, CacheInformation, TxtFilename, AbsFileName: String;
  ImageType: Integer;

Begin
  NewList := Tstringlist.Create();
  If IObj = Nil Then
  Begin
    Result := NewList;
    Exit;
  End;

    //if isImageCached(iobj.Mag0, iobj.PlaceIEN) then begin
  If IsImageCached(IObj.FFile) Then
  Begin
    Magremoteinterface.RIVNotifyAllListeners(Nil, MagCacheManager.IMAGE_COMPLETE, IObj.FFile);
        //maggmsgf.MagMsg('s', 'Image [' + Iobj.FFile + '] is already cached');
        //LogMsg('s', 'Image [' + Iobj.FFile + '] is already cached');
    magAppMsg('s', 'Image [' + IObj.FFile + '] is already cached'); {JK 10/6/2009 - Maggmsgu refactoring}
    Result := NewList;
    Exit;
  End;

  NetworkFilename := IObj.FFile;
  SiteAbbr := IObj.PlaceCode;
  AbsFileName := IObj.AFile;
  ImageType := IObj.ImgType;
  SiteAbbr := CheckSiteAbbr(SiteAbbr);
  If Not Directoryexists(FCacheDirectory + '\' + SiteAbbr) Then
  Begin
    CreateCacheDirectory(FCacheDirectory + '\' + SiteAbbr);
  End;

  NewList.Add(MagCacheManager.IMAGE_START + '^' + IObj.FFile);
  CacheInformation := NetworkFilename + '^' + FCacheDirectory + '\' +
    SiteAbbr + '\' + GetImageUtility().MagExtractFileName(NetworkFilename) + '^' + Inttostr(ImageType);
  ;
  NewList.Add(CacheInformation);

    // cache abstract, do we want to do this if abstract caching is off?
  CacheInformation := AbsFileName + '^' + FCacheDirectory + '\' +
    SiteAbbr + '\' + GetImageUtility().MagExtractFileName(AbsFileName) + '^' + Inttostr(ImageType);
  ;
  NewList.Add(CacheInformation);

  If IsRadiology(ImageType) And (GetImageUtility().DetermineStorageProtocol(NetworkFilename) = MagStorageUNC) Then
  Begin
    TxtFilename := ChangeFileExt(NetworkFilename, '.txt');
    CacheInformation := TxtFilename + '^' + FCacheDirectory + '\' + SiteAbbr + '\' + ExtractFileName(TxtFilename);
    NewList.Add(CacheInformation);
  End;
  NewList.Add(MagCacheManager.IMAGE_COMPLETE + '^' + IObj.FFile);
    //AddCachedImage(iobj.Mag0, iobj.PlaceIEN, iobj.GroupCount);
  AddCachedImage(IObj.FFile, IObj.GroupCount);
  Result := NewList;
End;

Function TMagImageManager.ExtractGroupImagesFromImageData(GroupNetworkFilename: String; GroupCount: Integer; InList: Tlist): TStrings;
Var
  OldList: Tlist;
  NewList: TStrings;
  Part2: String;
  i: Integer;
  NetworkFilename, SiteAbbr, CacheInformation, TxtFilename, AbsFileName: String;
    //  ImageIEN, PlaceIEN : String;
  ImageType: Integer;
  IObj: TImageData;
Begin
  OldList := InList;
  If OldList = Nil Then
  Begin
    Result := Nil;
    Exit;
  End;
  NewList := Tstringlist.Create();

  If IsStudyCached(GroupNetworkFilename, GroupCount) Then
  Begin
    Magremoteinterface.RIVNotifyAllListeners(Nil, MagCacheManager.IMAGE_COMPLETE, GroupNetworkFilename);
        //LogMsg('s', 'Study is already cached');
    magAppMsg('s', 'Study is already cached'); {JK 10/6/2009 - Maggmsgu refactoring}
    Result := NewList;
    Exit;
  End;

  NewList.Add(MagCacheManager.IMAGE_START + '^' + GroupNetworkFilename);

  For i := 0 To OldList.Count - 1 Do
  Begin
    IObj := OldList.Items[i];
    NetworkFilename := IObj.FFile;
    SiteAbbr := CheckSiteAbbr(IObj.PlaceCode);
    ImageType := IObj.ImgType;
    AbsFileName := IObj.AFile;
    If Not Directoryexists(FCacheDirectory + '\' + SiteAbbr) Then
    Begin
      CreateCacheDirectory(FCacheDirectory + '\' + SiteAbbr);
    End;

    CacheInformation := NetworkFilename + '^' + FCacheDirectory + '\' +
      SiteAbbr + '\' + GetImageUtility().MagExtractFileName(NetworkFilename) + '^' + Inttostr(ImageType);
    NewList.Add(CacheInformation);

        // cache abstract, do we want to do this if abstract caching is off?
    CacheInformation := AbsFileName + '^' + FCacheDirectory + '\' +
      SiteAbbr + '\' + GetImageUtility().MagExtractFileName(AbsFileName) + '^' + Inttostr(ImageType);
    NewList.Add(CacheInformation);

        // if the image is a Radiology Image it might also have a text file, retrieve that file also
    If IsRadiology(ImageType) And (GetImageUtility().DetermineStorageProtocol(NetworkFilename) = MagStorageUNC) Then
    Begin
      TxtFilename := ChangeFileExt(NetworkFilename, '.txt');
      CacheInformation := TxtFilename + '^' + FCacheDirectory + '\' + SiteAbbr + '\' + ExtractFileName(TxtFilename);
      NewList.Add(CacheInformation);
    End;
  End;
  NewList.Add(MagCacheManager.IMAGE_COMPLETE + '^' + GroupNetworkFilename);
  AddCachedImage(GroupNetworkFilename, GroupCount);
  Result := NewList;
End;

Function TMagImageManager.ExtractGroupImages(GroupNetworkFilename: String; GroupCount: Integer; InList: TStrings): TStrings;
Var
  OldList: TStrings;
  NewList: TStrings;
  Part2: String;
  i: Integer;
  NetworkFilename, SiteAbbr, CacheInformation, TxtFilename, AbsFileName: String;
    //  ImageIEN, PlaceIEN : String;
  ImageType: Integer;
Begin
  OldList := InList;
  If OldList = Nil Then
  Begin
    Result := OldList;
    Exit;
  End;
  NewList := Tstringlist.Create();
  OldList.Delete(0);

  If IsStudyCached(GroupNetworkFilename, GroupCount) Then
  Begin
    Magremoteinterface.RIVNotifyAllListeners(Nil, MagCacheManager.IMAGE_COMPLETE, GroupNetworkFilename);
        //maggmsgf.MagMsg('s', 'Study is already cached');
        //LogMsg('s', 'Study is already cached');
    magAppMsg('s', 'Study is already cached'); {JK 10/6/2009 - Maggmsgu refactoring}
    Result := NewList;
    Exit;
  End;

  NewList.Add(MagCacheManager.IMAGE_START + '^' + GroupNetworkFilename);

  For i := 0 To OldList.Count - 1 Do
  Begin

        // determine in here if there is a text file also (3, 100)
      //    ImageIEN := magUtilities.MagPiece(oldlist.strings[i], '^', 2);
      //    PlaceIEN := magUtilities.MagPiece(oldlist.Strings[i], '^', 16);
    NetworkFilename := MagUtilities.MagPiece(OldList.Strings[i], '^', 3);
    SiteAbbr := CheckSiteAbbr(MagUtilities.MagPiece(OldList.Strings[i], '^', 17));
    ImageType := Strtoint(MagUtilities.MagPiece(OldList.Strings[i], '^', 7));
    AbsFileName := MagUtilities.MagPiece(OldList.Strings[i], '^', 4);
    If Not Directoryexists(FCacheDirectory + '\' + SiteAbbr) Then
    Begin
      CreateCacheDirectory(FCacheDirectory + '\' + SiteAbbr);
    End;

    CacheInformation := NetworkFilename + '^' + FCacheDirectory + '\' +
      SiteAbbr + '\' + GetImageUtility().MagExtractFileName(NetworkFilename) + '^' + Inttostr(ImageType);
    NewList.Add(CacheInformation);

        // cache abstract, do we want to do this if abstract caching is off?
    CacheInformation := AbsFileName + '^' + FCacheDirectory + '\' +
      SiteAbbr + '\' + GetImageUtility().MagExtractFileName(AbsFileName) + '^' + Inttostr(ImageType);
    NewList.Add(CacheInformation);

        // if the image is a Radiology Image it might also have a text file, retrieve that file also
    If IsRadiology(ImageType) And (GetImageUtility().DetermineStorageProtocol(NetworkFilename) = MagStorageUNC) Then
    Begin
      TxtFilename := ChangeFileExt(NetworkFilename, '.txt');
      CacheInformation := TxtFilename + '^' + FCacheDirectory + '\' + SiteAbbr + '\' + ExtractFileName(TxtFilename);
      NewList.Add(CacheInformation);
    End;
  End;

  NewList.Add(MagCacheManager.IMAGE_COMPLETE + '^' + GroupNetworkFilename);
  AddCachedImage(GroupNetworkFilename, GroupCount);
  Result := NewList;
End;

Function CheckSiteAbbr(SiteAbbr: String): String;
Var
  Abbr, Res: String;
  i: Integer;
Begin
    // JMW 9/4/08 p72t26 if the abbreviation starts with DOD, change it just
    // be DOD. This is needed because we display the abbreviation with the
    // site name for DOD sites, but we want to cache all DOD sites images
    // together. This is a bit of a kludge, but it should work.
  If Pos('DOD', SiteAbbr) = 1 Then
    Abbr := 'DOD'
  Else
    Abbr := SiteAbbr;
  Res := Abbr;
  If Abbr = '' Then
    Res := 'none';

  Abbr := Uppercase(Res);
  Res := '';
  For i := 1 To Length(Abbr) Do
  Begin
    Res := Res + Inttostr(Ord(Abbr[i]));
  End;
  Result := Res;
End;

Procedure TMagImageManager.StartCache(Images: TStrings);
Begin
    {
      if CacheManager <> nil then
      begin
        CacheManager.stopCache();
    //    CacheManager.WaitFor(); // wait for the cache manager to complete copying at least its last image (to ensure a complete image copy)
    //    CacheManager.Destroy();
        CacheManager := nil;
      end;
      }

  If ImagesToCache <> Nil Then
  Begin
        //    ImagesToCache.Destroy();
    ImagesToCache := Nil;
  End;

  ImagesToCache := Tstringlist.Create();
  ImagesToCache.AddStrings(Images);

  If CacheManager = Nil Then
  Begin

    CacheManager := TCacheManager.Create(True, FMagSecurity); //, DestinationDirectory);
        //CacheManager.OnLogEvent := OnLogEvent; {JK 10/6/2009 - Maggmsgu refactoring}
    CacheManager.SetImages(ImagesToCache);
  End
  Else
    If CacheManager.StillCaching() Then // it is currently caching images
    Begin
      CacheManager.AddImages(ImagesToCache);
    End
    Else
    Begin
      CacheManager.StopCache();
      CacheManager.WaitFor(); // wait for the cache manager to complete copying at least its last image (to ensure a complete image copy)
      CacheManager.Destroy();
      CacheManager := Nil;
      CacheManager := TCacheManager.Create(True, FMagSecurity); //, DestinationDirectory);
        //CacheManager.OnLogEvent := OnLogEvent; {JK 10/6/2009 - Maggmsgu refactoring}
      CacheManager.SetImages(ImagesToCache);
    End;

    // this doesn't work!  this code executes right after starting the queueing, not when its done
  //  SafeCloseNetworkConnections();

End;

Procedure TMagImageManager.StopCache();
Begin
  If CacheManager <> Nil Then
  Begin
    CacheManager.StopCache();
    CacheManager.WaitFor(); // wait for the cache manager to complete copying at least its last image (to ensure a complete image copy)
    CacheManager.Destroy();
    CacheManager := Nil;
  End;
End;

(* not used in 59
function TMagImageManager.canGetFile(NetworkFilename, SiteAbbr : String) : boolean;
var
msg : String;
begin
  if getCachedImage(NetworkFilename, SiteAbbr) <> '' then
  begin
    result := true;
    exit;
  end;
  if getImageUtility().determineStorageProtocol(NetworkFilename) = MagStorageUNC then
  begin

    if FMagSecurity.MagOpenSecurePath(NetworkFilename, msg) then
    begin
      if FileExists(NetworkFilename) then
      begin
        result := true;
      end
      else
      begin
        result := false;
      end;
      SafeCloseNetworkConnections();
      exit;
    end;
    result := false;
  end
  else
  begin
    result := true;
  end;
end;
*)

        {
THIS IS FROM 59.  IT MAY NOT WORK IN 72 BECAUSE OF CHANGES.
COMPARE WHAT CALLS THIS WITH 'CanGetFile' ...

      Gets Image from Network, Option to Cache it, returns message if error}

Function TMagImageManager.GetImageFile(NetworkFilename, SiteAbbr: String;
  Var Xmsg: String; CacheAlso, KeepConnectionActive: Boolean): String;
Var
  DestinationFilename, Msg: String;
Begin
  Try
 {/p117 gek 1/17/11.  This is what we need to change for the photo cache problem..
    FCacheDirectory is a 'Display' variable, not set in capture, so at this point in the code
    in the Capture application,  it is null,  and produces the unexpected directory \SiteAbbr\...}
    SiteAbbr := CheckSiteAbbr(SiteAbbr);
    DestinationFilename := FCacheDirectory + '\' + SiteAbbr + '\' + ExtractFileName(NetworkFilename);
        {}
    If FileExists(DestinationFilename) Then
    Begin
      Result := DestinationFilename;
      Exit;
    End;
    If IsFileCurrentlyCaching(NetworkFilename) Then
    Begin
            //LogMsg('s', 'Image is already being cached, about to wait for thread to complete.');
      magAppMsg('s', 'Image is already being cached, about to wait for thread to complete.'); {JK 10/6/2009 - Maggmsgu refactoring}
      WaitForImageThread();
            //LogMsg('s', 'Image caching thread is complete, loading image...');
      magAppMsg('s', 'Image caching thread is complete, loading image...'); {JK 10/6/2009 - Maggmsgu refactoring}
      Result := DestinationFilename;
      Exit;
    End;
        {}
    If Not idmodobj.GetMagFileSecurity.MagOpenSecurePath(NetworkFilename, Xmsg) Then
    Begin
      Result := '';
      Exit;
    End;
    If Not FileExists(NetworkFilename) Then
    Begin
      Result := '';
      Xmsg := 'File does not exist.';
      Exit;
    End;
 {HERE HERE PATCH 117 FIXING BUG FOR PHOTO IMAGES CACHED IN WRONG DIRECTORY, AND NOT BEGIN CLEANED UP.
   First : CahceAlso is TRUE....  we prob want to leave it that way
   Second:  the FCacheDirectory is '', so the SiteAbbr (with is the number 837665.., is used to make a directory.

   This may go away, if we Set FCacheDirectory to the Correct Direotory...  }
        {Connected to Network Dir, and File does exist }
    If Not CacheAlso Then
    Begin
      Result := NetworkFilename;
      Exit;
    End;

    If Not Directoryexists(FCacheDirectory + '\' + SiteAbbr) Then
      CreateCacheDirectory(FCacheDirectory + '\' + SiteAbbr);
    If Not Directoryexists(FCacheDirectory + '\' + SiteAbbr) Then
    Begin
      Result := '';
      Xmsg := 'Error creating local directory';
      Exit;
    End;
        {TODO: Do we need to stop this image from being cached by the Thread.}
        //LogMsg('s', 'Caching image [' + extractfilename(NetworkFilename) + ']');
    magAppMsg('s', 'Caching image [' + ExtractFileName(NetworkFilename) + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
    Try
      CopyFile(NetworkFilename, DestinationFilename);
      Result := DestinationFilename;
    Except
      On e: Exception Do
      Begin
                //LogMsg('s', 'Error caching image [' + NetworkFilename + ']. Error=[' + e.Message + '].');
        magAppMsg('s', 'Error caching image [' + NetworkFilename + ']. Error=[' + e.Message + '].'); {JK 10/6/2009 - Maggmsgu refactoring}
        Xmsg := 'OS Message: ' + SysErrorMessage(Getlasterror);
        Result := '';
      End;
    End;

  Finally
    If Not KeepConnectionActive Then
      SafeCloseNetworkConnections();
  End;
End;

{   gek //93t10  There is a function like this 'IsThisImageLocal'  but it's in umagDisplayMgr.pas
                I didn't want to add that to the uses clause of this (MagImageManager) so this function
                does what that one does....  }

//Function TMagImageManager.IsLocalImage(IObj: TImageData): Boolean;
Function TMagImageManager.IsThisImageLocaltoSite(IObj: TImageData): Boolean;
Begin //p94t10 gek  Put back in the comparion of PlaceCode (3 letter site code)
        // to stop consolidated Abstracts being treated as local.
  If (IObj.PlaceCode <> Gsess.WrksPlaceCODE)
    Or (IObj.PlaceIEN <> GSess.WrksPlaceIEN) // JMW 3/25/2005 p45
    Or (IObj.ServerName <> idmodobj.GetMagDBBroker1.GetServer)
    Or (IObj.ServerPort <> idmodobj.GetMagDBBroker1.GetListenerPort) Then
    Result := False
  Else
    Result := True;
End;

//function TMagImageManager.getImageGuaranteed(IObj : TImageData;
///    needAbstract : boolean = false; KeepConnectionActive : boolean = false) : String;

Function TMagImageManager.GetImageGuaranteed(IObj: TImageData;
  ImgType: TMagImageType = MagImageTypeFull;
  KeepConnectionActive: boolean = false;
  ignBlock: boolean = false): TMagImageTransferResult; //skipped in 106, p94 added ignBlock
Var
  CachedFile, Fname: String;
  FailedNetworkConnectionBMP: String;
  ImgResult: TMagImageTransferResult;
  ImgName, Rmsg: String;
Begin
  ImgResult := Nil;
  If ImgType = MagImageTypeAbs Then
  Begin
    Fname := IObj.AFile;

//    if IObj.PlaceIEN = '200' then
//      if Pos('.\BMP\DOD_Doc.bmp', IObj.AFile) > 0 then
//      begin
//        if IObj.ImgType = 1 then
//          Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
//            + '\BMP\DoD_JPG.bmp', UNKNOWN_IMG, IMAGE_COPIED)
//        else if IObj.ImgType = 102 then
//          Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
//            + '\BMP\DoD_Word.bmp', UNKNOWN_IMG, IMAGE_COPIED)
//        else if IObj.ImgType = 103 then
//          Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
//            + '\BMP\DoD_ASCII.bmp', UNKNOWN_IMG, IMAGE_COPIED)
//        else if IObj.ImgType = 104 then
//          Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
//            + '\BMP\DoD_PDF.bmp', UNKNOWN_IMG, IMAGE_COPIED)
//        else if IObj.ImgType = 105 then
//          Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
//            + '\BMP\DoD_RTF.bmp', UNKNOWN_IMG, IMAGE_COPIED)
//        else
//          Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
//            + '\BMP\DoD_Doc.bmp', UNKNOWN_IMG, IMAGE_COPIED);
//
//        Exit;
//      end;


    {/ P117 JK 1/31/2011 - Adding support for discrete DoD artifact canned bitmaps for the
       abstracts the DoD does not provide. Exclude ImgTypes 3, 11, and 100
       (3=TGA, 11=X-ray Group, and 100=DICOM since the DoD does provide thumbnail. /}
    if IObj.PlaceIEN = '200' then
    begin
      if (IObj.ImgType <> 3) and (IObj.ImgType <> 11) and (IObj.ImgType <> 100) then
      begin
        case IObj.ImgType of
          501: Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
                 + '\BMP\DoD_NCAT.bmp', UNKNOWN_IMG, IMAGE_COPIED);         {NCAT canned bitmap}
          502: Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
                 + '\BMP\DoD_Unavailable.bmp', UNKNOWN_IMG, IMAGE_COPIED);  {Un-displayable canned bitmap}
          503: Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
                 + '\BMP\DoD_JPG.bmp', UNKNOWN_IMG, IMAGE_COPIED);          {JPG canned bitmap}
          504: Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
                 + '\BMP\DoD_Word.bmp', UNKNOWN_IMG, IMAGE_COPIED);         {WORD canned bitmap}
          505: Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
                 + '\BMP\DoD_ASCII.bmp', UNKNOWN_IMG, IMAGE_COPIED);        {ASCII canned bitmap}
          506: Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
                 + '\BMP\DoD_PDF.bmp', UNKNOWN_IMG, IMAGE_COPIED);          {PDF canned bitmap}
          507: Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
                 + '\BMP\DoD_RTF.bmp', UNKNOWN_IMG, IMAGE_COPIED);          {RTF canned bitmap}
          else
               Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
                 + '\BMP\DoD_Doc.bmp', UNKNOWN_IMG, IMAGE_COPIED);         {DoD artifact catch-all canned bitmap}
        end;
        Exit;
      end;
    end;

    FailedNetworkConnectionBMP := MagUtilities.GetAppPath + '\bmp\AbsError.bmp';

        { JMW P72 12/4/07 - use a different image if the image is unavailable through the ViX}
    If GetImageUtility().DetermineStorageProtocol(Fname) = MagStorageHTTP Then
      FailedNetworkConnectionBMP := MagUtilities.GetAppPath + '\bmp\ImageUnavailable.bmp';

        //p93t10 gek fix Blocked Image abstract was being shown.
        //p93t12 Moved this block before Cache Image.  If Image status was changed during this
        //  session, then we need to show 'Needs Review' bmp, instead of real (maybe already
        //     cached) abstract
(*    if iobj.QAMsg = '' then
      if not Iobj.IsViewAble then
      begin
        result := TMagImageTransferResult.Create(fname, magUtilities.GetAppPath
          + '\BMP\magBlockedImage.bmp', UNKNOWN_IMG, IMAGE_COPIED);
        exit;
      end;
*)
    If IObj.QAMsg = '' Then
    begin
      {/ P117 - JK 9/20/2010 - add in support for deleted image placeholders /}
      if IObj.IsImageDeleted then
      begin
        if IObj.IsImageGroup then
          Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
            + '\BMP\magDeletedGroup.bmp', UNKNOWN_IMG, IMAGE_COPIED)
        else
          Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
            + '\BMP\magDeletedImage.bmp', UNKNOWN_IMG, IMAGE_COPIED);
        Exit;
      end
      else if ((not Iobj.IsViewAble) and (not ignBlock)) then
      Begin
        Result := TMagImageTransferResult.Create(Fname, MagUtilities.GetAppPath
          + '\BMP\magBlockedImage.bmp', UNKNOWN_IMG, IMAGE_COPIED);
        Exit;
      End;
    end;
        // first try to get the image from the cache
        // (in case we don't want to cache the image - if not viewing remote abs)
    ImgName := GetCachedImage(Fname, IObj.PlaceCode);
    If ImgName <> '' Then
    Begin
      Result := TMagImageTransferResult.Create(Fname, ImgName, UNKNOWN_IMG, IMAGE_COPIED);
      Exit;
    End;

        { JMW 7/30/08 P72t23 if the image was not found in the cache
           check to see if the image is offline or on jukebox, if so we are not
           going to display it.
        }
    If (Uppercase(IObj.AbsLocation) = 'O') Then
    Begin
      Result := TMagImageTransferResult.Create(Fname,
        MagUtilities.GetAppPath + '\BMP\JBOFFLN.ABS', UNKNOWN_IMG, IMAGE_COPIED);
      Exit;
    End;
    If (Uppercase(IObj.AbsLocation) = 'W') Then
    Begin
            { Abstract is on JukeBox. 'W' means 'Worm Drive'}
            // never going to show JB images...
      Result := TMagImageTransferResult.Create(Fname,
        MagUtilities.GetAppPath + '\BMP\ABSJBOX.BMP', UNKNOWN_IMG, IMAGE_COPIED);
      Exit;
    End;

     //gek 93t10  created the IsThisImageLocaltoSite call, and used that.
     { It compares server port which has been agreed is a better way to determine
       if an Image is local or Remote than just PlaceCode.
       94t10  gek, fix again, the function that determines if this image is local, or remote.
       we have 2 calls: 
              one checks DB (database : just Server and Port) 
              other 'Site'  checks PlaceCode and PlaceIEN also.  }
     // if IObj.PlaceCode <> GSess.WrksPlacecode first then

    If Not IsThisImageLocaltoSite(IObj) Then
    Begin
      If (Not Upref.AbsViewRemote) Then
      Begin
        Result := TMagImageTransferResult.Create(Fname,
          MagUtilities.GetAppPath + '\BMP\ABSREMOTE.BMP', UNKNOWN_IMG, IMAGE_COPIED);
        Exit;
      End;
    End;
  End {if   ImgType = MagImageTypeAbs }
  Else
  Begin
    If ImgType = MagImageTypeFull Then
      Fname := IObj.FFile
    Else
      Fname := IObj.BigFile;
        // JMW P72 12/4/07 - change the image to use if the image is unavailable (409 from ViX, network unavailable from image share).
        //FailedNetworkConnectionBMP := magUtilities.AppPath + '\bmp\FullResFileOpenError.bmp';
    FailedNetworkConnectionBMP := MagUtilities.GetAppPath + '\bmp\ImageUnavailable.bmp';
  End;

  Result := GetFile(Fname, IObj.PlaceCode, IObj.ImgType, KeepConnectionActive, False);
  If Result.FTransferStatus = IMAGE_FAILED Then
  Begin
        //    if needAbstract then
    If ImgType = MagImageTypeAbs Then
      Result.FDestinationFilename := ResolveCannedAbstract(IObj, False, Not KeepConnectionActive)
    Else
      Result.FDestinationFilename := MagUtilities.GetAppPath + '\BMP\FullResFileNotFound.BMP';
  End
  Else
    If Result.FTransferStatus = IMAGE_UNAVAILABLE Then
      Result.FDestinationFilename := FailedNetworkConnectionBMP;
End;


{/ P117 - JK 9/22/2010 - This is a public wrapper for the private call to ResolveCannedAbstract /}
function TMagImageManager.ResolveAbstract(ImageObj: TImageData; ShowJB: Boolean = False; CloseSecurity: Boolean = True): String;
begin
  Result := ResolveCannedAbstract(ImageObj);
end;

Function TMagImageManager.ResolveCannedAbstract(ImgObj: TImageData; ShowJB: Boolean = False; CloseSecurity: Boolean = True): String;
Var
  Xmsg, s: String;
  AppPath: String;
  i: Integer;
  CachedFileName: String;
Begin
  AppPath := MagUtilities.GetAppPath;
  s := ImgObj.AbsLocation;
    //result := imgObj.AFile;
  Result := AppPath + '\BMP\NOTEXIST.BMP';
    { TODO : URGENT  avi canned bitmap.   Need flag to say that this image has canned bitmap.
              or no abstract, so we don't get these errors. }
    { TODO :  need to change the 'O' and 'W' to enumerated type.
              maglocMag, maglocJB, }

  If (Uppercase(ImgObj.AbsLocation) = 'O') Then
  Begin
    Result := AppPath + '\BMP\JBOFFLN.ABS';
    Exit;
  End;
  If (Uppercase(ImgObj.AbsLocation) = 'W') Then
  Begin
        { Abstract is on JukeBox. 'W' means 'Worm Drive'}
    If (Not ShowJB)
            {if not viewing JukeBox Abstracts then Display the BMP}Then
    Begin
      Result := AppPath + '\BMP\ABSJBOX.BMP';
      Exit;
    End

            { we are viewing JB Abs, so Queue it also}
    Else //old   queabs.add(ptrMagRecord^.Mag0);
  End;
    //P48T2 DBI
  //  if imgobj.PlaceIEN <> WrksPlaceIEN then
  If ImgObj.PlaceCode <> GSess.WrksPlaceCODE Then // done not work!
  Begin
    If (Not Upref.AbsViewRemote) Then // JMW 3/9/2005 p45
            //      if (not IniViewRemoteAbs) then
      Result := AppPath + '\BMP\ABSREMOTE.BMP'
    Else
            // later magybe allow queue to local sserver .  ?
  End;
    { 12-PACS Group   10-PACS Resident    13-ECG     14-cine }
  Case ImgObj.ImgType Of
    12: Result := AppPath + '\BMP\ABSPACG.BMP';
    10: Result := AppPath + '\BMP\ABSPACI.BMP';
    13: Result := AppPath + '\bmp\absekg.bmp';
    14: Result := AppPath + '\bmp\abscine.bmp';
        //   21: Result := AppPath + '\bmp\MotionVideoAbs.bmp';
    21: Result := AppPath + '\bmp\magavi.bmp';
    101: Result := AppPath + '\bmp\maghtml.bmp';
    102: Result := AppPath + '\bmp\magdoc.bmp';
    103: Result := AppPath + '\bmp\magtext.bmp';
    104: Result := AppPath + '\bmp\magpdf.bmp';
    105: Result := AppPath + '\bmp\magrtf.bmp';
    106: Result := AppPath + '\bmp\magwav.bmp';
    501: Result := AppPath + '\bmp\DoD_NCAT.bmp';

    502: Result := AppPath + '\BMP\DoD_Unavailable.bmp';  {Un-displayable canned bitmap}
    503: Result := AppPath + '\BMP\DoD_JPG.bmp';          {JPG canned bitmap}
    504: Result := AppPath + '\BMP\DoD_Word.bmp';         {WORD canned bitmap}
    505: Result := AppPath + '\BMP\DoD_ASCII.bmp';        {ASCII canned bitmap}
    506: Result := AppPath + '\BMP\DoD_PDF.bmp';          {PDF canned bitmap}
    507: Result := AppPath + '\BMP\DoD_RTF.bmp';          {RTF canned bitmap}

    else
      if Pos('\BMP\DOD_Doc.bmp', ImgObj.AFile) > 0 then
        Result := AppPath + '\bmp\DOD_Doc.bmp';   {/ P117 JK 1/25/2011 - Support for DoD images that don't resolve well into a VA canned bitmap /}
  End; {case}
    // No connection to server from here
    {
    // don't need to put bmp images into users local cache
    if FWrksAbsCacheON and (cachedFilename = '') then
      BEGIN
        cachedFilename := MagImageManager1.getFile(result, imgobj.PlaceCode, not closesecurity);
        if cachedFilename <> '-1' then result := cachedFilename;
      end;
     }

End;

{
 Returns a local path to the file if it was successfully cached
 -1 if there was an error caching the image
 -2 if the network location is unavailable
 @param IsTXTFile is only necessary when requesting TXT file from ViX, adds
 a required parameter to the query string to tell the ViX to get the TXT file.
 For txt files from UNC paths - this parameter can be true or false (doesn't matter)

 ImgFormatType is the imageType from VistA
}

Function TMagImageManager.GetFile(NetworkFilename: String; SiteAbbr: String;
  ImgFormatType: Integer; KeepConnectionActive: Boolean = False;
  IsTXTFile: Boolean = False): TMagImageTransferResult;
Var
  DestinationFilename, Msg: String;
  ImageUtility: TMagImageUtility;
  StorageProtocol: MagStorageProtocol;
  ImgQuality: TMagImageQuality;
Begin
  ImageUtility := GetImageUtility();
  ImgQuality := UNKNOWN_IMG;
  StorageProtocol := ImageUtility.DetermineStorageProtocol(NetworkFilename);
  // JMW 5/1/2013 P131
  // the NetworkFilename for txt files might not be set calling into this method
  // be sure the file path has the correct parameters to get the txt file if a
  // text file is requested.
  if IsTxtFile then
    NetworkFilename := ImageUtility.GetTxtFilePath(NetworkFilename);
    // if this is a non HTTP image and caching for non-HTTP images is off, return network location
  If (StorageProtocol = MagStorageUNC) And (FCacheOnlyHttpImages) Then
  Begin
    Result := TMagImageTransferResult.Create(NetworkFilename, NetworkFilename,
      UNKNOWN_IMG, IMAGE_COPIED);
    Exit;
  End;
    // if no cache directory, then return network location
  If FCacheDirectory = '' Then
  Begin
    Result := TMagImageTransferResult.Create(NetworkFilename, NetworkFilename,
      UNKNOWN_IMG, IMAGE_COPIED);
    Exit;
  End;
    // if network location not specified, return error value
  If NetworkFilename = '' Then
  Begin
    Result := TMagImageTransferResult.Create(NetworkFilename, NetworkFilename,
      UNKNOWN_IMG, IMAGE_FAILED);
    Exit;
  End;
  SiteAbbr := CheckSiteAbbr(SiteAbbr);
  If StorageProtocol = MagStorageHTTP Then
  Begin
    DestinationFilename := FCacheDirectory + '\' + SiteAbbr + '\' + ImageUtility.ExtractUrlFileName(NetworkFilename);
    If IsTXTFile Then
      DestinationFilename := DestinationFilename + '.TXT'
    Else
    begin
      case ImgFormatType of
        21: // motion video, for the avi player to work, file must have an avi extension.
          DestinationFilename := DestinationFilename + '.avi';
        105, 507: // RTF
          DestinationFilename := DestinationFilename + '.rtf';
        107: // XML
          DestinationFilename := DestinationFilename + '.xml';
      end;
    end;
  End
  Else
    DestinationFilename := FCacheDirectory + '\' + SiteAbbr + '\' + ExtractFileName(NetworkFilename);
  If IsFileCurrentlyCaching(NetworkFilename) Then
  Begin
        //maggmsgf.MagMsg('s','Image is already being cached, about to wait for thread to complete.');
        //LogMsg('s', 'Image is already being cached, about to wait for thread to complete.');
    magAppMsg('s', 'Image is already being cached, about to wait for thread to complete.'); {JK 10/6/2009 - Maggmsgu refactoring}
    WaitForImageThread();
        //maggmsgf.MagMsg('s','Image caching thread is complete, loading image...');
        //LogMsg('s', 'Image caching thread is complete, loading image...');
    magAppMsg('s', 'Image caching thread is complete, loading image...'); {JK 10/6/2009 - Maggmsgu refactoring}
    Result := TMagImageTransferResult.Create(NetworkFilename,
      DestinationFilename, UNKNOWN_IMG, IMAGE_COPIED);
    Exit;
  End;
  If FileExists(DestinationFilename) Then
  Begin
    ImgQuality := ImageUtility.GetImageAlternateQuality(DestinationFilename);
    Result := TMagImageTransferResult.Create(NetworkFilename,
      DestinationFilename, ImgQuality, IMAGE_COPIED);
    Exit;
  End;

  If Not Directoryexists(ExtractFileDir(DestinationFilename)) Then
  Begin
    CreateCacheDirectory(ExtractFileDir(DestinationFilename));
  End;

    {
    if not DirectoryExists(FCacheDirectory + '\' + SiteAbbr) then
    begin
      forcedirectories(FCacheDirectory + '\' + SiteAbbr);
    end;
    }

  If StorageProtocol = MagStorageUNC Then
  Begin

    If FMagSecurity.MagOpenSecurePath(NetworkFilename, Msg) Then
    Begin
      If FileExists(NetworkFilename) Then
      Begin
                //LogMsg('s', 'Caching image [' + extractfilename(NetworkFilename) + ']');
        magAppMsg('s', 'Caching image [' + ExtractFileName(NetworkFilename) + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
        Try
          Magremoteinterface.RIVNotifyAllListeners(Nil, 'IMAGE_COPY_STARTED', '');
          Result := ImageUtility.MagUNCCopyFile(NetworkFilename, DestinationFilename);
                    //imageUtility.MagUNCCopyFile(NetworkFilename, DestinationFilename);
          Magremoteinterface.RIVNotifyAllListeners(Nil, 'IMAGE_COPY_COMPLETE', '');

        Except
          On e: Exception Do
          Begin
                        //LogMsg('s', 'Error caching image [' + NetworkFilename + ']. Error=[' + e.Message + '].');
            magAppMsg('s', 'Error caching image [' + NetworkFilename + ']. Error=[' + e.Message + '].'); {JK 10/6/2009 - Maggmsgu refactoring}
            Result := TMagImageTransferResult.Create(NetworkFilename,
              DestinationFilename, ImgQuality, IMAGE_FAILED);
          End;
        End;
        If Not KeepConnectionActive Then
          SafeCloseNetworkConnections();
        Exit;
      End
      Else
      Begin
                // this file doesn't exist on the network share, not sure what to do...
        Result := TMagImageTransferResult.Create(NetworkFilename,
          DestinationFilename, ImgQuality, IMAGE_FAILED);
        If Not KeepConnectionActive Then
          SafeCloseNetworkConnections();
        Exit;
      End;
    End
    Else
    Begin
            // could not open network connection
            // give a new result (-2 maybe)
      Result := TMagImageTransferResult.Create(NetworkFilename,
        DestinationFilename, ImgQuality, IMAGE_UNAVAILABLE);
      If Not KeepConnectionActive Then
        SafeCloseNetworkConnections();
      Exit;
    End;
    Result := TMagImageTransferResult.Create(NetworkFilename,
      DestinationFilename, ImgQuality, IMAGE_FAILED);
    If Not KeepConnectionActive Then
      SafeCloseNetworkConnections();
  End {UNC protocol}
  Else
  Begin
    Magremoteinterface.RIVNotifyAllListeners(Nil, 'IMAGE_COPY_STARTED', '');
    Result := ImageUtility.MagHttpCopyFile(NetworkFilename,
      DestinationFilename, IsTXTFile, ImgFormatType);
    Magremoteinterface.RIVNotifyAllListeners(Nil, 'IMAGE_COPY_COMPLETE', '');
    If Result.FTransferStatus = IMAGE_FAILED Then
    Begin
            //LogMsg('', 'Error getting image from ViX server');
      magAppMsg('', 'Error getting image from ViX server'); {JK 10/6/2009 - Maggmsgu refactoring}
    End
    Else
      If Result.FTransferStatus = IMAGE_UNAVAILABLE Then
      Begin
            //LogMsg('', 'Image unavailable from the ViX server (409 error)');
        magAppMsg('', 'Image unavailable from the ViX server (409 error)'); {JK 10/6/2009 - Maggmsgu refactoring}
      End;
  End;
End;

Function TMagImageManager.GetCachedImage(Filename: String; SiteAbbr: String): String;
Var
  Fname: String;
  StorageProtocol: MagStorageProtocol;
  ImageUtility: TMagImageUtility;
Begin
  ImageUtility := GetImageUtility();
  StorageProtocol := ImageUtility.DetermineStorageProtocol(Filename);
    // JMW 9/4/08 p72t26 - was not properly checking the cache for images
    // from the ViX.
    // if the image is from the ViX (DOD) the cached filename is different
    // than if its from a UNC share
  If (StorageProtocol = MagStorageUNC) Then
    Fname := FCacheDirectory + '\' + CheckSiteAbbr(SiteAbbr) + '\' + ExtractFileName(Filename)
  Else
    Fname := FCacheDirectory + '\' + CheckSiteAbbr(SiteAbbr) + '\' +
      ImageUtility.ExtractUrlFileName(Filename);
  If FileExists(Fname) Then
  Begin
    Result := Fname;
  End
  Else
  Begin
    Result := '';
  End;

End;

Procedure TMagImageManager.SafeCloseNetworkConnections();
Var
  Msg: String;
Begin
  If Not IsImageCurrentlyCaching() Then
  Begin
    FMagSecurity.MagCloseSecurity(Msg);
        //    dmod.MagFileSecurity.MagCloseSecurity(msg);
  End;
End;

Function TMagImageManager.IsRadiology(ImageType: Integer): Boolean;
Begin
  If (ImageType = 3) Or (ImageType = 100) Then
  Begin
    Result := True;
    Exit;
  End;
  Result := False;
End;

Function TMagImageManager.IsImageCached(NetworkFilename: String): Boolean;
Begin
  Result := IsStudyCached(NetworkFilename, 1);
End;

Function TMagImageManager.IsStudyCached(NetworkFilename: String; ImageCount: Integer): Boolean;
Var
  i: Integer;
  ImageInfo: TCachedImageInformation;
Begin

  For i := 0 To CachedImageList.Count - 1 Do
  Begin
    ImageInfo := CachedImageList.Items[i];
    If (ImageInfo.CacheComplete) And (NetworkFilename = ImageInfo.NetworkFilename) And (ImageInfo.ImageCount = ImageCount) Then
    Begin
      Result := True;
      Exit;
    End;
  End;
  Result := False;

End;

Procedure TMagImageManager.AddCachedImage(NetworkFilename: String; ImageCount: Integer);
Var
  ImageInfo: TCachedImageInformation;
Begin
  ImageInfo := TCachedImageInformation.Create();
  ImageInfo.NetworkFilename := NetworkFilename;
    //  ImageInfo.ImageIEN := ImageIEN;
    //  ImageInfo.PlaceIEN := PlaceIEN;
  ImageInfo.ImageCount := ImageCount;
  ImageInfo.CacheComplete := False;
  CachedImageList.Add(ImageInfo);
End;

Procedure TMagImageManager.SetImageCached(NetworkFilename: String);
Var
  i: Integer;
  ImageInfo: TCachedImageInformation;
Begin

  For i := 0 To CachedImageList.Count - 1 Do
  Begin
    ImageInfo := CachedImageList.Items[i];
    If NetworkFilename = ImageInfo.NetworkFilename Then
            //    if (ImageIEN = ImageInfo.ImageIEN) and (PlaceIEN = ImageInfo.PlaceIEN) then
    Begin
      ImageInfo.CacheComplete := True;
      CachedImageList.Items[i] := ImageInfo;
      Exit;
    End;
  End;
End;

//  TMagCannedAbs = (MagAbsPacGroup, MagAbsPacImage, MagAbsEKG, MagAbsCine, MagAbsAVI, MagAbsHTML, MagAbsDoc, MagAbsText,
//MagAbsPDF, MagAbsRTF, MagAbsWav, MagAbsQA, MagAbsJB, MagAbsError);

{
    12: result := AppPath + '\BMP\ABSPACG.BMP';
    10: Result := AppPath + '\BMP\ABSPACI.BMP';
    13: Result := AppPath + '\bmp\absekg.bmp';
    14: Result := AppPath + '\bmp\abscine.bmp';
    //   21: Result := AppPath + '\bmp\MotionVideoAbs.bmp';
    21: Result := AppPath + '\bmp\magavi.bmp';
    101: Result := AppPath + '\bmp\maghtml.bmp';
    102: Result := AppPath + '\bmp\magdoc.bmp';
    103: Result := AppPath + '\bmp\magtext.bmp';
    104: Result := AppPath + '\bmp\magpdf.bmp';
    105: Result := AppPath + '\bmp\magrtf.bmp';
    106: Result := AppPath + '\bmp\magwav.bmp';
    }

Function TMagImageManager.GetCannedBMP(AbsType: TMagCannedAbs): String;
Var
  AppPath: String;
Begin
  AppPath := MagUtilities.GetAppPath;
  Case AbsType Of
    MagAbsPacGroup: Result := AppPath + '\BMP\ABSPACG.BMP';
    MagAbsPacImage: Result := AppPath + '\BMP\ABSPACI.BMP';
    MagAbsEKG: Result := AppPath + '\BMP\ABSEKG.BMP';
    MagAbsCine: Result := AppPath + '\BMP\ABScine.BMP';
    MagAbsAVI: Result := AppPath + '\BMP\ABSavi.BMP';
    MagAbsHTML: Result := AppPath + '\BMP\ABShtml.BMP';
    MagAbsDoc: Result := AppPath + '\BMP\ABSdoc.BMP';
    MagAbsText: Result := AppPath + '\BMP\ABStext.BMP';
    MagAbsPDF: Result := AppPath + '\BMP\ABSpdf.BMP';
    MagAbsRTF: Result := AppPath + '\BMP\ABSrtf.BMP';
    MagAbsWav: Result := AppPath + '\BMP\ABSwav.BMP';
    MagAbsQA: Result := AppPath + '\BMP\imageqa.BMP';
    MagAbsJB: Result := AppPath + '\BMP\ABSjbox.BMP';
    MagAbsError: Result := AppPath + '\BMP\ABSerror.BMP';
    MagAbsDeletedImage: Result := AppPath + '\BMP\MagDeletedImage.BMP';  {/ P117 - JK 8/31/2010 /}
    MagAbsDeletedGroup: Result := AppPath + '\BMP\MagDeletedGroup.BMP';  {/ P117 - JK 8/31/2010 /}
  End;

End;

Function TMagImageManager.CreateRequestPathForImage(IObj: TImageData;
  ImageType: TMagImageType): String;
Var
  Fname: String;
Begin
  Case ImageType Of
    MagImageTypeAbs: Fname := IObj.AFile;
    MagImageTypeFull: Fname := IObj.FFile;
    MagImageTypeBig: Fname := IObj.BigFile;
    MagImageTypeTxt: Fname := ChangeFileExt(IObj.FFile, '.txt');
  End;

  If GetImageUtility().DetermineStorageProtocol(Fname) = MagStorageUNC Then
  Begin
    Result := Fname;
  End
  Else
  Begin

  End;

End;

Procedure TMagImageManager.GetImageTxtFileText(IObj: TImageData; Var t: TStrings; Xmsg: String);
Var
  Textfile: Tfilename;
Begin
  t.Clear;
  Textfile := ExtractFilePath(IObj.FFile) + MagPiece(ExtractFileName(IObj.FFile), '.', 1) + '.txt';
  t.Add('Image .TXT File : ' + Textfile);
  Try
    If Not idmodobj.GetMagFileSecurity.MagOpenSecurePath(Textfile, Xmsg) Then
    Begin
      t.Add(Xmsg);
      Exit;
    End;
    If Not FileExists(Textfile) Then
    Begin
      t.Add('------ Image .TXT file does not exist. -----');
      Exit;
    End;

    t.LoadFromFile(Textfile);
  Finally
    idmodobj.GetMagFileSecurity.MagCloseSecurity(Xmsg);
  End;
End;

{ JMW 6/21/2013 P131
Creates cache directory and copies stylesheets to that directory}
procedure TMagImageManager.CreateCacheDirectory(Directory : String);
var
  Sr: TSearchRec;
  FileAttrs: Integer;
begin
  Forcedirectories(Directory);

  if not DirectoryExists(FStylesheetsDirectory) then
  begin
    magAppMsg('', 'Stylesheet directory ['+ FStylesheetsDirectory + '] does not exit');
    exit;
  end;

  FileAttrs := FaAnyFile;
  If FindFirst(FStylesheetsDirectory + '\*.*', FileAttrs, Sr) = 0 Then
  Begin
    Repeat
      If (Sr.Name <> '.') And (Sr.Name <> '..') Then
      Begin
        CopyFile(FStylesheetsDirectory + '\' + Sr.Name, Directory + '\' + Sr.Name);
      End;

    Until FindNext(Sr) <> 0;
    FindClose(Sr);
  End;
end;

Initialization

Finalization
  If MagImageManager1 <> Nil Then FreeAndNil(MagImageManager1);//RLM Fixing MemoryLeak 6/18/2010
End.
