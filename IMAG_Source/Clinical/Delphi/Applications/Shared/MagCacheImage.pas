Unit MagCacheImage;
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
        ;;  Description: This is a class that runs as a seperate thread to copy
        ;;  an image to the local machine in the background without user
        ;;  interference.
        ;;
        ;;+---------------------------------------------------------------------------------------------------+
*)

Interface

Uses
  Classes
, imaginterfaces
  ;


Type
  TCacheImage = Class(TThread)
  Private
    ImageName: String;
    DestinationName: String;
    FImageType: String;

  Public

    Constructor Create(CreateSuspended: Boolean; ImageFilename: String;
      DestinationFilename: String; ImageType: String);
    Procedure Execute; Override;
    //property OnLogEvent : TMagLogEvent read FOnLogEvent write FOnLogEvent; {JK 10/5/2009 - Maggmsgu refactoring}

  End;

Implementation
Uses
  cMagImageUtility,
  SysUtils,
  UMagClasses
  ;


//RCA 11/11/2011  gek  remove dependency on maggmsgu and VCLZip.  Use interface (if it is declared).
(*  procedure TCacheImage.MyLogMsg(msgType, msg: String; Priority: TMagMsgPriority = magmsgINFO);
begin
if ImsgObj <> nil then  ImsgObj.LogMsg(msgtype,msg,priority);
end;
*)
{JK 10/5/2009 - Maggmsgu refactoring - remove old method}
//procedure TCacheImage.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//end;

Procedure TCacheImage.Execute;
Var
  ImageProtocol: MagStorageProtocol;
  ImgType: Integer;
Begin
  ImageProtocol := GetImageUtility().DetermineStorageProtocol(ImageName);
  ImgType := -1;
  If FImageType <> '' Then
    ImgType := Strtoint(FImageType);

  If (ImageProtocol = MagStorageHTTP) Or (FileExists(ImageName)) Then
  Begin
    If Not FileExists(DestinationName) Then
    Begin
      Try
        If Not (GetImageUtility().MagcopyFile(ImageName, DestinationName, ImgType).FTransferStatus = IMAGE_COPIED) Then
        Begin
          //LogMsg('','Error caching image to [' + ExtractFileName(DestinationName) + ']', MagLogERROR);
          magAppMsg('', 'Error caching image to [' + ExtractFileName(DestinationName) + ']', MagmsgERROR); {JK 10/5/2009 - Maggmsgu refactoring}
        End;
//        copyfile(imagename, destinationName);
      Except
        // JMW 7/21/2005 p45t5 log error messages
        On e: Exception Do
        Begin
          //maggmsgf.MagMsg('s','Error caching image [' + imageName + ']. Error=[' + e.Message + '].');
          //LogMsg('s','Error caching image [' + imageName + ']. Error=[' + e.Message + '].');
          magAppMsg('s', 'Error caching image [' + ImageName + ']. Error=[' + e.Message + '].'); {JK 10/5/2009 - Maggmsgu refactoring}

          // could output some error message or something...
        End;
      End;
    End;
  End
  Else
  Begin
    // JMW 7/21/2005 p45t5 log error messages
    //maggmsgf.MagMsg('s','Unable to cache image [' + imageName + ']. File does not exist on remote server.');
    //LogMsg('s','Unable to cache image [' + imageName + ']. File does not exist on remote server.');
    magAppMsg('s', 'Unable to cache image [' + ImageName + ']. File does not exist on remote server.'); {JK 10/5/2009 - Maggmsgu refactoring}
  End;
End;

Constructor TCacheImage.Create(CreateSuspended: Boolean;
  ImageFilename: String; DestinationFilename: String;
  ImageType: String);
Begin
  Inherited Create(CreateSuspended);
  Priority := TpNormal;
//  FreeOnTerminate := true;
  ImageName := ImageFilename;
  DestinationName := DestinationFilename;
  FImageType := ImageType;
End;

End.
