Unit MagCacheManager;
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
        ;;  Date created: May 2005
        ;;  Site Name:  Washington OI Field Office, Silver Spring, MD
        ;;  Developer:  Julian Werfel
        ;;  Description: This is a manager object that controls the background
        ;;  caching of images. This object runs in it's own thread and creates
        ;;  MagCacheImage objects to cache each individual image. Only 1
        ;;  MagCacheImage object is created at a time.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Classes,
  //cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
//RCA  Maggmsgu,
  Imaginterfaces,
  cMagSecurity,
  cMagUtils,
  MagCacheImage
  ;

//Uses Vetted 20090929:fmxutils, cMagImageUtility, MagRemoteInterface, sysutils

Type
  TCacheManager = Class(TThread)
  Private
//    DestinationDirectory : String;
    ImageList: TStrings;
    CacheImages: Boolean;
    MagUtilities: TMagUtils;
    aThread: TCacheImage;

    FCurrentCacheFile: String;

    OpenNetworkConnections: TStrings;

    //FOnLogEvent : TMagLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}
    FMagSecurity: TMag4Security;

//Was for RCA decouple magmsg, not now.        procedure MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);          //RCA

    Function ConvertList(IList: TStrings): TStrings;
    Procedure SetCurrentCacheFile(Value: String);
    Function CheckOpenNetworkConnections(NetworkFilename: String): Boolean;
    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);  {JK 10/5/2009 - Maggmsgu refactoring - remove old method}

  Public

    Procedure SetImages(NewImageList: TStrings); // adds images and starts caching
    Procedure AddImages(NewImageList: TStrings);
    Procedure StopCache();
    Procedure ResumeCache();

    Function StillCaching(): Boolean; // does the manager have images in it's queue
    Function CurrentlyCachingImage(): Boolean;
    Function GetExecutingThread(): TThread;

    Property CurrentCacheFile: String Read FCurrentCacheFile Write SetCurrentCacheFile;

    Constructor Create(CreateSuspended: Boolean; Security: TMag4Security); //; DestDirectory : String);
    Procedure Execute; Override;

    //property OnLogEvent : TMagLogEvent read FOnLogEvent write FOnLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}

  End;

Const
  IMAGE_START = 'ImageStart';
Const
  IMAGE_COMPLETE = 'ImageComplete';

Implementation

Uses
  cMagImageUtility,
  MagImageManager,
  Magremoteinterface,
  SysUtils
  ;


//RCA 11/11/2011  gek  remove dependency on maggmsgu and VCLZip.  Use interface (if it is declared).
(*  procedure TCacheManager.MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);
begin
if ImsgObj <> nil then  ImsgObj.LogMsg(msgtype,msg,priority);
end;
*)
{JK 10/6/2009 - Maggmsgu refactoring - remove old method}
//procedure TCacheManager.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//end;

Procedure TCacheManager.StopCache();
Begin
  CacheImages := False;
  If aThread <> Nil Then
  Begin
    aThread.Terminate();
    aThread.Destroy();
    aThread := Nil;
  End;
End;

Procedure TCacheManager.SetCurrentCacheFile(Value: String);
Begin
  FCurrentCacheFile := Value;
End;

Function TCacheManager.CurrentlyCachingImage(): Boolean;
Begin
  // is this the correct logic to determine this?
  If (ImageList = Nil) Or (ImageList.Count = 0) Then
//  if aThread = nil or imagelist = nil or imagelist.Count = 0 then
  Begin
    Result := False;
  End
  Else
  Begin
    Result := True;
  End;
End;

Function TCacheManager.GetExecutingThread(): TThread;
Begin
  Result := aThread;
End;

Function TCacheManager.StillCaching(): Boolean;
Begin
  If ImageList = Nil Then
  Begin
    Result := False;
    Exit;
  End;
  If ImageList.Count > 0 Then
  Begin
    Result := True;
    Exit;
  End;
  Result := False;
End;

Procedure TCacheManager.ResumeCache();
Begin
  If Not CacheImages Then
  Begin
    CacheImages := True;
    Self.Resume();
  End;
End;

Function TCacheManager.ConvertList(IList: TStrings): TStrings;
Var
  OldList: TStrings;
  NewList: TStrings;
  Part2: String;
  i: Integer;
Begin
  OldList := IList;
  If OldList = Nil Then
  Begin
    Result := OldList;
    Exit;
  End;
  NewList := Tstringlist.Create();
  OldList.Delete(0);

  For i := 0 To OldList.Count - 1 Do
  Begin
    Part2 := MagUtilities.MagPiece(OldList.Strings[i], '|', 2);
    If Part2 = '' Then
    Begin
      NewList.Add(MagUtilities.MagPiece(OldList.Strings[i], '^', 3));
    End
    Else
    Begin
      NewList.Add(MagUtilities.MagPiece(Part2, '^', 2));
    End;

  End;

  Result := NewList;

End;

Procedure TCacheManager.AddImages(NewImageList: TStrings);
Begin
  ImageList.AddStrings(NewImageList);
End;

Procedure TCacheManager.SetImages(NewImageList: TStrings);
Var
  NewiList: TStrings;
Begin
  If NewImageList = Nil Then Exit;
  If NewImageList.Count <= 0 Then Exit;
  NewiList := Tstringlist.Create();

  NewiList.AddStrings(NewImageList);
  CacheImages := False; // stop any copying of images
  If ImageList <> Nil Then ImageList.Clear();
  ImageList := NewiList; //ConvertList(newIlist);

//  ImageList.SaveToFile('c:\imagelist.txt');
  CacheImages := True;
  Self.Resume();
End;

Procedure TCacheManager.Execute;
Var
  i: Integer;
  Msg: String;
  CacheInformation, NetworkFilename, DestinationFilename, NetworkShare: String;
  ImgType: String;
  AvailableConnection: Boolean;
  ImageIEN, PlaceIEN: String;
  StorageProtocol: MagStorageProtocol;
Begin

  CurrentCacheFile := '';

  CacheImages := True;

  While CacheImages And (ImageList.Count > 0) Do
  Begin
    AvailableConnection := False;
    CacheInformation := ImageList.Strings[0];
    NetworkFilename := MagUtilities.MagPiece(CacheInformation, '^', 1);
    DestinationFilename := MagUtilities.MagPiece(CacheInformation, '^', 2);
    ImgType := MagUtilities.MagPiece(CacheInformation, '^', 3);

    If NetworkFilename = IMAGE_START Then
    Begin
      Magremoteinterface.RIVNotifyAllListeners(Nil, NetworkFilename, DestinationFilename);
//      maggmsgf.MagMsg('s','Caching of study started');
      //LogMsg('s','Caching of study started');
      magAppMsg('s', 'Caching of study started'); {JK 10/6/2009 - Maggmsgu refactoring}
    End
    Else
      If NetworkFilename = IMAGE_COMPLETE Then
      Begin
        Magremoteinterface.RIVNotifyAllListeners(Nil, NetworkFilename, DestinationFilename);
        ImageIEN := MagUtilities.MagPiece(DestinationFilename, '|', 2);
        PlaceIEN := MagUtilities.MagPiece(DestinationFilename, '|', 1);
        MagImageManager1.SetImageCached(DestinationFilename);
      //maggmsgf.MagMsg('s','Caching of study complete');
      //LogMsg('s','Caching of study complete');
        magAppMsg('s', 'Caching of study complete'); {JK 10/6/2009 - Maggmsgu refactoring}
      End
      Else
      Begin
        StorageProtocol := GetImageUtility().DetermineStorageProtocol(NetworkFilename);
        // JMW 10/11/2011 - the destination filename is already a local path
//        If StorageProtocol = MagStorageHTTP Then
//          DestinationFilename := GetImageUtility().ExtractUrlFileName(DestinationFilename);
        If Not FileExists(DestinationFilename) Then
        Begin
          If StorageProtocol = MagStorageHTTP Then
          Begin
            AvailableConnection := True;
          End
          Else
          Begin
          // put logic in here to check if a network connection exists and then try to open a secure path...
            If Not CheckOpenNetworkConnections(NetworkFilename) Then
            Begin
              If FMagSecurity.MagOpenSecurePath(NetworkFilename, Msg) Then
              Begin
                NetworkShare := Uppercase(FMagSecurity.ParseServerShare(NetworkFilename));
                OpenNetworkConnections.Add(NetworkShare);
                AvailableConnection := True;
              End;
            End
            Else
            Begin
              AvailableConnection := True;
            End;
          End;

          If AvailableConnection Then
          Begin
            CurrentCacheFile := NetworkFilename;
          //LogMsg('s','Auto-caching file: [' + NetworkFilename + ']');
            magAppMsg('s', 'Auto-caching file: [' + NetworkFilename + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
            aThread := TCacheImage.Create(True, NetworkFilename,
              DestinationFilename, ImgType);
          //aThread.OnLogEvent := OnLogEvent; {JK 10/6/2009 - Maggmsgu refactoring}
            aThread.Resume();
            i := aThread.WaitFor();
          //LogMsg('s','Cache complete [' + NetworkFilename + ']');
            magAppMsg('s', 'Cache complete [' + NetworkFilename + ']'); {JK 10/6/2009 - Maggmsgu refactoring}
            aThread := Nil;
            CurrentCacheFile := '';
          End;
        End
        Else
        Begin
        //LogMsg('s','File [' + extractfilename(destinationfilename) + '] already exists, no caching needed.');
          magAppMsg('s', 'File [' + ExtractFileName(DestinationFilename) + '] already exists, no caching needed.'); {JK 10/6/2009 - Maggmsgu refactoring}
        End;
      End;
    ImageList.Delete(0);
  End;
  OpenNetworkConnections.Clear();
  OpenNetworkConnections := Nil;
  // this is bad... but it should work...
  MagImageManager1.SafeCloseNetworkConnections();

//  dmod.MagFileSecurity.MagCloseSecurity(msg); // this is now done in the ImageManager

End;

Constructor TCacheManager.Create(CreateSuspended: Boolean; Security: TMag4Security); //; DestDirectory : String);
Begin
  Inherited Create(CreateSuspended);
  Priority := TpNormal; //tpIdle;
  OpenNetworkConnections := Tstringlist.Create();
  FMagSecurity := Security;
//  FreeOnTerminate := true;
//  DestinationDirectory := DestDirectory;
End;

Function TCacheManager.CheckOpenNetworkConnections(NetworkFilename: String): Boolean;
Var
  NetworkShare: String;
  i: Integer;
Begin
  If OpenNetworkConnections = Nil Then
  Begin
    OpenNetworkConnections := Tstringlist.Create();
  End;
//  NetworkShare := cMagSecurity.
  //NetworkShare := uppercase(dmod.MagFileSecurity.ParseServerShare(NetworkFilename));
  NetworkShare := Uppercase(FMagSecurity.ParseServerShare(NetworkFilename));
  For i := 0 To OpenNetworkConnections.Count - 1 Do
  Begin
    If OpenNetworkConnections.Strings[i] = NetworkShare Then
    Begin
      Result := True;
      OpenNetworkConnections.Add(NetworkShare);
      // JMW 5/3/06 why is this adding the network location again?
      Exit;
    End;
  End;
  Result := False;

End;

End.
