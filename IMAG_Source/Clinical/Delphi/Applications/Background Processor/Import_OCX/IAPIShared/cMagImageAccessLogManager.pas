Unit cMagImageAccessLogManager;

Interface

Uses
  Classes,
  UMagClasses
  ;

//Uses Vetted 20090929:sysutils

Type
  TMagImageAccessLogManager = Class
  Private
    FImgList: TStrings;
  Public
    Constructor Create();
    Destructor Destroy(); Override;//RLM Fixing MemoryLeak 6/18/2010
    Procedure LogImageAccess(IObj: TImageData);
  End;

Procedure Initialize();

Var
  DMagImageAccessLogManager: TMagImageAccessLogManager;

// could make this thing listen to patient changes, clear the list.  then if
// patient images looked at twice with anther patient in between both image access
// would be logged

Implementation

Uses
  DmSingle,
  SysUtils
  ;

Procedure Initialize();
Begin
  //RLM Fixing MemoryLeak 6/18/2010
  If DMagImageAccessLogManager = Nil Then DMagImageAccessLogManager := TMagImageAccessLogManager.Create();
End;

Constructor TMagImageAccessLogManager.Create();
Begin
  FImgList := Tstringlist.Create();
End;

//dmod.MagDBBroker1.RPMag3Logaction(, IObj);  // JMW 4/21/2005 p45 (added parameter)

Destructor TMagImageAccessLogManager.Destroy;
Begin
  FreeAndNil(FImgList);//RLM Fixing MemoryLeak 6/18/2010
  Inherited;
End;

Procedure TMagImageAccessLogManager.LogImageAccess(IObj: TImageData);
Var
  i: Integer;
  ImgString, Str, LogStr: String;
Begin
  ImgString := IObj.Mag0 + '^' + IObj.ServerName + '^' + Inttostr(IObj.ServerPort);
  For i := 0 To FImgList.Count - 1 Do
  Begin
    Str := FImgList.Strings[i];
    If Str = ImgString Then
    Begin
      Exit;
    End;
  End;

  FImgList.Add(ImgString);

  LogStr := 'IMG^' + Dmod.MagPat1.M_DFN + '^' + IObj.Mag0;
  Dmod.MagDBBroker1.RPMag3Logaction(LogStr, IObj);

End;
Initialization

Finalization
  FreeAndNil(DMagImageAccessLogManager);//RLM Fixing MemoryLeak 6/18/2010
End.
