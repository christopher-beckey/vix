unit cMagCapMsg;

interface
uses
 Classes,

 umagdefinitions,
 imaginterfaces,
 maggmsgu;



 type

 TMagAppMessageLog = Class(TInterfacedObject, IMagMsg)
  Private
    procedure OpenLogger;
        //
  Public
     Constructor Create();
    Destructor Destroy; Override;

   procedure Log(loglvl: TmagMsgLvl; msg: String);
    procedure LogMsg(Code: String; Msg: String; msgprior: TMagMsgPriority = magmsgINFO) ;
    procedure LogMsgs(Code: String; Msgs: Tstringlist; msgprior: TMagMsgPriority = magmsgINFO);
    procedure MagMsg(Code, Msg: String);
    procedure MagMsgs(Code: String; Msgs: Tstringlist);
    procedure ShowLog;
    Procedure SetPrivLevel(Level: TMagMsgPrivLevel);
 End;

 var
 MagCapMsg : TMagAppMessageLog;

implementation

{ TMagAppMessageLog }



procedure TMagAppMessageLog.OpenLogger;
begin
{
          (PrivLevel: TPrivLevel;  LogFileName: String;  AutoLogToFile: Boolean;
           ZipPassword: String;  ZipDaysToKeep: Integer;   MaxFileSizeBytes: Cardinal;
           AppTitle: String;  WriteImmediate: Boolean;
                                                        RetroStyle: Boolean = True);

}
  MagLogger.Open(plUser,  'Capture_Log.zip',  True,
                  '',    30,  10000000,
                   'VistA Imaging Clinical Capture',  true);  //    false);  //  TRUE for the field
                                                               // false is for TESTING 129
end;

constructor TMagAppMessageLog.Create();
begin
  inherited;
//
OpenLogger;

end;

destructor TMagAppMessageLog.Destroy;
begin
{TODO : GET ERROR HERE When other errors.. connection lost,   etc.}

  MagLogger.Close;
  inherited;
end;

procedure TMagAppMessageLog.Log(loglvl: TmagMsgLvl; msg: String);
var loggerlvl : TMagLoggerLevel;
begin
// this typecast , instead of the Case,  in next few procedures for messageing.
   MagLogger.Log(TMagLoggerLevel(loglvl),msg);


end;


Procedure TMagAppMessageLog.LogMsg(Code: String; Msg: String; msgprior: TMagMsgPriority = magmsgINFO);
Var
  LoggerPrior: TMagLogPriority;
Begin

  Maglogger.LogMsg(Code, Msg, TmaglogPriority(msgprior));

End;

Procedure TMagAppMessageLog.LogMsgs(Code: String; Msgs: Tstringlist; msgprior: TMagMsgPriority = magmsgINFO);
Var
  LoggerPrior: TMagLogPriority;
Begin
  Maglogger.LogMsgs(Code, Msgs, TmaglogPriority(msgprior));

End;

Procedure TMagAppMessageLog.MagMsg(Code, Msg: String);
Begin
  Maglogger.magmsg(Code, Msg);
End;

Procedure TMagAppMessageLog.MagMsgs(Code: String; Msgs: Tstringlist);
Begin
  Maglogger.MagMsgs(Code, Msgs);
End;

Procedure TMagAppMessageLog.ShowLog;
Begin
 Maglogger.Show;
End;

Procedure TMagAppMessageLog.SetPrivLevel(Level: TMagMsgPrivLevel);
Begin
{  TMagMsgPrivLevel = (magmsgprivAdmin, magmsgprivUser, magmsgprivUnk);}
{  TPrivLevel = (plAdmin, plUser, plUnknown);}
   maglogger.SetPrivLevel(TPrivLevel(level));

End;

end.

(*
procedure TfrmCapMain.Log(loglvl: TmagMsgLvl; msg: String);
var loggerlvl : TMagLoggerLevel;
begin
{
  TMagLoggerLevel = (DEBUG, TRACE, Marker, LOGGER, Warn, ERROR, Info, FATAL, COMM, COMMERR, CCOW, SYS, NONSYS);
 }
{ NOT INTEBGER ANYMORE   case loglvl of
    0 : loggerlvl :=  DEBUG;
    1 :  loggerlvl :=  TRACE  ;
    2 :  loggerlvl :=  Marker  ;
    3 :  loggerlvl :=  LOGGER ;
    4 :  loggerlvl :=  Warn ;
  end; {case}
  }

case loglvl of
  magmsglvlDEBUG   : loggerlvl := DEBUG;
  magmsglvlTRACE   : loggerlvl := TRACE;
  magmsglvlMarker  : loggerlvl := Marker;
  magmsglvlLOGGER  : loggerlvl := LOGGER;
  magmsglvlWarn    : loggerlvl := Warn;
  magmsglvlERROR   : loggerlvl := ERROR;
  magmsglvlInfo    : loggerlvl := Info;
  magmsglvlFATAL   : loggerlvl := FATAL;
  magmsglvlCOMM    : loggerlvl := COMM;
  magmsglvlCOMMERR : loggerlvl := COMMERR;
  magmsglvlCCOW    : loggerlvl := CCOW;
  magmsglvlSYS     : loggerlvl := SYS;
  magmsglvlNONSYS  : loggerlvl := NONSYS;
end;


   MagLogger.Log(loggerlvl,msg);
  {testing for now,  this needs finished.}
end;


Procedure TfrmCapMain.LogMsg(Code: String; Msg: String; msgprior: TMagMsgPriority = magmsgINFO);
Var
  LoggerPrior: TMagLogPriority;
Begin
{
  TMagLogPriority = (MagLogDEBUG, MagLogINFO, MagLogWARN, MagLogERROR, MagLogFATAL);
}
  Case msgprior Of
    magmsgDebug : loggerPrior := MagLogDebug;
    magmsgInfo : loggerPrior := MagLogINFO;
    magmsgWarn : loggerPrior := MagLogWARN;
    magmsgError : loggerPrior := MagLogERROR;
    magmsgFatal : loggerPrior := MagLogFATAL;
  End; {case }
  Maglogger.LogMsg(Code, Msg, loggerPrior);
End;

Procedure TfrmCapMain.LogMsgs(Code: String; Msgs: Tstringlist; msgprior: TMagMsgPriority = magmsgINFO);
Var
  LoggerPrior: TMagLogPriority;
Begin
{
  TMagLogPriority = (MagLogDEBUG, MagLogINFO, MagLogWARN, MagLogERROR, MagLogFATAL);
}
  Case msgprior Of
    magmsgDebug : loggerPrior := MagLogDebug;
    magmsgInfo : loggerPrior := MagLogINFO;
    magmsgWarn : loggerPrior := MagLogWARN;
    magmsgError : loggerPrior := MagLogERROR;
    magmsgFatal : loggerPrior := MagLogFATAL;
  End; {case }
  Maglogger.LogMsgs(Code, Msgs, LoggerPrior);
End;

Procedure TfrmCapMain.MagMsg(Code, Msg: String);
Begin
  Maglogger.magmsg(Code, Msg);
End;
// Procedure MagMsgs(Code: String; Msgs: Tstringlist)
Procedure TfrmCapMain.MagMsgs(Code: String; Msgs: Tstringlist);
Begin
  Maglogger.MagMsgs(Code, Msgs);
End;

Procedure TfrmCapMain.ShowLog;
Begin
 Maglogger.Show;
End;

Procedure TfrmCapMain.SetPrivLevel(Level: Integer);
Begin
imsgobj.SetPrivLevel(level);

{above shouldn't be called, because frmCapMain isn't the interfaced object for messageing anymore.
  the new object cMagCapMsg is.}

    {   1 = user ,   0 = admin}
{  Case Level Of
    0: maglogger.SetPrivLevel(plAdmin);
    1: maglogger.SetPrivLevel(plUser);
  Else
    maglogger.SetPrivLevel(plUser);
  End; {case}
}
End;
*)
