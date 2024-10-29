unit MagROILogger;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   March, 2012
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==   unit MagROILogger.pas
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
  SysUtils,
  Classes,
  Dialogs;

type
  TMagLoggerLevel = (Debug, TraceIn, TraceOut, Marker, Warn, Error, Excpt, Info, Fatal, Comm, CommErr, CCOW, SYS, NONSYS);
  TRuntime = (rtConsoleApp, rtGuiApp);

  TLogMgr = class(TObject)
  private
    F: TextFile;
    FManifestFileLocation: String;
    FDebugMode: Boolean;
    FRuntime: TRuntime;
    function LevelToStr(Level: TMagLoggerLevel): String;
  public
    procedure Open_Manifest(FN: String; DebugMode: Boolean; RuntimeType: TRuntime);
    procedure Close_Manifest;
    procedure Log(Level: TMagLoggerLevel; Msg: String);
  end;

  TLogger = class
  public
    class procedure OpenManifest(FN: String; DebugMode: Boolean; RuntimeType: TRuntime);
    class procedure CloseManifest;
    class procedure Log(Level: TMagLoggerLevel; Msg: String);
  end;


implementation

var
  Logger: TLogMgr; {Make a global Logger reference available to the DLL since everyone needs to log messages}

{ TLogger }

class procedure TLogger.OpenManifest(FN: String; DebugMode: Boolean; RuntimeType: TRuntime);
begin
//  if TLogMgr <> nil then
  if Logger <> nil then
    FreeAndNil(Logger);

  Logger := TLogMgr.Create;
  Logger.Open_Manifest(FN, DebugMode, RuntimeType);
end;

class procedure TLogger.CloseManifest;
begin
  if Logger <> nil then
    Logger.Close_Manifest;

//  Logger.Free;
  FreeAndNil(Logger);
end;

class procedure TLogger.Log(Level: TMagLoggerLevel; Msg: String);
begin
  if Logger <> nil then
    Logger.Log(Level, Msg);
end;

procedure TLogMgr.Open_Manifest(FN: string; DebugMode: Boolean; RuntimeType: TRuntime);
begin
  FManifestFileLocation := FN;

  FDebugMode := DebugMode;
  FRuntime   := RuntimeType;

  AssignFile(F, FManifestFileLocation);
  try
    Rewrite(F);
  except
    on E:Exception do
      writeln('TLogMgr.Open_Manifest on file: '+ FN + #13#10 + 'Exception: ' + E.Message);
  end;
end;

procedure TLogMgr.Log(Level: TMagLoggerLevel; Msg: String);
var
  S: String;
begin
  try
    if Logger.FDebugMode = False then
    begin
      if Level = Info then
        Writeln(F, Msg)
    end
    else
    begin
      case FRuntime of
        rtConsoleApp:
          begin
            case Level of
              Info, Excpt, Warn:  Writeln(F, LevelToStr(Level) + ' ' + Msg);
              else                Writeln(LevelToStr(Level) + ' ' + Msg);
            end;
          end
        else Writeln(F, LevelToStr(Level) + ' ' + Msg);
      end;
    end;
  except
    on E:Exception do
      Writeln('TLogMgr.Log message = ' + Msg + #13#10 + 'Exception = ' + E.Message);
  end;
end;

procedure TLogMgr.Close_Manifest;
begin
  try
    CloseFile(F);
  except
    on E:Exception do
      Writeln('TLogMgr.Close_Manifest exception = ' + E.Message);
  end;
end;

function TLogMgr.LevelToStr(Level: TMagLoggerLevel): String;
begin
  case Level of
    Debug:    Result := 'DEBUG:    ';
    TraceIn:  Result := 'ENTERED:  ';
    TraceOut: Result := 'EXITED:   ';
    Marker:   Result := 'MARKER:   ';
    Warn:     Result := 'WARN:     ';
    Error:    Result := '***ERROR: ';
    Info:     Result := '';
    Fatal:    Result := 'FATAL:    ';
    Comm:     Result := 'COMM:     ';
    CommErr:  Result := 'COMMERR:  ';
    CCOW:     Result := 'CCOW:     ';
    SYS:      Result := 'SYS:      ';
    NONSYS:   Result := 'NONSYS:   ';
    EXCPT:    Result := '<EXCEPTION>: ';
  end;
end;

end.
