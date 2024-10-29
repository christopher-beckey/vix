program Mag_App_AnnotBurnImage;

{
Package: MAG - VistA Imaging
WARNING: Per VHA Directive 10-93-142 this unit should not be modified.
Date Created:   April 2012
Site Name: Silver Spring, OIFO
Developers: Jerry Kashtan
[==   program Mag_App_AnnotBurnImage
  Description: Delphi console application to burn an ImageGear ArtX annotation
  layer into an image of type PDF, TIF, BMP, or JPG

  This console application is called by a VISA web service to hide these details from
  the web service consumer.  This console application calls three entry points in
  the MAG_ROI_DLL.dll as follows:

  procedure Delphi_MakeAnnotatedFile(
                       JobID: String;
                       DebugMode: String;
                       ImageFileFullPath: String;
                       XMLFileFullPath: String;
                       OutputBurnedImageFullPath: String;
                       var RetCode: String); stdcall; external 'MAG_ROI_DLL.dll';

  procedure Delphi_AnnotatedJobCompleted; stdcall; external 'MAG_ROI_DLL.dll';

  function Delphi_TestConnection: Boolean; stdcall; external 'MAG_ROI_DLL.dll';

  *** The console app and the DLL must be in the same folder.

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

{$APPTYPE CONSOLE}

uses
  SysUtils;

  procedure Delphi_MakeAnnotatedFile(
                       JobID: String;
                       DebugMode: String;
                       ImageFileFullPath: String;
                       XMLFileFullPath: String;
                       OutputBurnedImageFullPath: String;
                       var RetCode: String); stdcall; external 'Mag_ROI_DLL.dll';

  procedure Delphi_AnnotatedJobCompleted; stdcall; external 'Mag_ROI_DLL.dll';

  function Delphi_TestConnection: Boolean; stdcall; external 'Mag_ROI_DLL.dll';

var
  JobID, DebugMode, ImageFileFullPath, XMLFileFullPath, OutputBurnedImageFullPath: String;
  DebugModeDelphi: Boolean;
  ReturnCode: String;
  i: Integer;
  S: String;
begin
  try
    JobID                     := ParamStr(1);
    DebugMode                 := Uppercase(ParamStr(2));
    ImageFileFullPath         := ParamStr(3);
    XMLFileFullPath           := ParamStr(4);
    OutputBurnedImageFullPath := ParamStr(5);

    {'TD' is True-Delphi. Delphi console debugging needs a Readln to keep the console from closing at the end of the job
     and losing the debug lines. Jave console debugging, for the purpose of running this on a server needs unattended
     operation.  Java server operation should not have Readln statements executed!}
    DebugModeDelphi := False;
    if (DebugMode <> 'T') and (DebugMode <> 'TD') then
      DebugMode := 'F'
    else
    if DebugMode = 'TD' then
    begin
      DebugMode := 'T';
      DebugModeDelphi := True;
    end;

    if DebugMode = 'T' then
      if Delphi_TestConnection then
        Writeln('Delphi_TestConnection Returned True')
      else
        Writeln('Delphi_TestConnection Returned False');

    for i := 1 to ParamCount do
      S := S + 'Param('+ IntToStr(i) + ') =  ' + ParamStr(i) + #13#10;

    if DebugMode = 'T' then
      Writeln(S);

    if DebugModeDelphi then
    begin
      Writeln('Press enter to continue...');
      Readln;
    end;

    {Call the ROI Disclosure DLL}
    Delphi_MakeAnnotatedFile(
                       JobID,
                       DebugMode,
                       ImageFileFullPath,
                       XMLFileFullPath,
                       OutputBurnedImageFullPath,
                       ReturnCode);

    if DebugModeDelphi then
    begin
      Writeln('Press enter to continue...');
      Readln;
    end;

    Delphi_AnnotatedJobCompleted;

    if DebugMode = 'T' then
      Writeln('Job ' + JobID + ' has completed. Return Code = ' + ReturnCode);

    if DebugModeDelphi then
    begin
      Writeln('You are in debug mode (Delphi). Press enter to terminate this run.');
      Readln;
    end;

    if ReturnCode <> '0' then
      Halt(1)
    else
      Halt(0);

  except
    on E:Exception do
    begin
      Writeln(E.Classname, ': ', E.Message);
      Halt(2);
    end;
  end;
end.
