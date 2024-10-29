Unit cMagImageListManager;

Interface

Uses
  Classes,
  cMagDBBroker,
  cMagImageList,
//cMagLogManager, {JK 10/5/2009 - Maggmsgu refactoring - deprecated unit}
  ImagInterfaces,
  Maggmsgu,
  UMagClasses
  ;

//Uses Vetted 20090929:sysUtils, umagutils

Type
  TMagImageListManager = Class(TComponent, IMagObserver)
  Private
    ImageList: Tlist;
    FDBBroker: TMagDBBroker;

    //FOnLogEvent : TMagLogEvent;  {JK 10/5/2009 - Maggmsgu refactoring}
    //procedure LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);  {JK 10/5/2009 - MaggMsgu refactoring - remove old method}
    //procedure SetLogEvent(LogEvent : TMagLogEvent);   {JK 10/5/2009 - MaggMsgu refactoring - remove old method}
  Public
    Constructor Create(AOwner: TComponent); Override;
    Procedure UpDate_(SubjectState: String; Sender: Tobject);
    Function LoadStudy(IObj: TImageData): TMagImageList; Overload;
    Procedure LoadStudy(IObj: TImageData; ImgList: TMagImageList); Overload;

    Function GetStudy(IObj: TImageData): TMagImageList;
    Function GetOrCreateStudy(IObj: TImageData): TMagImageList;

//    function getOrCreateStudy(StudyIEN : String) : TMagImageList;
//    function getStudy(StudyIEN : String) : TMagImageList;

    Property M_DBBroker: TMagDBBroker Read FDBBroker Write FDBBroker;
    Destructor Destroy; Override; { Public declarations }

    //property OnLogEvent : TMagLogEvent read FOnLogEvent write SetLogEvent;  {JK 10/5/2009 - MaggMsgu refactoring - remove old method}
  End;

Implementation

Uses
  DmSingle,
  Umagutils8
  ;

Constructor TMagImageListManager.Create(AOwner: TComponent);
Begin
  Inherited;
End;

{JK 10/5/2009 - MaggMsgu refactoring - remove old method}
//procedure TMagImageListManager.LogMsg(MsgType : String; Msg : String; Priority : TMagLogPriority = MagLogINFO);
//begin
//  if Assigned(OnLogEvent) then
//    OnLogEvent(self, MsgType, Msg, Priority);
//end;

{JK 10/5/2009 - MaggMsgu refactoring - remove old method}
//procedure TMagImageListManager.SetLogEvent(LogEvent : TMagLogEvent);
//begin
//  FOnLogEvent := LogEvent;
//  // set child objects with loggers (if needed)
//end;

Destructor TMagImageListManager.Destroy;
Begin
  Inherited;
  Dmod.MagPat1.Detach_(Self);
  If ImageList <> Nil Then
    ImageList.Free();
End;

// responds to patient change, clears the lists

Procedure TMagImageListManager.UpDate_(SubjectState: String; Sender: Tobject);
Begin
  maglogger.LogMsg('s', '**--**-- -- -- TMagImageListManager.Update_  state ' + SubjectState);
  If SubjectState = '' Then Exit;
  If SubjectState = '-1' Then Exit;

  If ImageList <> Nil Then
    ImageList.Clear();
   { TODO -oGarrett -cMemory Leak : Mem Leak, should we be Freeing here ? and then recreate. ? }
  ImageList := Tlist.Create();

End;

Function TMagImageListManager.LoadStudy(IObj: TImageData): TMagImageList;
Begin
  Result := TMagImageList.Create(Self);
  Result.Server := IObj.ServerName;
  Result.Port := IObj.ServerPort;
  Result.StudyObj := TImageData.Create();
  Result.StudyObj.MagAssign(IObj);
  LoadStudy(IObj, Result);
End;

Procedure TMagImageListManager.LoadStudy(IObj: TImageData; ImgList: TMagImageList);
Var
  Temp: Tstringlist;
Begin
  If FDBBroker = Nil Then Exit;
  Temp := Tstringlist.Create;
  Try
    Begin
      // this should work even for remote images...
      FDBBroker.RPMaggGroupImages(IObj, Temp);
      //LogMsg('', 'Image Group selected, accessing Group Images...');
      MagLogger.LogMsg('', 'Image Group selected, accessing Group Images...'); {JK 10/5/2009 - MaggMsgu refactoring}
      If Temp.Count = 1 Then
        //LogMsg('s', magpiece(temp.strings[0], '^', 2));
        MagLogger.LogMsg('s', MagPiece(Temp.Strings[0], '^', 2)); {JK 10/5/2009 - MaggMsgu refactoring}
      FDBBroker.RPMaggQueImageGroup('A', IObj);
    End;

    If (Temp.Count = 0) Or (Temp.Count = 1) Then
    Begin
        //LogMsg('D', 'ERROR: Accessing Group Images.  See VistA Error Log.');
      MagLogger.LogMsg('D', 'ERROR: Accessing Group Images.  See VistA Error Log.'); {JK 10/5/2009 - MaggMsgu refactoring}
      Exit;
    End;
    Temp.Delete(0);
    ImgList.LoadGroupList(Temp, IObj.Mag0, '');
    ImageList.Add(ImgList);
    //maggmsgf.magmsg('', 'Loading Images to group window');
  Finally
    Temp.Free();
  End;

End;

Function TMagImageListManager.GetStudy(IObj: TImageData): TMagImageList;
Var
  ImgList: TMagImageList;
  i: Integer;
Begin
  If ImageList = Nil Then Exit;
  For i := 0 To ImageList.Count - 1 Do
  Begin
    ImgList := ImageList.Items[i];
    // this should guarantee images are from the correct DB
    If (ImgList.Groupien = IObj.Mag0) And (ImgList.Server = IObj.ServerName) And (ImgList.Port = IObj.ServerPort) Then
    Begin
      Result := ImgList;
      Exit;
    End;
  End;
  Result := Nil;
End;

Function TMagImageListManager.GetOrCreateStudy(IObj: TImageData): TMagImageList;
Begin
  Result := GetStudy(IObj);
  If Result <> Nil Then Exit;
  Result := LoadStudy(IObj);
End;

{

function TMagImageListManager.getOrCreateStudy(StudyIEN : String) : TMagImageList;
begin

end;

function TMagImageListManager.getStudy(StudyIEN : String) : TMagImageList;
begin

end;
}

End.
